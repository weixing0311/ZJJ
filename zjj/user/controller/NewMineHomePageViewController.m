//
//  NewMineHomePageViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewMineHomePageViewController.h"
#import "PublicArticleCell.h"
#import "NewMineHomePageCell.h"
#import "CommunityModel.h"
#import "WriteArtcleViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CLPlayerView.h"
#import "UIView+CLSetRect.h"
#import "Masonry.h"
#import "EditUserInfoImageCell.h"
#import "ArticleDetailViewController.h"
#import "EditUserInfoViewController.h"
#import "BeforeAfterContrastCell.h"
#import "FcBigImgViewController.h"
#import "CommunityCell.h"
#import "NewMineFatLineCell.h"
#import "NewMineFatInterCell.h"
#import "NewMineModel.h"
#import "JbView.h"
@interface NewMineHomePageViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
PublicArticleCellDelegate,
NewMineHomePageHeaderCellDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
BigImageArticleCellDelegate
>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableArray * reducedFatLineArray;
@property (nonatomic,strong)NSMutableArray * reducedFatQuestionArray;

@property (nonatomic, weak) CLPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (nonatomic,strong)NSMutableDictionary * infoDict;

@end

@implementation NewMineHomePageViewController
{
    int page;
    int pageSize;
    CommunityCell * PlayingCell;
    int changeImageNum;
    
    JbView *jbv;
    

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    [self.tableview.mj_header beginRefreshing];
    [self setTBWhiteColor];


}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_playerView destroyPlayer];
    _playerView = nil;
    PlayingCell = nil;
    [self clearSDCeche];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @" ";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshMyInfo) name:@"refreshHomePageInfo" object:nil];
//    if (![self.userId isEqualToString:[UserModel shareInstance].userId]) {
//        self.shareBtn.hidden = YES;
//    }else{
//        self.shareBtn.hidden = NO;
//    }
    
    
    
    
    self.tableview.delegate=self;
    self.tableview.dataSource= self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    pageSize = 30;
    self.dataArray = [NSMutableArray array];
    self.reducedFatQuestionArray = [NSMutableArray array];
    self.reducedFatLineArray = [NSMutableArray array];

    self.infoDict = [NSMutableDictionary dictionary];
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self setRefrshWithTableView:self.tableview];
}

-(void)refreshMyInfo
{
    [self.tableview.mj_header beginRefreshing];
}
-(void)headerRereshing
{
    page =1;
    [self getinfo];
}
-(void)footerRereshing
{
    page++;
    [self getinfo];
}

