//
//  reducedFatInterviewTableViewCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/12/7.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "reducedFatInterviewTableViewCell.h"

@implementation reducedFatInterviewTableViewCell

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
-(void)setSubViews
{
    self.questionView  = [UIView new];
    self.questionlb    = [UILabel new];
    self.resultView    = [UIView new];
    self.resultlb      = [UILabel new];
    self.questionHeadImageView = [UIImageView new];
    self.resultHeadImageView = [UIImageView new];
    
    [self.questionView addSubview:self.questionHeadImageView];
    [self.questionView addSubview:_resultlb];
    
    [self.resultView addSubview:self.resultHeadImageView];
    [self.resultView addSubview:self.resultlb];

    [self.contentView sd_addSubviews:@[self.questionView,self.resultView]];
    
    self.questionlb.numberOfLines = 0;
    self.questionlb.textColor = HEXCOLOR(0x666666);
    self.questionlb.font = [UIFont systemFontOfSize:12];
    
    self.resultlb.numberOfLines = 0;
    self.resultlb.textColor = HEXCOLOR(0x666666);
    self.resultlb.font = [UIFont systemFontOfSize:12];

    
    
    self.questionHeadImageView.sd_layout
    .leftSpaceToView(self.questionView, 10)
    .topSpaceToView(self.questionView, 10)
    .widthIs(30)
    .heightIs(30);
    
    self.questionlb.sd_layout
    .leftSpaceToView(self.questionHeadImageView, 10)
    .topSpaceToView(self.questionView, 10)
    .rightSpaceToView(self.questionView, 10)
    .autoHeightRatio(0);
    self.questionView.sd_layout
    .topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0);
    [self.questionView setupAutoHeightWithBottomView:self.questionlb bottomMargin:10];

    self.resultHeadImageView.sd_layout
    .leftSpaceToView(self.resultView, 10)
    .topSpaceToView(self.resultView, 10)
    .widthIs(30)
    .heightIs(30);
    
    self.resultlb.sd_layout
    .leftSpaceToView(self.resultHeadImageView, 10)
    .topSpaceToView(self.resultView, 10)
    .rightSpaceToView(self.resultView, 10)
    .autoHeightRatio(0);
    
    self.resultView.sd_layout
    .topSpaceToView(self.questionView, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0);
    [self.questionView setupAutoHeightWithBottomView:self.resultlb bottomMargin:10];

    [self setupAutoHeightWithBottomView:self.questionView bottomMargin:10];

    
    
    
}
-(void)setModel:(ReducedFatAskResultModel*)model
{
    _model = model;
    self.questionHeadImageView.image =getImage(@"logo");
    self.questionlb.text = model.questionStr;
    self.resultlb.text = model.resultStr;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
