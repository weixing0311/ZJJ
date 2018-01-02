//
//  ReducedFatCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/12/7.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReducedFatModel.h"
@interface ReducedFatCell : UITableViewCell
@property (nonatomic,strong)ReducedFatModel * model;
@property (nonatomic,strong) UIImageView * headBtn;
@property (nonatomic,strong) UILabel  * titleLabel;
@property (nonatomic,strong) UILabel  * levelLabel;
@property (nonatomic,strong) UILabel  * ageLabel;
@property (nonatomic,strong) UILabel  * heightLabel;
@property (nonatomic,strong) UILabel  * locationLabel;
@property (nonatomic,strong) UIView   * lessFatView;
@property (nonatomic,strong) UILabel  * lessFatLabel;
@property (nonatomic,strong) UIImageView * bgImageView;
@property (nonatomic,strong) UIImageView * midImageView;
@property (nonatomic,strong) UIButton * playBtn;
@property (nonatomic,strong) UIImageView * vipImg;
@property (nonatomic,strong) UIView * lineView;
-(void)setUpCellWithModel:(ReducedFatModel*)model;
@end