-(void)getinfo
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.userId forKey:@"userId"];
    [params safeSetObject:@(pageSize) forKey:@"pageSize"];
    [params safeSetObject:@(page) forKey:@"page"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/usertArticleDetail/queryUserHome.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        [self.tableview.mj_footer endRefreshing];
        [self.tableview.mj_header endRefreshing];
        
        if (page ==1) {
            [self.dataArray removeAllObjects];
            [self.reducedFatQuestionArray removeAllObjects];
            [self.reducedFatLineArray removeAllObjects];
            self.tableview.mj_footer.hidden = NO;
        }
        
        NSDictionary * dataDic  = [dic safeObjectForKey:@"data"];
        self.infoDict = [dataDic safeObjectForKey:@"article"];
        NSArray * infoArr = [dataDic safeObjectForKey:@"array"];
        if (infoArr.count<30) {
            self.tableview.mj_footer.hidden = YES;
        }

        
        
        NSArray * coursesArr = [self.infoDict safeObjectForKey:@"courses"];
        for (NSDictionary * infoDict in coursesArr) {
            ReducedLineModel * model = [[ReducedLineModel alloc]init];
            [model setInfoWithDict:infoDict];
            [self.reducedFatLineArray addObject:model];
        }
        
        NSArray * interviewsArr = [self.infoDict safeObjectForKey:@"interviews"];
        for (NSDictionary * infoDict in interviewsArr) {
            ReducedFatAskResultModel * model = [[ReducedFatAskResultModel alloc]init];
            [model setInfoWithDict:infoDict];
            [self.reducedFatQuestionArray addObject:model];
        }

        
        
        
        NSString * isVip = [self.infoDict safeObjectForKey:@"isVip"];
        
        for (NSMutableDictionary * infoDic in infoArr) {
            CommunityModel * item = [[CommunityModel alloc]init];
            [item setInfoWithDict:infoDic];
            item.vip = isVip;
            [self.dataArray addObject:item];
        }

        [self.tableview reloadData];

        
        DLog(@"%@",dic);
    } failure:^(NSError *error) {
        [self.tableview.mj_footer endRefreshing];
        [self.tableview.mj_header endRefreshing];
    }];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section ==0) {
        return JFA_SCREEN_WIDTH/2+110;
    }
    else if(indexPath.section ==1)
    {
        return 180;
    }
    else if(indexPath.section==2)
    {
        return JFA_SCREEN_WIDTH*0.7;
    }
    else if(indexPath.section ==3)
    {
        ReducedLineModel * model = _reducedFatLineArray[indexPath.row];
        return model.height>200?model.height:200;
    }
    else if(indexPath.section ==4)
    {
        ReducedFatAskResultModel * model = _reducedFatQuestionArray[indexPath.row];
        return model.height;
    }
    else
    {
        CommunityModel * item =[self.dataArray objectAtIndex:indexPath.row];
        float rowheight = item.rowHieght;
        return rowheight;
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==3)
    {
        return self.reducedFatLineArray.count;
    }else if(section ==4)
    {
        return self.reducedFatQuestionArray.count;
    }
    else if (section ==5)
    {
       return self.dataArray.count;;
    }
    else
    {
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        static NSString * identifier = @"NewMineHomePageCell";
        NewMineHomePageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setUpCellWithDict:_infoDict userId:self.userId];
        return cell;
    }
    
    else if(indexPath.section ==1)
    {
        static NSString * identifier = @"BeforeAfterContrastCell";
        BeforeAfterContrastCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setUpCellWithDict:_infoDict];
        return cell;
    }
    else if(indexPath.section ==2)
    {
        static NSString * identifier = @"EditUserInfoImageCell";
        EditUserInfoImageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setInfoWithDict:_infoDict];
        return cell;
        
    }
    else if(indexPath.section ==3)
    {
        
        ReducedLineModel  * model = [_reducedFatLineArray objectAtIndex:indexPath.row];
        
        static NSString * identifier = @"NewMineFatLineCell";
        NewMineFatLineCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }

        [cell setViewHidden:indexPath.row];
        cell.model = model;
        cell.tag = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    else if(indexPath.section ==4)
    {
        ReducedFatAskResultModel  * model = [_reducedFatQuestionArray objectAtIndex:indexPath.row];
        

        static NSString * identifier = @"NewMineFatInterCell";
        NewMineFatInterCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        
        cell.model = model;
        cell.tag = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell.img2 sd_setImageWithURL:[NSURL URLWithString:[self.infoDict safeObjectForKey:@"headimgurl"]] placeholderImage:getImage(@"head_default")];
        return cell;

    }
    else
    {
        CommunityModel * item =[self.dataArray objectAtIndex:indexPath.row];
        
        
        if (item.pictures.count==1||item.movieStr.length>5) {
            static  NSString * identifier = @"CommunityCell";
            CommunityCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [self getXibCellWithTitle:identifier];
            }
            cell.delegate = self;
            cell.tag = indexPath.row;
            [cell setInfoWithDict:item];
            
////            if ([item.userId isEqualToString:[UserModel shareInstance].userId]) {
//                cell.gzBtn.hidden = YES;
//            }else{
                cell.gzBtn.hidden = YES;
//            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else{
            static  NSString * identifier = @"PublicArticleCell";
            PublicArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [self getXibCellWithTitle:identifier];
            }
            cell.delegate = self;
            cell.tag = indexPath.row;
            [cell setInfoWithDict:item];
            [cell loadImagesWithItem:item];
            
//            if ([item.userId isEqualToString:[UserModel shareInstance].userId]) {
                cell.gzBtn.hidden = YES;
