//
//  BaseSservice.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/11.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseSservice : NSObject
+ (instancetype)sharedManager;
//请求成功回调block
typedef void (^requestSuccessBlock)(NSDictionary *dic);

//请求失败回调block
typedef void (^requestFailureBlock)(NSError *error);

-(NSString*)JFADomin;

-(id)getPostResponseSerSerializer;

-(id)getPostRequestSerializer;

-(NSURLSessionTask*)postDebugWithUrl:(NSString*)url paramters:(NSDictionary*)paramters;

-(NSURLSessionTask*)post1:(NSString*)url
             HiddenProgress:(BOOL)isHidden
                paramters:(NSMutableDictionary *)paramters
                  success:(requestSuccessBlock)success
                  failure:(requestFailureBlock)failure;
-(id)getGetResponseSerSerializer;

-(id)getGetRequestSerializer;

-(NSURLSessionTask*)get:(NSString*)url
              paramters:(NSDictionary*)paramters
                success:(void (^)(NSURLSessionTask *operation, id responseObject))success
                failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure;

-(NSURLSessionTask*)postImage:(NSString*)url
                    paramters:(NSMutableDictionary *)paramters
                    imageData:(NSData *)imageData
                    imageName:(NSString *)imageName//@"headimgurl.png"
                      success:(requestSuccessBlock)success
                      failure:(requestFailureBlock)failure;
- (NSURLSessionTask*)uploadImageWithPath:(NSString *)path
                      image:(UIImage *)image
                     params:(NSDictionary *)params
                    success:(requestSuccessBlock)success
                    failure:(requestFailureBlock)failure;
- (NSURLSessionTask*)uploadImageWithPath:(NSString *)path
                     photos:(NSArray *)photos
                     params:(NSDictionary *)params
                    success:(requestSuccessBlock)success
                    failure:(requestFailureBlock)failure;

-(NSURLSessionTask*)postMovie:(NSString*)url
                    paramters:(NSMutableDictionary *)paramters
                    movieData:(NSData *)movieData
                     videoImg:(NSData*)videoData
                    movieName:(NSString *)movieName//@"headimgurl.png"
                      success:(requestSuccessBlock)success
                      failure:(requestFailureBlock)failure;



@end
