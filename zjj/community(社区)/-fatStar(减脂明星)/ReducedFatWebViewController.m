//
//  ReducedFatWebViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/12/15.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ReducedFatWebViewController.h"

@interface ReducedFatWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ReducedFatWebViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"健康知识";
    [self setTBWhiteColor];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share_"] style:UIBarButtonItemStylePlain target:self action:@selector(didShare)];
    self.navigationItem.rightBarButtonItem = item;
    self.webView.delegate = self;
    _webView.scrollView.bouncesZoom = NO;
    _webView.scrollView.bounces = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    
    [SVProgressHUD showWithStatus:@"加载中.."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];

}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
}

-(void)didShare
{
    UIAlertController * al =[UIAlertController alertControllerWithTitle:@"分享" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [al addAction:[UIAlertAction actionWithTitle:@"微信朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatTimeline ];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatSession ];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"QQ好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformTypeQQ ];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    
    [self presentViewController:al animated:YES completion:nil];
}

-(void) shareWithType:(SSDKPlatformType)type
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    if (type ==SSDKPlatformSubTypeWechatTimeline||type==SSDKPlatformSubTypeWechatSession) {
        [shareParams SSDKSetupWeChatParamsByText:@"" title:@"健康知识" url:[NSURL URLWithString:self.urlStr] thumbImage:getImage(@"logo") image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:type];
        
    }else if (type==SSDKPlatformTypeQQ)
    {
        [shareParams SSDKSetupShareParamsByText:@""
                                         images:getImage(@"logo")
                                            url:[NSURL URLWithString:self.urlStr]
                                          title:@"健康知识"
                                           type:SSDKContentTypeWebPage];
        
        //        [shareParams SSDKSetupQQParamsByText:self.contentStr title:self.titleStr url:[NSURL URLWithString:self.urlStr] thumbImage:_imageUrl image:nil type:SSDKContentTypeWebPage forPlatformSubType:type];
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
                 //                 [[UserModel shareInstance] showErrorWithStatus:@"分享失败"];
                 DLog(@"error-%@",error);
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