//            }else{
//                cell.gzBtn.hidden = NO;
//            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }

    }
}
//cell离开tableView时调用
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //因为复用，同一个cell可能会走多次
    if (indexPath.section ==5) {
        if ([PlayingCell isEqual:cell]) {
            //区分是否是播放器所在cell,销毁时将指针置空
            [_playerView destroyPlayer];
            PlayingCell = nil;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==1) {
        return 1;
    }
    else if(section ==2)
    {
        return 40;
    }
    else if (section ==3)
    {
        return _reducedFatLineArray.count>0?40:0.01;
    }
    else if (section ==4)
    {
        return  _reducedFatLineArray.count>0?40:0.01;
    }
    else if (section ==5)
    {
        return 40;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 5;
            break;
        case 1:
            return 9;
            break;
        case 2:
            return 9;
            break;
        case 3:
            return _reducedFatLineArray.count>0?10:0.01;
            break;
        case 4:
            return _reducedFatLineArray.count>0?10:0.01;
            break;
        case 5:
            return _dataArray.count>0?10:10;
            break;

        default:
            break;
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * view =[[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 30)];
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = HEXCOLOR(0x666666);
    [view addSubview:label];
    
    switch (section) {
        case 0:
            label.text = @"";
            break;
        case 1:
            view.backgroundColor = HEXCOLOR(0xeeeeee);
            label.text = @"";
            break;
        case 2:
            label.text = @"减脂前后";
            break;
        case 3:
            label.text = _reducedFatLineArray.count>0?@"减脂历程":@"";
            break;
        case 4:
            label.text = _reducedFatQuestionArray.count>0?@"减脂访谈":@"";
            break;
        case 5:
            label.text = @"最新动态";
            break;

        default:
            break;
    }
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view =[[UIView alloc]init];
    view.backgroundColor =HEXCOLOR(0xeeeeee);
    return view;
}
#pragma mark - 滑动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // visibleCells 获取界面上能显示出来了cell
    NSArray<PublicArticleCell *> *array = [self.tableview visibleCells];
    //enumerateObjectsUsingBlock 类似于for，但是比for更快
    [array enumerateObjectsUsingBlock:^(PublicArticleCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                [obj cellOffset];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==5){
    CommunityModel * model = [_dataArray objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ArticleDetailViewController * ard =[[ArticleDetailViewController alloc]init];
    ard.infoModel = model;
    [self.navigationController pushViewController:ard animated:YES];
    }
    else if(indexPath.section ==2)
    {
        [self didShowChangeUserInfoPage];
    }
}



#pragma mark ---cell delegate


- (IBAction)didClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)didClickShare:(id)sender {
    
    UIAlertController * al =[UIAlertController alertControllerWithTitle:@"分享" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [al addAction:[UIAlertAction actionWithTitle:@"微信朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatTimeline ];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatSession ];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"QQ好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformTypeQQ ];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    
    [self presentViewController:al animated:YES completion:nil];
}

#pragma  mark ---cell delegate


-(void)didPlayVideoWithCell:(NewMineHomePageCell*)cell
{
    //销毁播放器
    [_playerView destroyPlayer];
    CLPlayerView *playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, 0, (JFA_SCREEN_WIDTH), JFA_SCREEN_WIDTH*0.5)];
    _playerView = playerView;
    [cell.bgImageView addSubview:_playerView];
    [cell.bgImageView bringSubviewToFront:_playerView];
    //    _playerView.fillMode = ResizeAspectFill;
    
    //视频地址
    _playerView.url = [NSURL URLWithString:[self.infoDict safeObjectForKey:@"videoPath"]];
    //播放
    [_playerView playVideo];
    //返回按钮点击事件回调
    [_playerView backButton:^(UIButton *button) {
        NSLog(@"返回按钮被点击");
        [_playerView destroyPlayer];
        cell.videoPlayBtn.hidden =NO;
        _playerView = nil;
        PlayingCell = nil;
        
    }];
    //播放完成回调
    [_playerView endPlay:^{
        //销毁播放器
        [_playerView destroyPlayer];
        cell.videoPlayBtn.hidden =NO;
        _playerView = nil;
        PlayingCell = nil;
        
        NSLog(@"播放完成");
    }];
    
}








-(void)didShowChangeUserInfoPage
{
    
    if ([self.userId isEqualToString:[UserModel shareInstance].userId]) {
        EditUserInfoViewController * edit =[[EditUserInfoViewController alloc]init];
        edit.infoDict = self.infoDict;

         [edit.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"userId"] forKey:@"userId"];
         [edit.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"nickName"] forKey:@"nickName"];
         [edit.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"sex"] forKey:@"sex"];
         [edit.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"heigth"] forKey:@"heigth"];
         [edit.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"birthday"] forKey:@"birthday"];
        [self.navigationController pushViewController:edit animated:YES];
    }
}
-(void)didChangeHeaderImage
{
    
    if ([self.userId isEqualToString:[UserModel shareInstance].userId]) {
        [self didShowChangeUserInfoPage];
    }
}
-(void)changeBgImageView
{
    if ([self.userId isEqualToString:[UserModel shareInstance].userId]) {
        changeImageNum =2;
        [self ChangeHeadImageWithTitle:@"更换背景"];

    }
//    app/user/uploadBackGroundImg.do   userId   imgurl
}
-(void)didShareMyInfo
{
    
}
-(void)didGzWithCell:(PublicArticleCell*)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];

    [SVProgressHUD showWithStatus:@"修改中"];
    if (cell.gzBtn.selected==YES) {
        NSMutableDictionary * params =[NSMutableDictionary dictionary];
        [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
        [params setObject:model.userId forKey:@"followId"];
        self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/userfollow/removeUserFollow.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
            
            model.isFollow = @"0";
            PublicArticleCell * currCell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cell.tag inSection:0]];
            currCell.gzBtn.selected =YES;
            currCell.gzBtn.layer.borderColor = HEXCOLOR(0x666666).CGColor;
            
            if (_dataArray.count>100) {
                return ;
            }
            for (CommunityModel * allmodel  in _dataArray) {
                if ([allmodel.userId isEqualToString:model.userId]) {
                    allmodel.isFollow = @"0";
                }
            }
            [[UserModel shareInstance]showSuccessWithStatus: @"取消关注成功"];
            
            [self.tableview reloadData];
            
        } failure:^(NSError *error) {
            
        }];
        
    }else{

    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:model.userId forKey:@"followId"];
    [params safeSetObject:model.uid forKey:@"articleId"];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/articlepage/attentUser.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        [[UserModel shareInstance]showSuccessWithStatus:@"关注成功"];
        model.isFollow = @"1";
        PublicArticleCell * currCell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cell.tag inSection:0]];
        currCell.gzBtn.selected =YES;
        currCell.gzBtn.layer.borderColor = HEXCOLOR(0x666666).CGColor;

    } failure:^(NSError *error) {
        
    }];
    
    }
}
-(void)didZanWithCell:(PublicArticleCell*)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"" forKey:@"commentId"];
    [params safeSetObject:model.uid forKey:@"articleId"];
    if (model.isFabulous&&[model.isFabulous isEqualToString:@"1"]) {
        [params safeSetObject:@"0" forKey:@"isFabulous"];//1是点赞 0取消
    }else{
        [params safeSetObject:@"1" forKey:@"isFabulous"];//1是点赞 0取消
    }
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/userGreat/updateIsFabulous.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        if (model.isFabulous&&[model.isFabulous isEqualToString:@"1"]) {
            [[UserModel shareInstance]showSuccessWithStatus:@"取消点赞成功"];
            
        }else{
            [[UserModel shareInstance]showSuccessWithStatus:@"点赞成功"];
            
        }
        [self refreshZanInfoWithCell:cell];
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)refreshZanInfoWithCell:(PublicArticleCell*)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
    
    if ([model.isFabulous isEqualToString:@"1"]) {
        model.isFabulous = @"0";//1是点赞 0取消
        int zanCount = [cell.zanCountlb.text intValue];
        cell.zanCountlb.text = [NSString stringWithFormat:@"%d",zanCount-1];
        cell.zanImageView.image = getImage(@"praise");
        cell.zanCountlb.textColor = HEXCOLOR(0x666666);

    }else{
        model.isFabulous = @"1";
        int zanCount = [cell.zanCountlb.text intValue];
        cell.zanCountlb.text = [NSString stringWithFormat:@"%d",zanCount+1];
        cell.zanImageView.image = getImage(@"praise_Selected");
        cell.zanCountlb.textColor = [UIColor orangeColor];

    }
    
}

