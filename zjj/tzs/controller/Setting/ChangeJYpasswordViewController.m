//
//  ChangeJYpasswordViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/23.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ChangeJYpasswordViewController.h"

@interface ChangeJYpasswordViewController ()

@end

@implementation ChangeJYpasswordViewController
{
    int timeNumber;
    NSTimer * _timer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改交易密码";
    [self setNbColor];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)pudata:(id)sender {
    
    if (self.oldpassword.text.length <1) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入旧密码"];
        return;
    }
    if (self.mobiletf.text.length<11) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入正确手机号"];
        return;
    }
    
    if (self.verTf.text.length<1) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入验证码"];
        return;
    }
    if (self.theNewpasswordtf.text.length<1) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入新密码"];
        return;
    }
    if (self.renewpassword.text.length<1||![self.renewpassword.text isEqualToString:self.theNewpasswordtf.text]) {
        [[UserModel shareInstance] showInfoWithStatus:@"两次密码不一致"];
        return;
    }
    
    BOOL isPassword = [self.theNewpasswordtf.text checkPassWord];
    
    if (isPassword !=YES) {
        [[UserModel shareInstance]showInfoWithStatus:@"请输入正确格式密码"];
        return;
    }

    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.mobiletf.text forKey:@"mobilePhone"];
    [param setObject:[NSString encryptString: self.oldpassword.text] forKey:@"oldPassword"];
    [param setObject:[NSString encryptString: self.theNewpasswordtf.text] forKey:@"password"];
    [param setObject:[NSString encryptString: self.renewpassword.text] forKey:@"repPassword"];
    [param setObject:self.verTf.text forKey:@"vcode"];
    [SVProgressHUD show];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"/app/user/changeTradePassword.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        [[UserModel shareInstance] showSuccessWithStatus:@"修改成功"];
    } failure:^(NSError *error) {
//        [SVProgressHUD dismiss];
//        [[UserModel shareInstance] showErrorWithStatus:@"修改失败"];
    }];

}

- (IBAction)pushVer:(id)sender {
    if (self.mobiletf.text.length<11) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入正确手机号"];
        return;
    }
    
    
    timeNumber = 59;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
    self.verBtn.enabled = NO;
    
    NSMutableDictionary *param =[ NSMutableDictionary dictionary];
    [param setObject:self.mobiletf.text forKey:@"mobilePhone"];
    [param setObject:@"4" forKey:@"msgType"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:kSendMobileVerUrl HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        
        [[UserModel shareInstance] showSuccessWithStatus:@"已发送"];
    } failure:^(NSError * error) {
        [_timer invalidate];
        [self.verBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.verBtn.enabled = YES;

        
    }];


}
-(void)refreshTime
{
    if (timeNumber ==0) {
        [_timer invalidate];
        [self.verBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.verBtn.enabled = YES;
        return;
    }
    NSLog(@"%d",timeNumber);
    [self.verBtn setTitle:[NSString stringWithFormat: @"%ld秒后可重新获取",(long)timeNumber] forState:UIControlStateNormal];
    timeNumber --;
}

@end
