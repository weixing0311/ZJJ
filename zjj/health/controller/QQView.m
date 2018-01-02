//
//  QQView.m
//  HuanxingDemo
//
//  Created by iOSdeveloper on 2017/12/4.
//  Copyright © 2017年 -call Me WeiXing. All rights reserved.
//

#import "QQView.h"
@implementation QQView
{
    CAShapeLayer* _progressLayer;
    UIView * imageView;
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGFloat lengths[] = {5,5,5,5};
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();//获取上下文
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2);  //设置圆心位置
    CGFloat radius = self.bounds.size.width/2-25;  //设置半径
    CGFloat startA =  M_PI_4*5.7/2;  //圆起点位置
    CGFloat endA = M_PI_4*5.7/2 + M_PI * 2*0.8 ;  //圆终点位置
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    CGContextSetLineWidth(ctx, 13); //设置线条宽度
    [[UIColor grayColor] setStroke]; //设置描边颜色
    CGContextSetLineDash(ctx, 0, lengths, 4); //设置线条为 虚线；
    CGContextAddPath(ctx, path.CGPath); //把路径添加到上下文
    CGContextStrokePath(ctx);  //渲染

    [self refreshProgressLayer];
    
    [self setMoveTherCircleWithProgress:_progress];

}

-(void)setMoveTherCircleWithProgress:(double)progress
{
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2);  //设置圆心位置
    CGFloat radius = self.bounds.size.width/2-25;  //设置半径

    float x1   =   center.x   +   radius   *   cos(M_PI_4*5.7/2);
    float y1   =   center.y   +   radius   *   sin(M_PI_4*5.7/2);

    imageView = [[UIView alloc]init];
    imageView.frame = CGRectMake(x1-5, y1-5, 10, 25);
    imageView.backgroundColor = RGBACOLOR(0, 0, 0, 0);
    CGAffineTransform transform1= CGAffineTransformRotate(imageView.transform, M_PI_4*5.7/2+M_PI_2);
    imageView.transform = transform1;//旋转

    [self addSubview:imageView];
    
    UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 16)];
    img.image =getImage(@"healthJt_");
    [imageView addSubview:img];
    
    
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = 1.0;
    pathAnimation.repeatCount = 0;
    //设置运转动画的路径
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathAddArc(curvedPath, NULL, self.bounds.size.width/2, self.bounds.size.width/2, self.bounds.size.width/2-15, M_PI_4*5.7/2, M_PI_4*5.7/2 + M_PI * 2*progress, 0);
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    [imageView.layer addAnimation:pathAnimation forKey:@"moveTheCircleOne"];

    
    if (progress>=0.5) {
      CGAffineTransform  transform = CGAffineTransformRotate(imageView.transform, M_PI_2 *4*0.4);
        [UIView animateWithDuration:0.4/progress animations:^{
            [imageView setTransform:transform];
        } completion:^(BOOL finished) {
            CGAffineTransform  transform = CGAffineTransformRotate(imageView.transform, M_PI_2 *4*(progress-0.4));
            [UIView animateWithDuration:1-0.4/progress animations:^{
                [imageView setTransform:transform];
            } completion:^(BOOL finished) {
                
            }];
        }];
    }else{
        CGAffineTransform  transform = CGAffineTransformRotate(imageView.transform, M_PI_2 *4*progress);
        [UIView animateWithDuration:1.0 animations:^{
            [imageView setTransform:transform];
        } completion:^(BOOL finished) {
            
        }];

    }
    
}

-(void)refreshProgressLayer
{
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2);  //设置圆心位置
    CGFloat radius = self.bounds.size.width/2-25;  //设置半径
    CGFloat startA =  M_PI_4*5.7/2;  //圆起点位置
    CGFloat endA = M_PI_4*5.7/2 + M_PI * 2*_progress ;  //圆终点位置

    //获取环形路径（画一个圆形，填充色透明，设置线框宽度为13，这样就获得了一个环形）
    //创建一个track shape layer
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = CGRectMake(0, 0, self.bounds.size.width-40, self.bounds.size.width-40);
    
    ///填充色为无色
    _progressLayer.fillColor = [[UIColor clearColor] CGColor];
    ///指定path的渲染颜色,这里可以设置任意不透明颜色
    _progressLayer.strokeColor = [[UIColor grayColor] CGColor];
    ///画虚线
    _progressLayer.lineDashPattern = @[@5, @5];
    //背景颜色的透明度
    _progressLayer.opacity = 1;
    //    _progressLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
    //线的宽度
    _progressLayer.lineWidth = 13;
    UIBezierPath *path3 = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];//上面说明过了用来构建圆形
    _progressLayer.path =[path3 CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
    [self.layer addSublayer:_progressLayer];
    
    [self createCorcleColor];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.fromValue = @(0);
    pathAnimation.toValue = @(1);
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_progressLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
}

