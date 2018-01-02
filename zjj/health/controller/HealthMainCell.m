//
//  HealthMainCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/12/6.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HealthMainCell.h"
#import "ColorCircleView.h"
@implementation HealthMainCell
{
    ColorCircleView * circleView;
//    QQView * qqV;
    NSTimer * timer;
    int timeCount;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.qqView.layer.backgroundColor = [RGBACOLOR(0, 0, 0, 0) CGColor];
    self.qqView.backgroundColor = RGBACOLOR(0, 0, 0, 0);
    self.weightIngBtn.layer.borderWidth= 1;
    self.weightIngBtn.layer.borderColor = HEXCOLOR(0xeeeeee).CGColor;
    if (IS_IPHONE5) {
        self.weightlb.font = [UIFont boldSystemFontOfSize:35];
    }

}
-(void)refreshPageInfoWithItem:(HealthItem*)item
{
    
    if (item==nil) {
        self.weightlb.text = @"0.0kg";
        self.lessWeightlb.text = @"-";
//        self.trendArrowImageView.hidden = YES;
        self.statuslb.text = @"";
        self.daysLabel.text = @"";
//        self.redFatlb.text = @"";
        [self.userBtn sd_setImageWithURL:[NSURL URLWithString:[SubUserItem shareInstance].headUrl] forState:UIControlStateNormal placeholderImage:getImage(@"head_default")];

        return;
    }
    [self.userBtn sd_setImageWithURL:[NSURL URLWithString:[SubUserItem shareInstance].headUrl] forState:UIControlStateNormal placeholderImage:getImage(@"head_default")];
    
    
    NSString * weightStr =[NSString stringWithFormat:@"%.1fkg",item.weight];
    
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc]initWithString:weightStr];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(attString.length-2, 2)];
    self.weightlb.attributedText = attString;
    
    
    [UserModel shareInstance].userDays = item.userDays;
    self.daysLabel.text = [NSString stringWithFormat:@"已使用%d天,已减%.1fkg",item.userDays,item.subtractWeight*100/100];

    
    double lessFatWeight = [item getFatWeightPoorWithItem:item];
    NSString * lessFatTitle  =lessFatWeight>0?@"需增脂":@"需减脂";
    if (fabs(lessFatWeight)<0.5) {
        self.lessWeightlb.text = @"";
    }else{
        self.lessWeightlb.text = [NSString stringWithFormat:@"%@%.1fkg",lessFatTitle,fabs(lessFatWeight)];
    }
    
//    if (item.weight&&item.standardWeight&&item.standardWeight) {
//        float weightChange = item.weight - item.standardWeight;
//        DLog(@"%f--%f",item.weight,item.lastWeight);
//        if (weightChange>=0) {
//            self.lessWeightlb.text =[NSString stringWithFormat:@"需减脂%.1fkg",fabsf(weightChange)];
//
//        }else if (weightChange<0)
//        {
//            self.lessWeightlb.text =[NSString stringWithFormat:@"需增脂%.1fkg",fabsf(weightChange)];
//        }
//    }
//    else {
//        self.lessWeightlb.text = @"";
//    }
    
    
    
    
    switch (item.weightLevel) {
        case 1:
            self.statuslb.text = [NSString stringWithFormat:@"偏瘦"];
            //            self.fatStatuslb.textColor = HEXCOLOR(0xf4a519);
            break;
        case 2:
            self.statuslb.text = [NSString stringWithFormat:@"正常"];
            //            self.fatStatuslb.textColor = HEXCOLOR(0x41bf7c);
            break;
        case 3:
            self.statuslb.text = [NSString stringWithFormat:@"轻度肥胖"];
            //            self.fatStatuslb.textColor = HEXCOLOR(0xf4a519);
            break;
        case 4:
            self.statuslb.text = [NSString stringWithFormat:@"中度肥胖"];
            //            self.fatStatuslb.textColor = HEXCOLOR(0xf4a519);
            break;
        case 5:
            self.statuslb.text = [NSString stringWithFormat:@"重度肥胖"];
            //            self.fatStatuslb.textColor = HEXCOLOR(0xe84849);
            break;
        case 6:
            self.statuslb.text = [NSString stringWithFormat:@"极度肥胖"];
            //            self.fatStatuslb.textColor = HEXCOLOR(0xe84849);
            break;
            
        default:
            break;
    }
    [_qqView getProgressWithBfp:item.fatPercentage];
}

-(void)changeQQVWithfdp:(float)fdp
{
    if ([timer isValid] ==YES) {
        [timer invalidate];
    }
    timeCount =0;
    timer = [NSTimer timerWithTimeInterval:0.05 target:self selector:@selector(refreshTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

}
-(void)refreshTimer
{
    if (timeCount==100) {
        [timer invalidate];
    }
    timeCount ++;
    self.qqView.progress =0.8/100*timeCount;
    [self.qqView  setNeedsDisplay];
}
- (IBAction)didClickHeader:(id)sender {
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didShowUserList)]) {
        [self.delegate didShowUserList];
    }
    
}
- (IBAction)didClickWeighting:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didWeighting)]) {
        [self.delegate didWeighting];
    }
}


- (IBAction)didClickRight:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didShowSHuoming)]) {
        [self.delegate didShowSHuoming];
    }
    
}

- (IBAction)didClickEnterDetail:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didEnterDetailVC)]) {
        [self.delegate didEnterDetailVC];
    }
    
}

- (IBAction)didEnterHistory:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didEnterRightVC)]) {
        [self.delegate didEnterRightVC];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
