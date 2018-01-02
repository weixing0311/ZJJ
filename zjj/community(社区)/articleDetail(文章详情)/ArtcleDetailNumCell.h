//
//  ArtcleDetailNumCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/10/24.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ArtcleDetailNumCellDelegate;
@interface ArtcleDetailNumCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *zanLabel;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UILabel *firstLb;
@property (weak, nonatomic) IBOutlet UILabel *zanCountLb;
@property (weak, nonatomic) IBOutlet UIButton *didZanBtn;
@property (nonatomic,assign)id<ArtcleDetailNumCellDelegate>delegate;
- (IBAction)didClickZan:(id)sender;

@end
@protocol ArtcleDetailNumCellDelegate <NSObject>
-(void)didZanWithCell:(ArtcleDetailNumCell*)cell;
@end
