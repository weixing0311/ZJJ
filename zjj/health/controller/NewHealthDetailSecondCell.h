//
//  NewHealthDetailSecondCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/10/13.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthDetailsItem.h"
@interface NewHealthDetailSecondCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

-(void)setInfoWithDict:(HealthDetailsItem *)item;
@end
