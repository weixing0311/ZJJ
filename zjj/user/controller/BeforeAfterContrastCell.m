//
//  BeforeAfterContrastCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/9.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "BeforeAfterContrastCell.h"

@implementation BeforeAfterContrastCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.continuousDatelb.adjustsFontSizeToFitWidth = YES;
    self.lossWeightlb.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}
-(void)setUpCellWithDict:(NSDictionary *)dict
{
    self.beforeWeightlb.text = [NSString stringWithFormat:@"%.1fkg",[[dict safeObjectForKey:@"beforeWeight"] floatValue]];
    self.afterweightlb.text = [NSString stringWithFormat:@"%.1fkg",[[dict safeObjectForKey:@"afterWeight"] floatValue]];
    self.continuousDatelb.text = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"registerDate"]?[dict safeObjectForKey:@"registerDate"]:@"0"];
    
    double befortWeight =[[dict safeObjectForKey:@"beforeWeight"]doubleValue];
    double afterWeight =[[dict safeObjectForKey:@"afterWeight"]doubleValue];
    
    
    float lossWeight  = befortWeight-afterWeight;
    
//    if (lossWeight>0) {
        self.afterweightlb.textColor = HEXCOLOR(0x1aac19);
//    }else{
//        self.afterweightlb.textColor = [UIColor orangeColor];
//    }
    self.lossWeightlb.text = [NSString stringWithFormat:@"%.1f",lossWeight>0?lossWeight:0];
    
    
    NSString * tisStr = [NSString stringWithFormat:@"您的最佳体重为%.1fkg,继续加油哦！",[[dict safeObjectForKey:@"standardWeight"]doubleValue]];
    NSMutableAttributedString * tisString = [[NSMutableAttributedString alloc]initWithString:tisStr];
    
    //总共
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,7)];
    [tisString addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x1aac19) range:NSMakeRange(7,tisString.length-15)];
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(tisString.length-8,8)];

    self.bastWeightlb.attributedText = tisString;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
