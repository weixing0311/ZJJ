//
//  ColorCircleView.m
//  HuanxingDemo
//
//  Created by iOSdeveloper on 2017/12/4.
//  Copyright © 2017年 -call Me WeiXing. All rights reserved.
//

#import "ColorCircleView.h"
@interface ColorCircleView ()
@property (nonatomic,strong) CAShapeLayer *shapeLayer;
@end

@implementation ColorCircleView

- (void)initType
{
    __block float a = 0.0;
    [self.circleArray enumerateObjectsUsingBlock:^(NSDictionary  *obj,NSUInteger idx, BOOL *_Nonnull stop) {
        //创建出CAShapeLayer
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.frame =CGRectMake(0,0, self.bounds.size.width-20,self.bounds.size.height-20);//设置shapeLayer的尺寸和位置
        
        //    self.shapeLayer.position = self.view.center;
        self.shapeLayer.fillColor = [UIColor clearColor].CGColor;//填充颜色为ClearColor
        //设置线条的宽度和颜色
        self.shapeLayer.lineWidth =10.0f;
        self.shapeLayer.strokeColor = [obj[@"strokeColor"]CGColor];
        
        //  第一个是 线条长度   第二个是间距    nil时为实线
        self.shapeLayer.lineDashPattern = @[@5, @5];

        
        //创建出圆形贝塞尔曲线
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(10,10, self.bounds.size.width-20,self.bounds.size.height-20)];
        [self setColor];
        //让贝塞尔曲线与CAShapeLayer产生联系
        self.shapeLayer.path = circlePath.CGPath;
        self.shapeLayer.cornerRadius = 100;
        self.shapeLayer.strokeStart = 0;
        self.shapeLayer.lineDashPattern = @[@5, @5];
        self.shapeLayer.strokeEnd = 0.8;//+a ;
        a = self.shapeLayer.strokeEnd;
        //添加并显示
        [self.layer addSublayer:self.shapeLayer];

        
        //添加圆环动画
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 1.0;
        pathAnimation.fromValue = @(0.0);
        pathAnimation.toValue = @(0.8);
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [self.shapeLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
        
        
    }];
}
-(void)setColor
{
    
    CALayer *gradientLayer = [CALayer layer];
    CAGradientLayer *gradientLayer1 =  [CAGradientLayer layer];
    gradientLayer1.frame = CGRectMake(0, self.height/2, self.width, self.height/2);
    [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[[UIColor greenColor] CGColor], nil]];
    [gradientLayer1 setLocations:@[@0.5,@0.9,@1 ]];
    [gradientLayer1 setStartPoint:CGPointMake(0.5, 1)];
    [gradientLayer1 setEndPoint:CGPointMake(0.5, 0)];
    [gradientLayer addSublayer:gradientLayer1];
    
    CAGradientLayer *gradientLayer2 =  [CAGradientLayer layer];
    [gradientLayer2 setLocations:@[@0.1,@0.5,@1]];
    gradientLayer2.frame = CGRectMake(0, 0, self.width/2, self.height/2);
    [gradientLayer2 setColors:[NSArray arrayWithObjects:(id)[HEXCOLOR(0xfde802) CGColor],(id)[[UIColor redColor] CGColor], nil]];
    [gradientLayer2 setStartPoint:CGPointMake(0.5, 0)];
    [gradientLayer2 setEndPoint:CGPointMake(0.5, 1)];
    [gradientLayer addSublayer:gradientLayer2];
    
    
    CAGradientLayer *gradientLayer3 =  [CAGradientLayer layer];
    [gradientLayer3 setLocations:@[@0.1,@0.5,@1]];
    gradientLayer3.frame = CGRectMake(self.width/2, 0, self.width/2, self.height/2);
    [gradientLayer3 setColors:[NSArray arrayWithObjects:(id)[[UIColor redColor] CGColor],(id)[[UIColor blackColor] CGColor], nil]];
    [gradientLayer3 setStartPoint:CGPointMake(0.5, 0)];
    [gradientLayer3 setEndPoint:CGPointMake(0.5, 1)];
    [gradientLayer addSublayer:gradientLayer2];
    [gradientLayer setMask:self.shapeLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:gradientLayer];

}



