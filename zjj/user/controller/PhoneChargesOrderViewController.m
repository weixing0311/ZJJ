//
//  PhoneChargesOrderViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/11/4.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "PhoneChargesOrderViewController.h"
#import "KfViewController.h"

@interface PhoneChargesOrderViewController ()
@property (weak, nonatomic) IBOutlet UILabel *orderNolb;
@property (weak, nonatomic) IBOutlet UILabel *statuslb;
@property (weak, nonatomic) IBOutlet UILabel *phonenumlb;
@property (weak, nonatomic) IBOutlet UILabel *pricelb;
@property (weak, nonatomic) IBOutlet UIButton *kfBtn;

@end

@implementation PhoneChargesOrderViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"订单详情";
    [self setTBWhiteColor];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.infoDict = [NSDictionary dictionary];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.kfBtn.layer.borderWidth= 1;
    self.kfBtn.layer.borderColor = HEXCOLOR(0xeeeeee).CGColor;
    
    
    [self getlistInfo_IS_CONSUMERS];
}
-(void)getlistInfo_IS_CONSUMERS
{
    NSMutableDictionary * param =[NSMutableDictionary dictionary];
    [param safeSetObject:[self.infoDict safeObjectForKey:@"orderNo"] forKey:@"orderNo"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/integral/orderInfo/queryIntegrationOrderItem.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        DLog(@"dic");
        _infoDict = [[dic safeObjectForKey:@"data"]safeObjectForKey:@"array"][0];
        
        int status = [[self.infoDict objectForKey:@"status"]intValue];
        if (status ==0) {
            self.statuslb.text = @"已取消";
            self.statuslb.textColor =HEXCOLOR(0x666666);
        }else if (status ==10)
        {
            self.statuslb .text= @"已完成";
            self.statuslb.textColor =HEXCOLOR(0x666666);
            
        }else if(status ==1){
            self.statuslb .text = @"待付款";
            self.statuslb.textColor =[UIColor redColor];
        }
        else if (status ==3)
        {
            self.statuslb .text = @"待充值";
            self.statuslb.textColor =[UIColor redColor];
            
        }
        
        NSDictionary * itemDict =[_infoDict safeObjectForKey:@"itemJson"][0];
        self.orderNolb.text = [self.infoDict safeObjectForKey:@"orderNo"];
        self.phonenumlb.text = [self.infoDict safeObjectForKey:@"consigneePhone"];
        self.pricelb.text = [itemDict safeObjectForKey:@"productName"];
        
        
    } failure:^(NSError *error) {
        
    }];
    
}


- (IBAction)didClickcallKf:(id)sender {
    KfViewController *kv = [[KfViewController alloc]init];
    [self.navigationController pushViewController:kv animated:YES];
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
