//
//  TZSEditViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/23.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface TZSEditViewController : JFABaseTableViewController<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
