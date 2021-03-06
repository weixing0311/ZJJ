//
//  TZSDGCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/23.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TZSDGCell.h"
#import "HDCell.h"
@implementation TZSDGCell
{
    int count ;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    count = 0;

    // Initialization code
    
    self.headImageView.layer.borderWidth = 1;
    self.headImageView.layer.borderColor=HEXCOLOR(0xeeeeee).CGColor;
    
    self.cxImageLabel.layer.masksToBounds = YES;
    self.cxImageLabel.layer.cornerRadius  = 5;
    self.cxImageLabel.layer.borderWidth = 1;
    self.cxImageLabel.layer.borderColor=[UIColor redColor].CGColor;
    
    self.countView.layer.masksToBounds = YES;
    self.countView.layer.cornerRadius  = 5;
    self.countView.layer.borderWidth = 1;
    self.countView.layer.borderColor=HEXCOLOR(0xa6a6a6).CGColor;

    
    
}
- (IBAction)didClickChangeCount:(id)sender {
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didChangeCountWithCell:)]) {
        [self.delegate didChangeCountWithCell:self ];
    }
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didAdd:(id)sender {
    
    count = [self.countLabel.text intValue];
    if (count>=200) {
        return;
    }
    count++;
    
    self.countLabel.text =[NSString stringWithFormat:@"%d",count];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(addCountWithCell:)]) {
        [self.delegate addCountWithCell:self];
    }
}

- (IBAction)didRed:(id)sender {
    count = [self.countLabel.text intValue];
    if (count ==0) {
        return;
    }
    count--;
    self.countLabel.text =[NSString stringWithFormat:@"%d",count];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(redCountWithCell:)]) {
        [self.delegate redCountWithCell:self];
    }

}

- (IBAction)didbuy:(id)sender {
}
- (IBAction)didShowCuXDetailView:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(showCXDetailWithCell:)]) {
        [self.delegate showCXDetailWithCell:self];
    }
}
@end
