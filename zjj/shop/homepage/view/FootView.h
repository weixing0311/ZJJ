//
//  FootView.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/17.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol footViewDelegate;
@interface FootView : UIView
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@property (weak, nonatomic) IBOutlet UIImageView *secionimage;
@property (weak, nonatomic) IBOutlet UIImageView *title;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
@property (nonatomic,assign) id<footViewDelegate>delegate;
@end
@protocol footViewDelegate <NSObject>

-(void)didClickFootViewBtnWithTag:(NSInteger)tag;

@end
