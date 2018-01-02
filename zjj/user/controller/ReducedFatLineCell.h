//
//  ReducedFatLineCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/12/7.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewMineModel.h"
@interface ReducedFatLineCell : UITableViewCell
@property (nonatomic,strong) UIImageView * headImageView;
@property (nonatomic,strong) UIView      * lineView;
@property (nonatomic,strong) UILabel     * contentLabel;
@property (nonatomic,strong) UILabel     * titleLabel;
@property (nonatomic,strong) ReducedLineModel * model;
@end
