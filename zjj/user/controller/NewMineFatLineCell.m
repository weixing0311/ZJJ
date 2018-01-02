//
//  NewMineFatLineCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/12/8.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewMineFatLineCell.h"

@implementation NewMineFatLineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(ReducedLineModel *)model
{
    _model = model;
    self.title1lb.text = model.title;
    self.title2lb.text = model.title;

    self.firstlb.text = model.content;
    self.secondlb.text = model.content;

    [self.firstImg sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:getImage(@"fatLine_default")];
    [self.secondImg sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:getImage(@"fatLine_default")];

}
-(void)setViewHidden:(NSInteger)isHidden
{
    BOOL hidden =isHidden%2?YES:NO;
    self.firstlb.hidden = !hidden;
    self.secondImg.hidden = !hidden;
    self.title1lb.hidden = !hidden;
    
    self.secondlb.hidden = hidden;
    self.title2lb.hidden = hidden;
    self.firstImg.hidden = hidden;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