-(void)didPLWithCell:(PublicArticleCell*)cell
{
    [self enterDetailPageWithIndex:cell.tag];
    //
}
-(void)didShareWithCell:(PublicArticleCell*)cell
{
    [self shareWithIndex:cell.tag];
    
    //    /app/community/article/updateForwardingnum.do
    //        参数：    id //文章Id
}

-(void)didShowBigImageWithCell:(PublicArticleCell*)cell index:(NSInteger)index
{
    [self showBigImageViewWithIndex:cell.tag page:index];
    
}
-(void)didJBWithCell:(PublicArticleCell *)cell
{
    [self didJbWithIndex:cell.tag];
}
-(void)didTapHeadImageViewWithCell:(PublicArticleCell *)cell
{
    [self enterUserPageViewWithIndex:cell.tag];
}
-(void)refreshCellRowHeightWithBigCell:(CommunityCell*)cell height:(double)height
{
    
}
-(void)didPlayWithBigCell:(CommunityCell *)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
    //记录被点击的Cell
    PlayingCell = cell;
    //销毁播放器
    [_playerView destroyPlayer];
    CLPlayerView *playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, 0, (JFA_SCREEN_WIDTH-20), (JFA_SCREEN_WIDTH-20)*0.6)];
    _playerView = playerView;
    [cell.playerBgView addSubview:_playerView];
    [cell.playerBgView bringSubviewToFront:_playerView];
    //    _playerView.fillMode = ResizeAspectFill;
    
    //视频地址
    _playerView.url = [NSURL URLWithString:model.movieStr];
    //播放
    [_playerView playVideo];
    //返回按钮点击事件回调
    [_playerView backButton:^(UIButton *button) {
        NSLog(@"返回按钮被点击");
        [_playerView destroyPlayer];
        _playerView = nil;
        PlayingCell = nil;
        
    }];
    //播放完成回调
    [_playerView endPlay:^{
        //销毁播放器
        [_playerView destroyPlayer];
        _playerView = nil;
        PlayingCell = nil;
        
        NSLog(@"播放完成");
    }];
    
}
-(void)didGzWithBigCell:(CommunityCell*)cell
{
    
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
    [SVProgressHUD showWithStatus:@"修改中。。。"];
    if (cell.gzBtn.selected==YES) {
        NSMutableDictionary * params =[NSMutableDictionary dictionary];
        [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
        [params setObject:model.userId forKey:@"followId"];
        self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/userfollow/removeUserFollow.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
            
            model.isFollow = @"0";
            CommunityCell * currCell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cell.tag inSection:0]];
            currCell.gzBtn.selected =YES;
            currCell.gzBtn.layer.borderColor = HEXCOLOR(0x666666).CGColor;
            
            if (_dataArray.count>100) {
                return ;
            }
            for (CommunityModel * allmodel  in _dataArray) {
                if ([allmodel.userId isEqualToString:model.userId]) {
                    allmodel.isFollow = @"0";
                }
            }
            [[UserModel shareInstance]showSuccessWithStatus: @"取消关注成功"];
            
            [self.tableview reloadData];
            
        } failure:^(NSError *error) {
            
        }];
        
    }else{

    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:model.userId forKey:@"followId"];
    [params safeSetObject:model.uid forKey:@"articleId"];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/articlepage/attentUser.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        [[UserModel shareInstance]showSuccessWithStatus:@"关注成功"];
        model.isFollow = @"1";
        CommunityCell * currCell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cell.tag inSection:0]];
        currCell.gzBtn.selected =YES;
        currCell.gzBtn.layer.borderColor = HEXCOLOR(0x666666).CGColor;

    } failure:^(NSError *error) {
        
    }];
    }
    
}
-(void)didZanWithBigCell:(CommunityCell*)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"" forKey:@"commentId"];
    [params safeSetObject:model.uid forKey:@"articleId"];
    if (model.isFabulous&&[model.isFabulous isEqualToString:@"1"]) {
        [params safeSetObject:@"0" forKey:@"isFabulous"];//1是点赞 0取消
    }else{
        [params safeSetObject:@"1" forKey:@"isFabulous"];//1是点赞 0取消
    }
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/userGreat/updateIsFabulous.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        if (model.isFabulous&&[model.isFabulous isEqualToString:@"1"]) {
            [[UserModel shareInstance]showSuccessWithStatus:@"取消点赞成功"];
            
        }else{
            [[UserModel shareInstance]showSuccessWithStatus:@"点赞成功"];
            
        }
        [self refreshZanInfoWithBigCell:cell];
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)refreshZanInfoWithBigCell:(CommunityCell*)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
    
    if ([model.isFabulous isEqualToString:@"1"]) {
        model.isFabulous = @"0";//1是点赞 0取消
        int zanCount = [cell.zanCountlb.text intValue];
        cell.zanCountlb.text = [NSString stringWithFormat:@"%d",zanCount-1];
        cell.zanImageView.image = getImage(@"praise");
        cell.zanCountlb.textColor = HEXCOLOR(0x666666);

    }else{
        model.isFabulous = @"1";
        int zanCount = [cell.zanCountlb.text intValue];
        cell.zanCountlb.text = [NSString stringWithFormat:@"%d",zanCount+1];
        cell.zanImageView.image = getImage(@"praise_Selected");
        cell.zanCountlb.textColor = [UIColor orangeColor];

    }
    
}

