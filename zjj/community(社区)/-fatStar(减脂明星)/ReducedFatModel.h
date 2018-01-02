//
//  ReducedFatModel.h
//  zjj
//
//  Created by iOSdeveloper on 2017/12/7.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReducedFatModel : NSObject
@property (nonatomic,copy) NSString * headImgStr;
@property (nonatomic,copy) NSString * nickname;
@property (nonatomic,copy) NSString * age;
@property (nonatomic,copy) NSString * height;
@property (nonatomic,copy) NSString * location;
@property (nonatomic,copy) NSString * lessWeight;
@property (nonatomic,copy) NSString * level;
@property (nonatomic,copy) NSString * mediaImageUrl;
@property (nonatomic,copy) NSString * mediaUrl;
@property (nonatomic,copy) NSString * userId;
@property (nonatomic,copy) NSString * vip;

-(void)setInfoWithDict:(NSDictionary*)dict;
@end
