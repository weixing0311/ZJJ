//
//  ColorCircleView.h
//  HuanxingDemo
//
//  Created by iOSdeveloper on 2017/12/4.
//  Copyright © 2017年 -call Me WeiXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorCircleView : UIView
//数组里面装的是字典，，字典里有两个key -> strokeColor和precent
@property (nonatomic,assign) NSArray *circleArray;
-(void)refreshRoleWithbfp:(float)bfp;
@end
