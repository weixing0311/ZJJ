//
//  CommunityModel.h
//  zjj
//
//  Created by iOSdeveloper on 2017/9/26.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunityModel : NSObject
+(CommunityModel *)shareInstance;
@property(nonatomic,strong)NSMutableArray * loadedImageArray;
@property (nonatomic,copy)NSString * releaseTime;
@property (nonatomic,copy)NSString * content;
@property (nonatomic,copy)NSString * uid;
@property (nonatomic,copy)NSString * userId;
@property (nonatomic,copy)NSString * title;
@property (nonatomic,strong)NSMutableArray * pictures;
@property (nonatomic,copy)NSString * isRelease;
@property (nonatomic,copy)NSString * shareNum;
@property (nonatomic,copy)NSString * movieStr;
@property (nonatomic,copy)NSString * headurl;
@property (nonatomic,assign)float  rowHieght;
@property (nonatomic,copy)NSString * movieImageStr;
@property (nonatomic,copy)NSString * forwardingnum;//转发数量
@property (nonatomic,copy)NSString * commentnum;//评论数量
@property (nonatomic,copy)NSString * greatnum;//赞数
@property (nonatomic,copy)NSString * isFabulous;//是否赞过
@property (nonatomic,copy)NSString * isFollow; //是否关注
@property (nonatomic,copy)NSString * level;// 积分等级
@property (nonatomic,strong)NSMutableArray * thumbArray;//图片数组
@property (nonatomic,copy) NSString * loadSuccess;
@property (nonatomic,copy) NSString * topNum;//是否置顶 1是 0否
@property (nonatomic,copy) NSString * location;//位置
@property (nonatomic,copy) NSString * vip;
-(void)setInfoWithDict:(NSDictionary *)dict;

@end