-(void)didPLWithBigCell:(CommunityCell*)cell
{
    [self enterDetailPageWithIndex:cell.tag];
}
-(void)didShareWithBigCell:(CommunityCell*)cell
{
    [self shareWithIndex:cell.tag];
}
-(void)didShowBigImageWithBigCell:(CommunityCell*)cell index:(NSInteger)index
{
    [self showBigImageViewWithIndex:cell.tag page:index];
}
-(void)didJBWithBigCell:(CommunityCell *)cell
{
    [self didJbWithIndex:cell.tag];
}
-(void)loadImageSuccessWithBigCell:(CommunityCell *)cell
{
    
}
-(void)didTapHeadImageViewWithBigCell:(CommunityCell *)cell
{
    [self enterUserPageViewWithIndex:cell.tag];
}



-(void)enterUserPageViewWithIndex:(NSInteger)index
{
    CommunityModel * model =[_dataArray objectAtIndex:index];
    
    
    NewMineHomePageViewController * mine = [[NewMineHomePageViewController alloc]init];
    mine.userId = model.userId;
    [self.navigationController pushViewController:mine animated:YES];
    
}

-(void)showBigImageViewWithIndex:(NSInteger)index page:(int)page
{
    CommunityModel * item = [_dataArray objectAtIndex:index];
    FcBigImgViewController * fc =[[FcBigImgViewController alloc]init];
    fc.images = [NSMutableArray arrayWithArray:item.pictures];
    fc.page = page;
    
    [self presentViewController:fc animated:YES completion:nil];
    
}
-(void)didJbWithIndex:(NSInteger)index
{
    ///app/reportArticle/updateIsreported.do
    //参数：    userId //用户Id
    //articleId //文章Id
    //reportContent //举报原因
    
    CommunityModel * model = [_dataArray objectAtIndex:index];
    
    if ([model.userId isEqualToString:[UserModel shareInstance].userId]) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"确定要删除此文章吗？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction: [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            [params safeSetObject:model.uid forKey:@"articleId"];
            [params safeSetObject:alert.textFields.firstObject.text forKey:@"reportContent"];
            [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
            self.currentTasks =[[BaseSservice sharedManager]post1:@"app/community/articlepage/deleteArticle.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
                [[UserModel shareInstance]showSuccessWithStatus:@"删除成功"];
                [_dataArray removeObject:model];
                [self.tableview reloadData];

            } failure:^(NSError *error) {
                
            }];
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];

    }
    else
    {
        jbv = [[JbView alloc]initWithFrame:CGRectMake(0, 64, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT-110)];
        jbv.articleId = model.uid;
        [self.view addSubview:jbv];
        [self.view bringSubviewToFront:jbv];

    }
    
    
    
}