-(void)refreshRoleWithbfp:(float)bfp
{
    double curr = 0.0;
    
    
    curr = [self getDetailLocationWithLevel:[self getManLevelWithBfp:bfp] bfp:bfp]+[self getpaiWithWeightLevel:[self getManLevelWithBfp:(float)bfp]];
    double a = 0.4;
    double b = 0.1;
    double c = 0.1;
    double d = 0.1;
    double e = 0.1;
    DLog(@"curr--%.2f",curr);

    if (curr<=a) {
        self.circleArray =@[
                            @{
                                @"strokeColor":[UIColor greenColor],
                                @"precent"    :@(curr)
                                },
                            @{
                                @"strokeColor":[UIColor grayColor],
                                @"precent"    :@(0.8-curr)
                                }
                            ];
    }
    else if ( curr>a&&curr<=a+b)
    {
        self.circleArray =@[
                            @{
                                @"strokeColor":[UIColor greenColor],
                                @"precent"    :@(a)
                                },
                            @{
                                @"strokeColor":[UIColor yellowColor],
                                @"precent"    :@(curr-a)
                                },
                            @{
                                @"strokeColor":[UIColor grayColor],
                                @"precent"    :@(0.8-curr)
                                }
                            ];
        
        
    }
    else if ( curr>a+b&&curr<=a+b+c)
    {
        self.circleArray =@[
                            @{
                                @"strokeColor":[UIColor greenColor],
                                @"precent"    :@(a)
                                },
                            @{
                                @"strokeColor":[UIColor yellowColor],
                                @"precent"    :@(b)
                                },
                            @{
                                @"strokeColor":[UIColor orangeColor],
                                @"precent"    :@(curr-a-b)
                                },
                            
                            @{
                                @"strokeColor":[UIColor grayColor],
                                @"precent"    :@(0.8-curr)
                                }
                            ];
        
        
    }
    else if ( curr>a+b+c&&curr<=a+b+c+d)
    {
        self.circleArray =@[
                            @{
                                @"strokeColor":[UIColor greenColor],
                                @"precent"    :@(a)
                                },
                            @{
                                @"strokeColor":[UIColor yellowColor],
                                @"precent"    :@(b)
                                },
                            @{
                                @"strokeColor":[UIColor orangeColor],
                                @"precent"    :@(c)
                                },
                            @{
                                @"strokeColor":[UIColor redColor],
                                @"precent"    :@(curr-a-b-c)
                                },
                            
                            @{
                                @"strokeColor":[UIColor grayColor],
                                @"precent"    :@(0.8-curr)
                                }
                            ];
        
    }
    else if ( curr>a+b+c+d&&curr<=a+b+c+d+e)
    {
        self.circleArray =@[
                            @{
                                @"strokeColor":[UIColor greenColor],
                                @"precent"    :@(a)
                                },
                            @{
                                @"strokeColor":[UIColor yellowColor],
                                @"precent"    :@(b)
                                },
                            @{
                                @"strokeColor":[UIColor orangeColor],
                                @"precent"    :@(c)
                                },
                            @{
                                @"strokeColor":[UIColor redColor],
                                @"precent"    :@(d)
                                },
                            
                            @{
                                @"strokeColor":[UIColor blueColor],
                                @"precent"    :@(curr-a-b-c-d)
                                },
                            
                            @{
                                @"strokeColor":[UIColor grayColor],
                                @"precent"    :@(0.8-curr)
                                }
                            ];
        
    }
    else
    {
        self.circleArray =@[
                            @{
                                @"strokeColor":[UIColor greenColor],
                                @"precent"    :@(a)
                                },
                            @{
                                @"strokeColor":[UIColor yellowColor],
                                @"precent"    :@(b)
                                },
                            @{
                                @"strokeColor":[UIColor orangeColor],
                                @"precent"    :@(b)
                                },
                            @{
                                @"strokeColor":[UIColor redColor],
                                @"precent"    :@(c)
                                },
                            @{
                                @"strokeColor":[UIColor blueColor],
                                @"precent"    :@(d)
                                },
                            
                            @{
                                @"strokeColor":[UIColor purpleColor],
                                @"precent"    :@(e)
                                },
                            
                            ];
        
    }

}

