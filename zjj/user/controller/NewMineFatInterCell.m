//
//  NewMineFatInterCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/12/8.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewMineFatInterCell.h"

@implementation NewMineFatInterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.img1.layer.borderWidth= 1;
    self.img1.layer.borderColor = HEXCOLOR(0xeeeeee).CGColor;
    self.img2.layer.borderWidth= 1;
    self.img2.layer.borderColor = HEXCOLOR(0xeeeeee).CGColor;
    self.img1.layer.masksToBounds = YES;
    self.img1.layer.cornerRadius = self.img1.frame.size.width/2;
    self.img2.layer.masksToBounds = YES;
    self.img2.layer.cornerRadius = self.img2.frame.size.width/2;

}
-(void)setModel:(ReducedFatAskResultModel*)model
{
    _model = model;
    self.img1.image =getImage(@"logo");
    self.titlelb.text = model.questionStr;
    self.contentlb.text = model.resultStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