-(void)enterDetailPageWithIndex:(NSInteger)index
{
    CommunityModel * model = [_dataArray objectAtIndex:index];
    ArticleDetailViewController * ard =[[ArticleDetailViewController alloc]init];
    ard.infoModel = model;
    ard.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ard animated:YES];
    
}



-(void)loadImageSuccessWithCell:(PublicArticleCell *)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
    model.loadSuccess = @"1";
}


#pragma  mark -----share

-(void)shareWithIndex:(NSInteger)index
{
    UIAlertController * al =[UIAlertController alertControllerWithTitle:@"分享" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [al addAction:[UIAlertAction actionWithTitle:@"微信朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatTimeline index:index];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatSession index:index];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"QQ好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformTypeQQ index:index];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    
    [self presentViewController:al animated:YES completion:nil];
    
}

-(void) shareWithType:(SSDKPlatformType)type index:(NSInteger)index
{
    CommunityModel * model = [_dataArray objectAtIndex:index];
    NSString * title  = [NSString stringWithFormat:@"%@发表的文章",model.title];
    NSString * content = model.content;
    if (content.length>100) {
        content = [content substringToIndex:100];
    }
    NSMutableDictionary * params  =[NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:model.uid forKey:@"articleId"];
    self.currentTasks =[[BaseSservice sharedManager]post1:@"app/community/usertArticleDetail/shareArticleLink.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        
        NSString * shareUrl = [[dic safeObjectForKey:@"data"]safeObjectForKey:@"url"];
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        if (type ==SSDKPlatformSubTypeWechatTimeline||type==SSDKPlatformSubTypeWechatSession) {
            [shareParams SSDKSetupWeChatParamsByText:content title:title url:[NSURL URLWithString:shareUrl] thumbImage:[UserModel shareInstance].headUrl image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:type];
            
        }else if (type==SSDKPlatformTypeQQ)
        {
            [shareParams SSDKSetupShareParamsByText:content
                                             images:[UserModel shareInstance].headUrl
                                                url:[NSURL URLWithString:shareUrl]
                                              title:title
                                               type:SSDKContentTypeWebPage];
        }
        
        [shareParams SSDKEnableUseClientShare];
        [SVProgressHUD showWithStatus:@"开始分享"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        
        
        //进行分享
        [ShareSDK share:type
             parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
             
             
             switch (state) {
                 case SSDKResponseStateSuccess:
                 {
                     [[UserModel shareInstance]dismiss];
                     //                 [[UserModel shareInstance] showSuccessWithStatus:@"分享成功"];
                     [[UserModel shareInstance]didCompleteTheTaskWithId:@"5"];
                     break;
                 }
                 case SSDKResponseStateFail:
                 {
                     [[UserModel shareInstance]dismiss];
                     //                 [[UserModel shareInstance] showErrorWithStatus:@"分享失败"];
                     DLog(@"error-%@",error);
                     break;
                 }
                 case SSDKResponseStateCancel:
                 {
                     [[UserModel shareInstance]dismiss];
                     //                 [[UserModel shareInstance] showInfoWithStatus:@"取消分享"];
                     break;
                 }
                 default:
                     break;
             }
         }];
        
        
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)didGzUserWithCell:(NewMineHomePageCell *)cell
{
    if (cell.gzBtn.selected ==YES) {
        [self cancelGzWithId:[_infoDict safeObjectForKey:@"userId"] cell:cell];
    }else{
        NSMutableDictionary * params =[NSMutableDictionary dictionary];
        [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
        [params setObject:[_infoDict safeObjectForKey:@"userId"] forKey:@"followId"];
        self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/userfollow/followUser.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
            DLog(@"dic-关注成功--%@",dic);
            cell.gzBtn.selected = YES;
            cell.gzBtn.layer.borderColor = HEXCOLOR(0xeeeeee).CGColor;

            [[UserModel shareInstance]showSuccessWithStatus:@"关注成功"];
            [self.tableview.mj_header beginRefreshing];
        } failure:^(NSError *error) {
            
        }];
    }
}
-(void)cancelGzWithId:(NSString * )followId cell:(NewMineHomePageCell*)cell
{
    [SVProgressHUD showWithStatus:@"修改中。。。"];
    NSMutableDictionary * params =[NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params setObject:followId forKey:@"followId"];

    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/userfollow/removeUserFollow.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        DLog(@"dic-取消关注成功--%@",dic);
        
            cell.gzBtn.selected = NO;
            cell.gzBtn.layer.borderColor = [UIColor redColor].CGColor;

            [[UserModel shareInstance]showSuccessWithStatus: @"取消成功"];
            [self.tableview.mj_header beginRefreshing];
    } failure:^(NSError *error) {
        
    }];
    });

}


