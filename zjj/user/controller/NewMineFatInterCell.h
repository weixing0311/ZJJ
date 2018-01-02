//
//  NewMineFatInterCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/12/8.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewMineModel.h"

@interface NewMineFatInterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UILabel *titlelb;
@property (weak, nonatomic) IBOutlet UILabel *contentlb;
@property (nonatomic,strong)ReducedFatAskResultModel* model;

@end
