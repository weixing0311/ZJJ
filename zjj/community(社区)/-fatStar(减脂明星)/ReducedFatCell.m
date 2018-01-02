//
//  ReducedFatCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/12/7.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ReducedFatCell.h"

@implementation ReducedFatCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}

-(void)setModel:(ReducedFatModel *)model
{
    _model = model;
//    [self.headBtn sd_setImageWithURL:[NSURL URLWithString:model.headImgStr] forState:UIControlStateNormal placeholderImage:getImage(@"head_default")];
    
    
    
    [self.headBtn sd_setImageWithURL:[NSURL URLWithString:model.headImgStr] placeholderImage:getImage(@"head_default")];
    
    
    self.headBtn.layer.masksToBounds = YES;
    self.headBtn.layer.cornerRadius = 22;
    
    
    [self.playBtn setImage:getImage(@"videoPlay.png") forState:UIControlStateNormal];
    self.locationLabel.text =model.location;
    self.titleLabel.text = model.nickname;
    self.levelLabel.text = model.level;
    self.ageLabel.text = [NSString stringWithFormat:@"%@岁",model.age];
    self.heightLabel.text = [NSString stringWithFormat:@"%@cm",model.height];
    self.lessFatLabel.text = [NSString stringWithFormat:@"已减脂%.1f斤",[model.lessWeight floatValue]];
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.mediaImageUrl] placeholderImage:getImage(@"reducedFat_Default")];
    
}




#pragma  mark --------UI

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.headBtn        = [UIImageView new];
        self.vipImg         = [UIImageView new];
        self.titleLabel     = [UILabel     new];
        self.levelLabel     = [UILabel     new];
        self.ageLabel       = [UILabel     new];
        self.heightLabel    = [UILabel     new];
        self.locationLabel  = [UILabel     new];
        self.lessFatView    = [UIView      new];
        self.lessFatLabel   = [UILabel     new];
        self.bgImageView    = [UIImageView new];
//        self.playBtn        = [UIButton    new];
        self.lineView = [UIView new];

        [self.contentView addSubview:self.headBtn];
        [self.contentView addSubview:self.vipImg];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.levelLabel];
        [self.contentView addSubview:self.ageLabel];
        [self.contentView addSubview:self.heightLabel];
        [self.contentView addSubview:self.locationLabel];
        [self.contentView addSubview:self.lessFatView];
        [self.lessFatView addSubview:self.lessFatLabel];
        [self.contentView addSubview:self.bgImageView];
        [self.contentView addSubview:self.lineView];
        
        [self setSubViewFrame];
        [self setSubViewAttribute];
    }
    return self;
}

-(void)setSubViewAttribute
{
    self.vipImg.image = getImage(@"vip_");

    self.lessFatView.backgroundColor = [UIColor orangeColor];
    self.lessFatView.layer.masksToBounds = YES;
    self.lessFatView.layer.cornerRadius  = 15;
    self.bgImageView.layer.masksToBounds = YES;
    self.bgImageView.layer.cornerRadius  = 5;
    
    self.lessFatLabel.adjustsFontSizeToFitWidth = YES;
    self.lineView.backgroundColor = HEXCOLOR(0xeeeeee);
    
    [self setLabelAttributeWithLabel:self.titleLabel Color:[UIColor blackColor] font:15];
    [self setLabelAttributeWithLabel:self.ageLabel Color:HEXCOLOR(0x666666) font:12];
    [self setLabelAttributeWithLabel:self.heightLabel Color:HEXCOLOR(0x666666) font:12];
    [self setLabelAttributeWithLabel:self.locationLabel Color:HEXCOLOR(0x666666) font:12];
    [self setLabelAttributeWithLabel:self.lessFatLabel Color:[UIColor whiteColor] font:13];
    [self setLabelAttributeWithLabel:self.levelLabel Color:[UIColor orangeColor] font:17];

}

-(void)setSubViewFrame
{
    self.headBtn.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .widthIs(44)
    .heightIs(44);
    
    self.vipImg.sd_layout
    .leftSpaceToView(self.contentView, 39)
    .topSpaceToView(self.contentView, 39)
    .widthIs(17)
    .heightIs(17);
    
    self.titleLabel.sd_layout
    .leftSpaceToView(self.headBtn, 10)
    .topSpaceToView(self.contentView, 10)
    .heightIs(22);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    
    self.levelLabel.sd_layout
    .topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.titleLabel, 10)
    .heightIs(22);
    [self.levelLabel setSingleLineAutoResizeWithMaxWidth:40];

    self.ageLabel.sd_layout
    .leftSpaceToView(self.headBtn, 10)
    .topSpaceToView(self.titleLabel, 10)
    .heightIs(10);
    [self.ageLabel setSingleLineAutoResizeWithMaxWidth:50];

    
    
    self.heightLabel.sd_layout
    .leftSpaceToView(self.ageLabel, 5)
    .topEqualToView(self.ageLabel)
    .heightIs(10);
    [self.heightLabel setSingleLineAutoResizeWithMaxWidth:50];

    
    
    self.locationLabel.sd_layout
    .leftSpaceToView(self.heightLabel, 10)
    .topEqualToView(self.heightLabel)
    .heightIs(10);
    [self.locationLabel setSingleLineAutoResizeWithMaxWidth:150];

    
    
    self.lessFatView.sd_layout
    .topSpaceToView(self.contentView, 20)
    .rightSpaceToView(self.contentView, -15)
    .widthIs(120)
    .heightIs(30);
    
    self.lessFatLabel.sd_layout
    .topSpaceToView(self.lessFatView, 0)
    .rightSpaceToView(self.lessFatView, 25)
    .bottomSpaceToView(self.lessFatView, 0)
    .leftSpaceToView(self.lessFatView, 10);
    
    
    
    self.bgImageView.sd_layout
    .topSpaceToView(self.headBtn, 10)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs((JFA_SCREEN_WIDTH-20)/2);
    
    self.lineView.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .topSpaceToView(self.bgImageView, 10)
    .heightIs(5);
    
    
//    self.playBtn.sd_layout
//    .centerYEqualToView(self.bgImageView)
//    .centerXEqualToView(self.bgImageView)
//    .widthIs(40)
//    .heightIs(40);
    [self setupAutoHeightWithBottomViewsArray:@[self.lineView] bottomMargin:0];

}


-(void)setLabelAttributeWithLabel:(UILabel*)lb Color:(UIColor*)color font:(int)font
{
    lb.textColor = color;
//    lb.backgroundColor =[UIColor orangeColor];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.font = [UIFont systemFontOfSize:font];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
