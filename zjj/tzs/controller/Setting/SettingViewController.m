//
//  SettingViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "SettingViewController.h"
#import "TZSEditViewController.h"
#import "AddressListViewController.h"
#import "BaseWebViewController.h"
#import "EidtViewController.h"
#import "TZSDingGouViewController.h"
#import "TZSMyDingGouViewController.h"
#import "TZSTeamDGViewController.h"
#import "QrCodeView.h"
#import "TZSDeliveryViewController.h"
#import "TZSDistributionViewController.h"
#import "AddTradingPsController.h"

@interface SettingViewController ()<qrcodeDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation SettingViewController
{
    UIView * ImagespView;
    UIImageView * bigHeadImageView;
    BOOL isBigHeadImage;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
//    self.navigationController.navigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self getbalance];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setShardow];
    self.scrollView.contentSize = CGSizeMake(0, 0);
    self.headImageView.layer.borderWidth = 1;
    self.headImageView.layer.borderColor=[UIColor orangeColor].CGColor;

    isBigHeadImage = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterOtherViewContoller:) name:@"shouyintaibackToViewController" object:nil];
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].headUrl] placeholderImage:[UIImage imageNamed:@"logo_"]];
    self.nameLabel.text = [UserModel shareInstance].nickName;
    self.LevelImageView.image = [[UserModel shareInstance]getLevelImage];
    self.tzsLabel.text = [UserModel shareInstance].gradeName;
    self.cerLabel.text = [UserModel shareInstance].isAttest;
    // Do any additional setup after loading the view from its nib.
}

//进入其他页面
-(void)enterOtherViewContoller:(NSNotification*)noti
{
    int payType = [[noti.userInfo safeObjectForKey:@"payType"]intValue];
    if (payType ==2) {
        [self mySend:nil];
    }
    else if (payType ==3)
    {
        [self mybuy:nil];
    }
}
//刷新个人信息
-(void)refreshUserInfo
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].headUrl] placeholderImage:[UIImage imageNamed:@"logo_"]];
    self.nameLabel.text = [UserModel shareInstance].nickName;
    self.LevelImageView.image = [[UserModel shareInstance]getLevelImage];
    self.tzsLabel.text = [UserModel shareInstance].gradeName;
    self.cerLabel.text = [UserModel shareInstance].isAttest;
    self.assetsLabel.text = [NSString stringWithFormat:@"(余额:￥%.2f)",[[UserModel shareInstance].balance doubleValue]];
    [self showSetPassword];
    
}

-(void)setShardow
{
    [self.firstView  setViewShadow];
    [self.secondView setViewShadow];
    [self.thirdView  setViewShadow];
    [self.forthView  setViewShadow];
}
//获取个人信息
-(void)getbalance
{
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/user/getUserInfo.do" paramters:nil success:^(NSDictionary *dic) {
        DLog(@"dic--%@",dic);

        [[UserModel shareInstance]setTzsInfoWithDict:[dic safeObjectForKey:@"data"]];
        [self refreshUserInfo];
        
    } failure:^(NSError *error) {
        DLog(@"error--%@",error);
    }];
}
-(void)getWaitPayCount
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/orderList/statusCount.do" paramters:param success:^(NSDictionary *dic) {
        DLog(@"dic--%@",dic);

        
    } failure:^(NSError *error) {
        DLog(@"error--%@",error);
    }];

}
-(void)showSetPassword
{
    NSString * tradePasswordStr = [UserModel shareInstance].tradePassword;
    
    if (!tradePasswordStr||tradePasswordStr.length<1) {
        UIAlertController * al =[UIAlertController alertControllerWithTitle:nil message:@"您还没有交易密码，是否确认添加？" preferredStyle:UIAlertControllerStyleAlert];
        
        
        [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        
        
        [al addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.navigationController.navigationBarHidden =NO;
            AddTradingPsController * at =[[AddTradingPsController alloc]init];
            at.hidesBottomBarWhenPushed =YES;
            self.navigationController.navigationBarHidden =NO;
            [self.navigationController pushViewController:at animated:YES];
        }]];
        
        
        
        [self presentViewController:al animated:YES completion:nil];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --点击头像
- (IBAction)showHeadImage:(id)sender {
    return;
    if (!ImagespView) {
        ImagespView =[[UIView alloc]initWithFrame:self.view.bounds];
        ImagespView.backgroundColor = RGBACOLOR(0, 0, 0, 0.7);
        [ImagespView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenMe) ]];
        
        bigHeadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 130, 60, 60)];
        [bigHeadImageView sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].headUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
        bigHeadImageView.userInteractionEnabled = YES;
        
        [ImagespView addSubview:bigHeadImageView];
        [self.view.window addSubview:ImagespView];
    }
    ImagespView.hidden = NO;
    
    [UIView animateWithDuration:.5 animations:^{
        bigHeadImageView.frame= CGRectMake(0, (JFA_SCREEN_HEIGHT-JFA_SCREEN_WIDTH)/2, JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH);
    } completion:nil];
}
-(void)hiddenMe
{
    [UIView animateWithDuration:.5 animations:^{
        bigHeadImageView.frame= CGRectMake(20, 130, 60, 60);
    } completion:^(BOOL finished) {
        ImagespView.hidden = YES;
    }];
}


