//
//  HistoryHeaderView.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HistoryHeaderView.h"
@implementation HistoryHeaderView
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.calendarPicker = [[[NSBundle mainBundle] loadNibNamed:@"SZCalendarPicker" owner:nil options:nil] lastObject];
    self.calendarPicker.frame = CGRectMake(0, 0,JFA_SCREEN_WIDTH-20, 352);
    [self.riView addSubview:self.calendarPicker];
    self.calendarPicker.today = [NSDate date];
    self.calendarPicker.date = self.calendarPicker.today;

//    self.calendarView = [[DAYCalendarView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH-20, (JFA_SCREEN_WIDTH-20)*0.7-10)];
//    [self.riView addSubview:self.calendarView];

}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
