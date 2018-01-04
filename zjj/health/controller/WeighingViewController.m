//
//  WeighingViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/13.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "WeighingViewController.h"
#import "WWXBlueToothManager.h"
#import "HealthModel.h"
@interface WeighingViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLb;
@property (weak, nonatomic) IBOutlet UILabel *statuslb;
@property (weak, nonatomic) IBOutlet UIButton *lLJBtn;
@property (weak, nonatomic) IBOutlet UIImageView *chengImageView;
@property (weak, nonatomic) IBOutlet UIImageView *didRodeImageView;

@property (weak, nonatomic) IBOutlet UIImageView *measurementImageView;
@property (weak, nonatomic) IBOutlet UIView *measurementView;

@property (weak, nonatomic) IBOutlet UIView *WeighterrorView;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;



@end

@implementation WeighingViewController
{
    double angle;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [self.measurementImageView.layer removeAllAnimations];
    [self.didRodeImageView .layer removeAllAnimations];
    [[WWXBlueToothManager shareInstance]stop];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currItem = [[HealthItem alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    angle =1;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[SubUserItem shareInstance].headUrl] placeholderImage:getImage(@"head_default")];
    self.nickNameLb.text = [NSString stringWithFormat:@"您好,%@",[SubUserItem shareInstance].nickname];
    self.lLJBtn.layer.masksToBounds = YES;
    self.lLJBtn.layer.cornerRadius = 5;
    self.lLJBtn.layer.borderWidth= 2;
    self.lLJBtn.layer.borderColor = [UIColor colorWithWhite:1 alpha:1].CGColor;

    
    // Do any additional setup after loading the view from its nib.
    [self startAnimation];
    [self didUpdateinfo];
    [self startAnimation2];
}

//UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
//view.center  =self.view.center;
//view.backgroundColor = [UIColor redColor];
//[self.view addSubview:view];

    
    
-(void)startAnimation
{
    CGFloat circleByOneSecond = 1.5f;
    // 执行动画
    [UIView animateWithDuration:1.f / circleByOneSecond
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.didRodeImageView.transform = CGAffineTransformRotate(self.didRodeImageView.transform, M_PI_2);
                     }
                     completion:^(BOOL finished){
                         [self startAnimation];
                     }];
}

-(void)startAnimation2
{
    CGFloat circleByOneSecond = 1.5f;
    
    // 执行动画
    [UIView animateWithDuration:1.f / circleByOneSecond
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.measurementImageView.transform = CGAffineTransformRotate(self.measurementImageView.transform, M_PI_2);
                     }
                     completion:^(BOOL finished){
                         [self startAnimation2];
                     }];
}

-(void)didUpdateinfo
{
    self.statuslb.text = @"请赤脚上称。。。";
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    [[WWXBlueToothManager shareInstance]startScanWithStatus:^(NSString *statusString) {
        self.statuslb.text =statusString;
        if ([statusString isEqualToString:@"设备已连接"]) {
            self.measurementView.hidden = NO;
        }
    } success:^(NSDictionary *dic) {
//        self.statuslb.text = @"测量成功！开始上传...";
        [[WWXBlueToothManager shareInstance]stop];

        float nowWeight = [[dic safeObjectForKey:@"mWeight"]floatValue];
        float firstWeight = self.currItem.weight;
        float  nowWaterWeight = [[dic safeObjectForKey:@"mWater"]floatValue]/100*nowWeight;
        float  firstWaterWeight = self.currItem.waterWeight;

        if (firstWaterWeight>0&& fabsf(nowWaterWeight-firstWaterWeight)>1.5) {
            [self showWaterErrorAlertWithDict:dic];
            return;
        }
        if (firstWeight>0&&fabsf(nowWeight-firstWeight)>5) {
            [self showWeightErrorAlertWithDict:dic];
            return;
        }
        
        [[HealthModel shareInstance]setLogInUpLoadString:@"上传成功"];
        [[HealthModel shareInstance]UpdateBlueToothInfo];
        
        [self updataInfoWithDict:dic];
        
    } faile:^(NSError *error, NSString *errMsg) {
        [SVProgressHUD dismiss];
        [[WWXBlueToothManager shareInstance]stop];
        if ([errMsg isEqualToString:@"连接超时"]) {
            self.errorLabel.text = @"未能成功连接脂将军体脂秤，请重新连接它。";
        }else{
        self.errorLabel.text = errMsg;
        }
        self.measurementView.hidden = YES;
        self.WeighterrorView.hidden =NO;

        
//        [[UserModel shareInstance] showErrorWithStatus:errMsg];
        [[HealthModel shareInstance]setLogInUpLoadString:[NSString stringWithFormat:@"上传失败--error---%@",error]];
        [[HealthModel shareInstance]UpdateBlueToothInfo];
    }];
    
}
#pragma mark ---healthMainCelldelegate
/**
 * 上传数据
 */

