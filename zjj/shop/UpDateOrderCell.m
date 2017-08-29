//
//  UpDateOrderCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/21.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "UpDateOrderCell.h"

@implementation UpDateOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.borderWidth = 1;
    self.headImageView.layer.borderColor=HEXCOLOR(0xeeeeee).CGColor;

    // Initialization code
}
-(void)setUpCellWithGoodsDetailItem:(GoodsDetailItem *)item
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:item.image]];
    self.titleLabel.text = item.productName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[item.productPrice floatValue]];
}
-(void)setUpCellWithDict:(NSDictionary *)dic
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[dic safeObjectForKey:@"picture"]]];
    self.titleLabel.text = [dic safeObjectForKey:@"productName"];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[[dic safeObjectForKey:@"unitPrice"]floatValue]];
}
-(void)setUpCellWithShopCarCellItem:(shopCarCellItem *)item
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:item.image]];
    self.titleLabel.text = item.productName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[item.productPrice floatValue]];
    self.countLabel.text = [NSString stringWithFormat:@"x%@",item.quantity];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
