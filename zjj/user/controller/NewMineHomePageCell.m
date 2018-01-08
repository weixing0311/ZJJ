//
//  NewMineHomePageCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/21.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewMineHomePageCell.h"

@implementation NewMineHomePageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeBGiamgeViewImage)];
    tap.delegate= self;
    [self.bgImageView addGestureRecognizer:tap];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width/2;
    self.gzBtn.layer.borderWidth= 1;
    self.gzBtn.layer.borderColor = HEXCOLOR(0xeeeeee).CGColor;

//    self.bgImageView.contentMode =UIViewContentModeScaleAspectFill;
//    self.bgImageView.clipsToBounds = YES;

    // Initialization code
}
-(void)setUpCellWithDict:(NSDictionary *)dict userId:(NSString *)userId
{
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.height/2;
    [self.headImageView sd_setBackgroundImageWithURL:[NSURL URLWithString:[dict safeObjectForKey:@"headimgurl"]] forState:UIControlStateNormal placeholderImage:getImage(@"head_default")
     ];
    
    self.levellb.text = [dict safeObjectForKey:@"gradeName"];
    
    self.heightlb.text = [NSString stringWithFormat:@"%@cm",[dict safeObjectForKey:@"heigth"]?[dict safeObjectForKey:@"heigth"]:@"0"];
    self.agelb.text = [NSString stringWithFormat:@"%@岁",[dict safeObjectForKey:@"age"]?[dict safeObjectForKey:@"age"]:@"0"];
    self.locationlb.text = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"location"]?[dict safeObjectForKey:@"location"]:@""];

    
    if ([[dict safeObjectForKey:@"isVip"]isEqualToString:@"1"]) {
        self.vipImg.hidden =NO;
        NSString * videoPath = [dict safeObjectForKey:@"videoPath"];
        
        if (videoPath.length>5) {
            [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:[dict safeObjectForKey:@"videoImg"]] placeholderImage:getImage(@"mine_bg_") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (error) {
                    return ;
                }
                self.bgImageView.image = [self cutImage:image imgViewWidth:image.size.width imgViewHeight:image.size.width*0.56];
            }];

        }else{
            [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:[dict safeObjectForKey:@"starBackGround"]] placeholderImage:getImage(@"mine_bg_") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (error) {
                    return ;
                }
                self.bgImageView.image = [self cutImage:image imgViewWidth:image.size.width imgViewHeight:image.size.width*0.56];
            }];

        }

        

    }else{
        self.vipImg.hidden = YES;
        [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:[dict safeObjectForKey:@"backGroundImg"]] placeholderImage:getImage(@"mine_bg_") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error) {
                return ;
            }
            self.bgImageView.image = [self cutImage:image imgViewWidth:image.size.width imgViewHeight:image.size.width*0.56];
        }];

    }
    
    
    self.nicknamelb.text = [dict safeObjectForKey:@"nickName"];
    NSString * introduction = [dict safeObjectForKey:@"introduction"];
    if (introduction.length<1) {
        self.jjlb.text = @"还没有编辑简介~";
    }else{
        self.jjlb.text = [NSString stringWithFormat:@"简介：%@",introduction];
    }
    int  sex = [[dict safeObjectForKey:@"sex"]intValue];
    if (sex ==1) {
        self.sexImageView.image = getImage(@"man_");
        
    }else{
        self.sexImageView.image =getImage(@"woman_");
    }
    
    if ([userId isEqualToString:[UserModel shareInstance].userId]) {
        self.gzBtn.hidden = YES;
    }else{
        self.gzBtn.hidden = NO;
        
        if ([[dict safeObjectForKey:@"isFollow"]isEqualToString:@"1"]) {
            self.gzBtn.selected = YES;
            self.gzBtn.layer.borderColor = HEXCOLOR(0xeeeeee).CGColor;

        }else{
            self.gzBtn.selected = NO;
            self.gzBtn.layer.borderColor = [UIColor redColor].CGColor;
        }
    }
    NSString * videoPath =[dict safeObjectForKey:@"videoPath"];
    if (videoPath.length>5) {
        self.videoPlayBtn.hidden = NO;
    }else{
        self.videoPlayBtn.hidden = YES;
    }
}



-(void)changeBGiamgeViewImage
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(changeBgImageView)]) {
        [self.delegate changeBgImageView];
    }
}

- (IBAction)editUserInfo:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didShowChangeUserInfoPage)]) {
        [self.delegate didShowChangeUserInfoPage];
    }
}
- (IBAction)editHeaderImage:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didChangeHeaderImage)]) {
        [self.delegate didChangeHeaderImage];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didClickGz:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didGzUserWithCell:)]) {
        [self.delegate didGzUserWithCell:self];
    }

    
}


- (UIImage *)cutImage:(UIImage*)image imgViewWidth:(CGFloat)width imgViewHeight:(CGFloat)height

{
    
    //压缩图片
    
    
    
    CGSize newSize;
    
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < (width / height)) {
        
        newSize.width = image.size.width;
        
        newSize.height = image.size.width * height /width;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, 0, newSize.width, newSize.height));
        
    } else {
        
        newSize.height = image.size.height;
        
        newSize.width = image.size.height * width / height;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
        
    }
    return [UIImage imageWithCGImage:imageRef];
    
}

- (IBAction)didClickPlay:(id)sender {
    self.videoPlayBtn.hidden =YES;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didPlayVideoWithCell:)]) {
        [self.delegate didPlayVideoWithCell:self];
    }
}
@end