#pragma mark-- 邀请
- (IBAction)didInvitation:(id)sender {
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"QrCodeView"owner:self options:nil];
    
    QrCodeView *rcodeView = [nib objectAtIndex:0];
    rcodeView.delegate = self;
    rcodeView.frame = self.view.frame;
    [rcodeView setInfoWithDict:nil];
    [self.view.window addSubview: rcodeView];
}
-(void)removeImage:(UIGestureRecognizer*)tap
{
    UIImageView *img =(UIImageView *)[self.view viewWithTag:9527];
    [img removeFromSuperview];
}


#pragma mark--订购
- (IBAction)buy:(id)sender {
    self.navigationController.navigationBarHidden =NO;
    TZSDingGouViewController *dg =[[TZSDingGouViewController alloc]init];
    
    dg.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dg animated:YES];
}
#pragma mark--我的订购

- (IBAction)mybuy:(id)sender {
    self.navigationController.navigationBarHidden =NO;
    TZSMyDingGouViewController *md =[[TZSMyDingGouViewController alloc]init];
    md.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:md animated:YES];
}
#pragma mark--已订购
- (IBAction)alsoBuy:(id)sender {
    self.navigationController.navigationBarHidden =NO;
    BaseWebViewController *web =[[BaseWebViewController alloc]init];
    web.title = @"已购服务";
    web.hidesBottomBarWhenPushed =YES;
    web.urlStr = @"app/fatTeacher/orderService.html";
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark--配送服务
- (IBAction)send:(id)sender {
    self.navigationController.navigationBarHidden =NO;
    TZSDeliveryViewController *ed =[[TZSDeliveryViewController alloc]init];
    ed.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ed animated:YES];
}
#pragma mark--我的配送
- (IBAction)mySend:(id)sender {
    self.navigationController.navigationBarHidden =NO;
    TZSDistributionViewController * ds =[[TZSDistributionViewController alloc]init];
    ds.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ds animated:YES];
    
}
#pragma mark--地址管理
- (IBAction)address:(id)sender {
    self.navigationController.navigationBarHidden =NO;
    AddressListViewController *ad =[[AddressListViewController alloc]init];
    ad.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ad animated:YES];
}
#pragma mark--充值
- (IBAction)topUp:(id)sender {
    self.navigationController.navigationBarHidden =NO;
    BaseWebViewController *web = [[BaseWebViewController alloc]init];
    web.urlStr = @"app/fatTeacher/recharge.html";
    //payType 1 消费者订购 2 配送订购 3 服务订购 4 充值
    web.payType =4;
    web.title  =@"充值";
    web.rightBtnUrl = @"app/fatTeacher/rechargeRecord.html";
    web.rightBtnTitle = @"查看明细";
    web.hidesBottomBarWhenPushed= YES;
    [self.navigationController pushViewController:web animated:YES];

}
#pragma mark--交易记录
- (IBAction)TransactionRecords:(id)sender {
    self.navigationController.navigationBarHidden =NO;
    BaseWebViewController *web =[[BaseWebViewController alloc]init];
    web.urlStr =@"app/fatTeacher/tradingRecord.html";
    web.hidesBottomBarWhenPushed =YES;
    web.title = @"交易记录";
    [self.navigationController pushViewController:web animated:YES];

}
#pragma mark--钱包管理
- (IBAction)walletManagement:(id)sender {
    
    
    self.navigationController.navigationBarHidden =NO;

    BaseWebViewController *web =[[BaseWebViewController alloc]init];
    web.urlStr = @"app/fatTeacher/dailyCash.html";
    web.hidesBottomBarWhenPushed =YES;
    web.title = @"钱包管理";

    [self.navigationController pushViewController:web animated:YES];

}



