//
//  reducedFatInterviewTableViewCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/12/7.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewMineModel.h"
@interface reducedFatInterviewTableViewCell : UITableViewCell
@property (nonatomic,strong)ReducedFatAskResultModel* model;
@property (nonatomic,strong)UIView * questionView;
@property (nonatomic,strong)UIView * resultView;
@property (nonatomic,strong)UILabel * questionlb;
@property (nonatomic,strong)UILabel * resultlb;
@property (nonatomic,strong)UIImageView * questionHeadImageView;
@property (nonatomic,strong)UIImageView * resultHeadImageView;
@end