///创建渐变色
-(void)createCorcleColor
{
    //生成渐变色
    CALayer *gradientLayer = [CALayer layer];
    
    //左侧渐变色
    CAGradientLayer *leftLayer = [CAGradientLayer layer];
    leftLayer.frame = CGRectMake(0, 0, self.bounds.size.width / 2, self.bounds.size.height);    // 分段设置渐变色
    leftLayer.locations = @[ @0.01,@0.02, @1];
    leftLayer.colors = @[(id)[UIColor greenColor].CGColor,(id)[UIColor greenColor].CGColor];
    [gradientLayer addSublayer:leftLayer];
    
    //Mid
    CAGradientLayer *midLayer = [CAGradientLayer layer];
    int blueWidth = 0;
    int blueStart = 0;
    if (iPhone6_6sPlus) {
        blueWidth = 8;
        blueStart = 2;
    }else{
        blueWidth = 10;
        blueStart = 0;
    }
    midLayer.frame = CGRectMake(self.bounds.size.width / 2-blueStart, 0, blueWidth, self.bounds.size.height);    // 分段设置渐变色

    midLayer.locations = @[ @0.05,@0.07, @1];
    midLayer.colors = @[(id)HEXCOLOR(0x15c4e4).CGColor,(id)[UIColor blueColor].CGColor];
    [gradientLayer addSublayer:midLayer];
    
    
    //右侧渐变色
    CAGradientLayer *rightLayer = [CAGradientLayer layer];
    rightLayer.frame = CGRectMake(self.bounds.size.width / 2+blueWidth, 0, self.bounds.size.width / 2-8, self.bounds.size.height);
    
    rightLayer.locations = @[@0.2, @0.4, @0.6,@0.8];
    rightLayer.colors = @[(id)HEXCOLOR(0xe8cc13).CGColor, (id)HEXCOLOR(0xe89700).CGColor,(id)HEXCOLOR(0xe80050).CGColor,(id)HEXCOLOR(0x3c0060).CGColor];
    [gradientLayer addSublayer:rightLayer];
    [gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:gradientLayer];

}

-(void)getProgressWithBfp:(float)bfp
{
    int level;
    if( [UserModel shareInstance].gender==1)
    {
        level = [self getManLevelWithBfp:bfp];
    }else{
        level = [self getWomanLevelWithBfp:bfp];
    }

    _progress = [self getpaiWithWeightLevel:level]-[self getDetailLocationWithbfp:bfp];
    [self  setNeedsDisplay];

}
//获取位置
-(float)getpaiWithWeightLevel:(int)level
{
    switch (level) {
        case 0:
            return 0;
            break;
        case 1:
            return 0.4;
            break;
        case 2:
            return 0.4;
            break;
        case 3:
            return 0.1+0.4;
            break;
        case 4:
            return 0.1*2+0.4;
            break;
        case 5:
            return 0.1*3+0.4;
            break;
        case 6:
            return 0.1*4+0.4;
            break;
            
        default:
            return 0.4+0.4;
            break;
    }
}

//获取精确位置

-(float)getDetailLocationWithbfp:(float)bfp
{
    
    if ([UserModel shareInstance].gender==1) {
      int  level = [self getManLevelWithBfp:bfp];

        
        
        
        
        
//        0.22 = 0.5----0.2 = 0.4
//                      0.1 = ?
//
//        ? = 0.1*0.4/0.2
//
//
//
//        0.24 = 0.6
//
//        0.02 = 0.1
//        0.01 = ?
//
//
//        0.28 = 0.7
//        0.3  = 0.8
//
//
//
//        return 0.4/0.2
        
        
        
        switch (level) {
            case 0:
                return 0.0;
                break;
            case 1:
                
                return (0.2-bfp) * 0.4/0.2;
                break;
            case 2:
                return (0.2-bfp)*0.4/0.2;
                break;
            case 3:
                return (0.24-bfp)*0.1/0.04;
                break;
            case 4:
                return (0.28-bfp)*0.1/0.04;
                break;
            case 5:
                return (0.30-bfp)*0.1/0.02;
                break;
            case 6:
                return fabs(0.4-bfp)*0.1/0.1;
                break;
                
            default:
                return 0.0;
                break;
        }
        
    }else{
       int level = [self getWomanLevelWithBfp:bfp];

        switch (level) {
            case 0:
                return 0.0;
                break;
            case 1:
                
                return (0.22-bfp)*0.4/0.22;
                break;
            case 2:
                return (0.22-bfp)*0.1/0.02;
                break;
            case 3:
                return (0.26-bfp)*0.1/0.04;
                break;
            case 4:
                return (0.29-bfp)*0.1/0.03;
                break;
            case 5:
                return (0.35-bfp)*0.1/0.06;
                break;
            case 6:
                return fabs(0.45-bfp)*0.1/0.1;
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


-(float)getMaxWithLevel:(int)level
{
   if ([UserModel shareInstance].gender==1)
    {
    switch (level) {
        case 1:
            return 0.16;
            break;
        case 2:
            return 0.2;
            break;
        case 3:
            return 0.24;
            break;
        case 4:
            return 0.28;
            break;
        case 5:
            return 0.30;
            break;
        case 6:
            return 0.4;
            break;

        default:
            return 0;
            break;
    }
    }else{
        switch (level) {
            case 1:
                return 0.18;
                break;
            case 2:
                return 0.22;
                break;
            case 3:
                return 0.26;
                break;
            case 4:
                return 0.29;
                break;
            case 5:
                return 0.35;
                break;
            case 6:
                return 0.45;
                break;
                
            default:
                return 0;
                break;
        }

    }
}
@end
