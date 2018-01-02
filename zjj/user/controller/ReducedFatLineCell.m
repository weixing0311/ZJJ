//
//  ReducedFatLineCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/12/7.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ReducedFatLineCell.h"

@implementation ReducedFatLineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

-(void)SubViewInit
{
    self.headImageView = [UIImageView new];
    self.lineView      = [UIView new];
    self.contentLabel  = [UILabel new];
    self.titleLabel    = [UILabel new];

    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.contentLabel];
    
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textColor = HEXCOLOR(0x666666);
    self.contentLabel.font = [UIFont systemFontOfSize:12];
    
}
-(void)setcrtt
{
    
    self.headImageView.sd_layout
    .topSpaceToView(self.contentView, 40)
    .leftSpaceToView(self.contentView, 50)
    .widthIs(JFA_SCREEN_WIDTH/2-90)
    .heightIs(JFA_SCREEN_WIDTH/2-60);
    
    self.lineView.sd_layout
    .centerXEqualToView(self.contentView)
    .topSpaceToView(self.titleLabel, 20)
    .widthIs(1)
    .bottomSpaceToView(self.contentView, 20);
    
    self.titleLabel.sd_layout
    .topSpaceToView(self.contentView, 40)
    .leftSpaceToView(self.lineView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(40);

    self.contentLabel.sd_layout
    .topSpaceToView(self.titleLabel, 10)
    .leftSpaceToView(self.lineView, 10)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0);
    
    
    [self setupAutoHeightWithBottomViewsArray:@[self.contentLabel,self.lineView] bottomMargin:20];

}
-(void)setModel:(ReducedLineModel *)model
{
    _model = model;
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:getImage(@"default")];
    
    
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
