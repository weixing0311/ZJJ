//
//  HealthMainCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/12/6.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QQView.h"
@protocol newHealthCellDelegate;

@interface HealthMainCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *userBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *statuslb;
@property (weak, nonatomic) IBOutlet UILabel *weightlb;

@property (weak, nonatomic) IBOutlet UIView *midView;

@property (weak, nonatomic) IBOutlet UILabel *lessWeightlb;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
- (IBAction)didClickWeighting:(id)sender;
- (IBAction)didClickEnterDetail:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *didClickEnterHistoryVC;
-(void)refreshPageInfoWithItem:(HealthItem*)item;

@property (weak, nonatomic) IBOutlet QQView *qqView;

@property (nonatomic,assign)id<newHealthCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *weightIngBtn;

@end
@protocol newHealthCellDelegate <NSObject>
-(void)didShowUserList;
-(void)didShowSHuoming;
-(void)didWeighting;
-(void)didEnterDetailVC;
-(void)didEnterRightVC;


@end