- (void)ChangeHeadImageWithTitle:(NSString *)title{
    
    
    UIAlertController *al = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleActionSheet];
    
    [al addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
        
    }]];
    
    
    [al addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            
        }
        pickerImage.delegate = self;
        pickerImage.allowsEditing = YES;
        [self presentViewController:pickerImage animated:YES completion:nil];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:al animated:YES completion:nil];
    
}
#pragma mark ----imagepickerdelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        UIImage *image =info[UIImagePickerControllerEditedImage];
        [image scaledToSize:CGSizeMake(JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH/image.size.width*image.size.height)];
        
        [self dismissViewControllerAnimated:YES completion:nil];

        if (changeImageNum ==1) {
            NSData *  fileDate = UIImageJPEGRepresentation(image, 0.001);
            [self updateImageWithImage:fileDate];
            
        }else if(changeImageNum ==2){
            NSData *  fileDate = UIImageJPEGRepresentation(image, 0.1);

            [self updateBGImageWithImage:fileDate];
            
        }
        
    }
}//点击cancel 调用的方法

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)updateImageWithImage:(NSData *)fileData
{
    
    
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    [SVProgressHUD showWithStatus:@"上传中.."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    self.currentTasks = [[BaseSservice sharedManager]postImage:@"app/user/uploadHeadImg.do" paramters:param imageData:fileData imageName:@"headimgurl" success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        [[UserModel shareInstance] setHeadImageUrl: [[dic objectForKey:@"data"]objectForKey:@"headimgurl"]];
        [self.tableview reloadData];
        [[UserModel shareInstance] showSuccessWithStatus:@"上传成功"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kRefreshInfo object:nil];
    } failure:^(NSError *error) {
        
        DLog(@"faile-error-%@",error);
    }];
}


