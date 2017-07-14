//
//  jzsSchoolWebViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/30.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface jzsSchoolWebViewController : JFABaseTableViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;

- (IBAction)didCollection:(id)sender;
- (IBAction)didZan:(id)sender;
@property (nonatomic,copy)NSString * urlStr;
@property (nonatomic,assign)int  iscollection;
@property (nonatomic,assign)int  islike;
@property (nonatomic,assign)int  informateId;
@end