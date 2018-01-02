//
//  NewMineModel.m
//  zjj
//
//  Created by iOSdeveloper on 2017/12/8.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewMineModel.h"

@implementation NewMineModel

-(void)setInfoWithDict:(NSDictionary*)dict
{
    
}
-(double)getHeightWithStr:(NSString*)contentStr font:(UIFont*)fontStr width:(double)width
{
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 0.1;
    
    UIFont *font = fontStr;
    NSDictionary * dict = @{NSFontAttributeName:font,
                            NSParagraphStyleAttributeName:paragraph};
    
    
    CGSize  size = [contentStr boundingRectWithSize:CGSizeMake(width, 500) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    return size.height;
}

@end




@implementation ReducedFatAskResultModel

-(void)setInfoWithDict:(NSDictionary*)dict
{
    self.questionStr = [dict safeObjectForKey:@"question"];
    self.resultStr   = [dict safeObjectForKey:@"result"];
    
    double questionHeight = [self getHeightWithStr:self.questionStr font:[UIFont boldSystemFontOfSize:16] width:JFA_SCREEN_WIDTH-70];
    double resultHeight   = [self getHeightWithStr:self.resultStr font:[UIFont systemFontOfSize:15] width:JFA_SCREEN_WIDTH-70];
    if (questionHeight<30) {
        questionHeight=30;
    }
    if (resultHeight<30) {
        resultHeight =30;
    }
    self.height = 35+resultHeight+questionHeight;
    
    DLog(@"h1-%.2f,h2-%.2f,h3-%.2f",self.height,questionHeight,resultHeight);
}

@end



@implementation ReducedLineModel


-(void)setInfoWithDict:(NSDictionary*)dict
{
    self.picture = [dict safeObjectForKey:@"picture"];
    self.content = [dict safeObjectForKey:@"content"];
    self.title   = [dict safeObjectForKey:@"title"];
    self.height  = 70+[self getHeightWithStr:self.content font:[UIFont systemFontOfSize:13] width:JFA_SCREEN_WIDTH/2-40];

}

@end

