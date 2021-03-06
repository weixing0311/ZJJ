//
//  NewHealthDetailHeaderCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/10/13.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthDetailsItem.h"

@interface NewHealthDetailHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknamelb;
@property (weak, nonatomic) IBOutlet UILabel *value1lb;
@property (weak, nonatomic) IBOutlet UILabel *value2lb;
-(void)setInfoWithDict:(HealthDetailsItem *)item;
@property (weak, nonatomic) IBOutlet UIImageView *sexImg;

@property (weak, nonatomic) IBOutlet UILabel *heightlb;
@property (weak, nonatomic) IBOutlet UILabel *agelb;
@property (weak, nonatomic) IBOutlet UILabel *bodyAgelb;
@property (weak, nonatomic) IBOutlet UILabel *bmrlb;


@end
