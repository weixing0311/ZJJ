//
//  NewMineModel.h
//  zjj
//
//  Created by iOSdeveloper on 2017/12/8.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewMineModel : NSObject
@property (nonatomic,copy)NSString * lineImageStr;
@property (nonatomic,copy)NSString * lineContent;
-(void)setInfoWithDict:(NSDictionary*)dict;
@end

@interface ReducedFatAskResultModel : NewMineModel
@property (nonatomic,strong)NSString * questionStr;
@property (nonatomic,strong)NSString * resultStr;
@property (nonatomic,assign)double  height;

-(void)setInfoWithDict:(NSDictionary*)dict;

@end
@interface ReducedLineModel : NewMineModel
@property (nonatomic,strong)NSString * picture;
@property (nonatomic,strong)NSString * content;
@property (nonatomic,strong)NSString * title;
@property (nonatomic,assign)double  height;

-(void)setInfoWithDict:(NSDictionary*)dict;

@end
