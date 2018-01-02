
//
//  ReducedFatModel.m
//  zjj
//
//  Created by iOSdeveloper on 2017/12/7.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ReducedFatModel.h"

@implementation ReducedFatModel
-(void)setInfoWithDict:(NSDictionary*)dict
{
    self.headImgStr    = [dict safeObjectForKey:@"headimgurl"];
    self.nickname      = [dict safeObjectForKey:@"nickName"];
    self.level         = [dict safeObjectForKey:@"gradeName"];
    self.age           = [dict safeObjectForKey:@"age"];
    self.height        = [dict safeObjectForKey:@"heigth"];
    self.location      = [dict safeObjectForKey:@"location"];
    self.lessWeight    = [dict safeObjectForKey:@"subtractWeight"];
    self.mediaUrl      = [dict safeObjectForKey:@"videoPath"];
    self.mediaImageUrl = [dict safeObjectForKey:@"backGround"];
    self.userId        = [dict safeObjectForKey:@"userId"];
    self.vip         = [dict safeObjectForKey:@"isVip"];
}
@end