#pragma  mark --上传背景图
-(void)updateBGImageWithImage:(NSData *)fileData
{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    [SVProgressHUD showWithStatus:@"上传中.."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    self.currentTasks = [[BaseSservice sharedManager]postImage:@"app/user/uploadBackGroundImg.do" paramters:param imageData:fileData imageName:@"imgurl" success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.tableview.mj_header beginRefreshing];
        });

        [[UserModel shareInstance] showSuccessWithStatus:@"上传成功"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kRefreshInfo object:nil];
    } failure:^(NSError *error) {
        
        DLog(@"faile-error-%@",error);
    }];
}

-(void) shareWithType:(SSDKPlatformType)type
{
    
    
    NSMutableDictionary * params  =[NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks =[[BaseSservice sharedManager]post1:@"app/community/usertArticleDetail/shareHomeLink.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        
        NSString * shareUrl = [[dic safeObjectForKey:@"data"]safeObjectForKey:@"url"];
        
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        if (type ==SSDKPlatformSubTypeWechatTimeline||type==SSDKPlatformSubTypeWechatSession) {
            [shareParams SSDKSetupWeChatParamsByText:ShareContentInfo title:[NSString stringWithFormat:@"%@的个人主页",[UserModel shareInstance].nickName] url:[NSURL URLWithString:shareUrl] thumbImage:[UserModel shareInstance].headUrl image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:type];
            
        }else if (type==SSDKPlatformTypeQQ)
        {
            [shareParams SSDKSetupShareParamsByText:ShareContentInfo
                                             images:[UserModel shareInstance].headUrl
                                                url:[NSURL URLWithString:shareUrl]
                                              title:[UserModel shareInstance].nickName
                                               type:SSDKContentTypeWebPage];
            
        }
        
        
        
        [shareParams SSDKEnableUseClientShare];
        [SVProgressHUD showWithStatus:@"开始分享"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        
        
        //进行分享
        [ShareSDK share:type
             parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
             
             
             switch (state) {
                 case SSDKResponseStateSuccess:
                 {
                  [[UserModel shareInstance]dismiss];
#ifdef DEBUG
                   [[UserModel shareInstance] showSuccessWithStatus:@"分享成功"];
#endif
                 [[UserModel shareInstance]didCompleteTheTaskWithId:@"7"];
                     break;
                 }
                 case SSDKResponseStateFail:
                 {
                     [[UserModel shareInstance]dismiss];
#ifdef DEBUG
                     [[UserModel shareInstance] showErrorWithStatus:@"error"];
#endif
                     DLog(@"error-%@",error);
                     break;
                 }
                 case SSDKResponseStateCancel:
                 {
                     [[UserModel shareInstance]dismiss];
                     //                 [[UserModel shareInstance] showInfoWithStatus:@"取消分享"];
                     break;
                 }
                 default:
                     break;
             }
         }];

        
        
    } failure:^(NSError *error) {
        
    }];
}
///完成获取积分任务--- 分享主页 分享健康报告
-(void)getIntegral
{
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        [params setObject:@"7" forKey:@"taskId"];
        [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
        
        self.currentTasks = [[BaseSservice sharedManager]post1:@"app/integral/growthsystem/gainPoints.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        } failure:^(NSError *error) {
            
        }];
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


-(UIImage *)getImage
{
    
    UIGraphicsBeginImageContext(CGSizeMake(JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT));
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [self.navigationController.view.layer renderInContext:contextRef];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

/*
 * 清理sd_webImage缓存
 **/
-(void)clearSDCeche
{
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self clearSDCeche];
    // Dispose of any resources that can be recreated.
}






@end