-(void)updataInfoWithDict:(NSDictionary *)dic
{
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setDictionary:dic];
    [param safeSetObject:[UserModel shareInstance].subId forKey:@"subUserId"];
    [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    
    DLog(@"上传数据---%@",param);
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/evaluatData/addEvaluatData.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        
        self.statuslb.text = @"上传成功！";
        NSDictionary * dataDict= [dic safeObjectForKey:@"data"];
        
        if (self.delegate &&[self.delegate respondsToSelector:@selector(weightingSuccessWithSubtractMaxWeight:dataId:shareDict:)]) {
            [self.delegate weightingSuccessWithSubtractMaxWeight:[dataDict safeObjectForKey:@"subtractMaxWeight"]dataId:[dataDict safeObjectForKey:@"DataId"]shareDict:dataDict];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        DLog(@"url-app/evaluatData/addEvaluatData.do  dic--%@",dic);
        
    } failure:^(NSError *error) {
        [[UserModel shareInstance] showErrorWithStatus:@"上传失败"];
        self.measurementView.hidden = YES;
        self.errorLabel.text = @"上传数据失败，请检查网络后重新体测";
        self.WeighterrorView.hidden =NO;

        DLog(@"url-app/evaluatData/addEvaluatData.do  dic--%@",error);
        
    }];
}

- (IBAction)didClickClose:(id)sender {
    [[WWXBlueToothManager shareInstance]stop];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)didClickLj:(id)sender {
    self.WeighterrorView.hidden =YES;
    self.measurementView.hidden = YES;

    [self didUpdateinfo];
}

#pragma mark ---显示各种弹窗

-(void)showWaterErrorAlertWithDict:(NSDictionary *)dict
{
    NSString * info = @"系统检测到您本次测量状况异常，请检查您的测量状态，按照正确的方法使用体脂秤。（体脂秤使用过程中忌穿鞋袜，请将体脂秤放在坚硬平整的地面上，周边不可有除手机外的电子产品。）";
    UIAlertController * lr = [UIAlertController alertControllerWithTitle:@"" message:info preferredStyle:UIAlertControllerStyleAlert];
    [lr addAction:[UIAlertAction actionWithTitle:@"这是真实数据" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self updataInfoWithDict:dict];
            
        }]];
    [lr addAction:[UIAlertAction actionWithTitle:@"重新体测" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[WWXBlueToothManager shareInstance]stop];
        self.measurementView.hidden = YES;
        self.errorLabel.text = @"请重新体测";
        self.WeighterrorView.hidden =NO;
        
    }]];
    
    [self presentViewController:lr animated:YES completion:nil];
    
}

-(void)showWeightErrorAlertWithDict:(NSDictionary *)dict
{
    NSString * info = [NSString stringWithFormat:@"您的体重为%.1f斤，与上次测量相差过大，如果不是本人请添加子用户，设置符合自身条件的数据进行测量，如果是您本人请继续使用。",[[dict objectForKey:@"weight"]floatValue]];
    NSString * title = [NSString stringWithFormat:@"您是%@本人吗？",[UserModel shareInstance].nickName];
    UIAlertController * lr = [UIAlertController alertControllerWithTitle:title message:info preferredStyle:UIAlertControllerStyleAlert];
    [lr addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        [self updataInfoWithDict:dict];

    }]];
    [lr addAction:[UIAlertAction actionWithTitle:@"去添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[WWXBlueToothManager shareInstance]stop];
        [self dismissViewControllerAnimated:self completion:nil];
    }]];
    
    [self presentViewController:lr animated:YES completion:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