#pragma mark--我的收益
- (IBAction)myIncome:(id)sender {
    self.navigationController.navigationBarHidden =NO;
    BaseWebViewController *web =[[BaseWebViewController alloc]init];
    web.urlStr = @"app/fatTeacher/myEarnings.html";
    web.hidesBottomBarWhenPushed =YES;
    web.title = @"我的收益";
    [self.navigationController pushViewController:web animated:YES];

    //WEB
}
#pragma mark--团队订购
- (IBAction)teamOrder:(id)sender {
    self.navigationController.navigationBarHidden =NO;
    TZSTeamDGViewController * ts =[[TZSTeamDGViewController alloc]init];
    ts.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:ts animated:YES];
}
#pragma mark--团队管理
- (IBAction)teamManagement:(id)sender {
    self.navigationController.navigationBarHidden =NO;
    BaseWebViewController *web =[[BaseWebViewController alloc]init];
    web.urlStr = @"app/fatTeacher/myTeam.html";
    web.title = @"团队管理";
    web.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:web animated:YES];

    //WEB
}

- (IBAction)toViewRank:(id)sender {
}
#pragma mark--设置
- (IBAction)didEdit:(id)sender {
    self.navigationController.navigationBarHidden =NO;
    
    TZSEditViewController *edit = [[TZSEditViewController alloc]init];
    edit.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:edit animated:YES];
    

}

#pragma mark -----分享
-(void)didShareWithUrl:(NSString * )urlStr
{
    
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"分享" message:@"选择要分享到的平台" preferredStyle:UIAlertControllerStyleActionSheet];
    [al addAction:[UIAlertAction actionWithTitle:@"微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatSession url:urlStr];
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"微信朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatTimeline url:urlStr];

    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"QQ" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformTypeQQ url:urlStr];

    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:al animated:YES completion:nil];

}
#pragma mark ----share
-(void) shareWithType:(SSDKPlatformType)type url:(NSString * )url
{
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];

    if (type ==SSDKPlatformSubTypeWechatSession||type ==SSDKPlatformSubTypeWechatTimeline) {
        
        [shareParams SSDKSetupWeChatParamsByText:@"脂将军，您的健康减脂专家，全面分析健康数据，伴您享受生活每一天" title:@"脂将军，互联网体脂管理领导者" url:[NSURL URLWithString:url] thumbImage:[UserModel shareInstance].qrcodeImageUrl image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeWebPage forPlatformSubType:type];
    }else{
        
        [shareParams SSDKSetupShareParamsByText:@"脂将军，您的健康减脂专家，全面分析健康数据，伴您享受生活每一天"
                                         images:[UserModel shareInstance].qrcodeImageUrl
                                            url:[NSURL URLWithString:url]
                                          title:@"脂将军，互联网体脂管理领导者"
                                           type:SSDKContentTypeAuto];
        
        
        
    }
    [shareParams SSDKEnableUseClientShare];
    [SVProgressHUD showWithStatus:@"开始分享"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    
    //进行分享
    [ShareSDK share:type
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 [[UserModel shareInstance]dismiss];
                 //                 [[UserModel shareInstance] showSuccessWithStatus:@"分享成功"];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 [[UserModel shareInstance]dismiss];
                 NSString * text  =[error.userInfo objectForKey:@"error_message"];
                 
                [[UserModel shareInstance] showErrorWithStatus:text];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 [[UserModel shareInstance]dismiss];
                 //                 [[UserModel shareInstance] showInfoWithStatus:@"取消分享"];
                 break;
             }
             default:
                 break;
         }
     }];
    
}

@end
