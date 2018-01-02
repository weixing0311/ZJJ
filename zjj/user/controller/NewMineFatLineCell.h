//
//  NewMineFatLineCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/12/8.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewMineModel.h"

@interface NewMineFatLineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *firstlb;
@property (weak, nonatomic) IBOutlet UIImageView *firstImg;
@property (weak, nonatomic) IBOutlet UILabel *secondlb;
@property (weak, nonatomic) IBOutlet UIImageView *secondImg;
@property (nonatomic,strong) ReducedLineModel * model;
@property (weak, nonatomic) IBOutlet UILabel *title1lb;
@property (weak, nonatomic) IBOutlet UILabel *title2lb;


-(void)setViewHidden:(NSInteger)isHidden;
@end