//获取位置
-(float)getpaiWithWeightLevel:(int)level
{
    switch (level) {
        case 0:
            return 0;
            break;
        case 1:
            return 0;
            break;
        case 2:
            return 0.4;
            break;
        case 3:
            return 0.4/5+0.4;
            break;
        case 4:
            return 0.4/5*2+0.4;
            break;
        case 5:
            return 0.4/5*3+0.4;
            break;
        case 6:
            return 0.4/5*4+0.4;
            break;
            
        default:
            return 0.4+0.4;
            break;
    }
}
//获取精确位置
-(float)getDetailLocationWithLevel:(int)level bfp:(float)bfp
{
    BOOL isMan =YES;
    if (isMan==YES) {
        switch (level) {
            case 0:
                return 0.0;
                break;
            case 1:
                
                return (0.16-bfp)/bfp;
                break;
            case 2:
                return (0.2-bfp)/bfp*0.4/5;
                break;
            case 3:
                return (0.24-bfp)/bfp*0.4/5;
                break;
            case 4:
                return (0.28-bfp)/bfp*0.4/5;
                break;
            case 5:
                return (0.30-bfp)/bfp*0.4/5;
                break;
            case 6:
                return fabs(0.4-bfp)/bfp*0.4/5;
                break;
                
            default:
                return 0.0;
                break;
        }
        
    }else{
        switch (level) {
            case 0:
                return 0.0;
                break;
            case 1:
                
                return (0.18-bfp)/bfp;
                break;
            case 2:
                return (0.22-bfp)/bfp*0.4/5;
                break;
            case 3:
                return (0.26-bfp)/bfp*0.4/5;
                break;
            case 4:
                return (0.29-bfp)/bfp*0.4/5;
                break;
            case 5:
                return (0.35-bfp)/bfp*0.4/5;
                break;
            case 6:
                return fabs(0.45-bfp)/bfp*0.4/5;
                break;
                
            default:
                return 0.0;
                break;
        }
        
    }
    
}


//获取等级
-(int)getManLevelWithBfp:(float)bfp
{
    if (bfp<0.16) {
        //偏瘦
        return 1;
    }
    else if(bfp>=0.16&&bfp<0.2)
    {
        //        正常
        return 2;
    }
    else if(bfp>=0.2&&bfp<0.24)
    {
        //        WEIGHT_LIGHT_FAT
        return 3;
    }
    else if(bfp>=0.24&&bfp<0.28)
    {
        //        WEIGHT_MODERATE_FAT
        return 4;
    }
    else if(bfp>=0.28&&bfp<0.30)
    {
        //        WEIGHT_SEVERE_FAT
        return 5;
    }
    else if(bfp>=0.3)
    {
        //        WEIGHT_EXTREME_FAT
        return 6;
    }
    else{
        return 0;
    }
    
}
//获取等级
-(int)getWomanLevelWithBfp:(float)bfp
{
    if (bfp<0.18) {
        //偏瘦
        return 1;
    }
    else if(bfp>=0.18&&bfp<0.22)
    {
        //        正常
        return 2;
    }
    else if(bfp>=0.22&&bfp<0.26)
    {
        //        WEIGHT_LIGHT_FAT
        return 3;
    }
    else if(bfp>=0.26&&bfp<0.29)
    {
        //        WEIGHT_MODERATE_FAT
        return 4;
    }
    else if(bfp>=0.29&&bfp<0.35)
    {
        //        WEIGHT_SEVERE_FAT
        return 5;
    }
    else if(bfp>=0.35)
    {
        //        WEIGHT_EXTREME_FAT
        return 6;
    }
    else{
        return 0;
    }
    
}





- (void)setCircleArray:(NSArray *)circleArray
{
    _circleArray = circleArray;
    [self initType];
    
}

@end
