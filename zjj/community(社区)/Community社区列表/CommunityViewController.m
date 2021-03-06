//
//  CommunityViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "CommunityViewController.h"
#import "PublicArticleCell.h"
#import "CommunityModel.h"
#import "WriteArtcleViewController.h"
#import <MediaPlayer/MediaPlayer.h>

#import "ArticleDetailViewController.h"
#import "CommunityCell.h"
#import "FcBigImgViewController.h"
#import "NewMineHomePageViewController.h"
#import "WriteArtcleViewController.h"
#import "CommunityCell.h"
#import "NewMineHomePageCell.h"
#import "BeforeAfterContrastCell.h"
#import "EditUserInfoImageCell.h"
#import "EditUserInfoViewController.h"
#import "ReducedFatStarViewController.h"
#import "NewMineModel.h"
#import "NewMineFatLineCell.h"
#import "NewMineFatInterCell.h"
#import "ReducedFatWebViewController.h"
#import "ADCarouselView.h"
#import "BannerItem.h"


#import "JbView.h"

#import "Yd7View.h"
#import "Yd8View.h"
#import "Yd9View.h"


@interface CommunityViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,PublicArticleCellDelegate,BigImageArticleCellDelegate,ArticleDetailDelegate,NewMineHomePageHeaderCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ADCarouselViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableDictionary * infoDict;
@property (nonatomic,strong)NSMutableArray * reducedFatLineArray;
@property (nonatomic,strong)NSMutableArray * reducedFatQuestionArray;

/**CLplayer*/
@property (nonatomic, weak) CLPlayerView *playerView;

@end

@implementation CommunityViewController
{
    int page;
    int pageSize;
    CommunityCell * PlayingCell;
    int changeImageNum;
    JbView * jbv;
#pragma mark ---guide
    Yd7View * yd7 ;
    Yd8View * yd8 ;
    Yd9View * yd9 ;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    if (self.isMyMessagePage==YES) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
        self.title = @"我的消息";
        [self setTBWhiteColor];
        self.tabBarController.tabBar.hidden = YES;

    }else{
        [self.navigationController setNavigationBarHidden:YES animated:animated];
        self.tabBarController.tabBar.hidden = NO;

    }

    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (jbv) {
        jbv.hidden = YES;
        [jbv removeFromSuperview];
    }
    [_playerView destroyPlayer];
    _playerView = nil;
    PlayingCell = nil;
    [self clearSDCeche];



}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTableView) name:@"SENDARTICLESUCCESS" object:nil];
    [self setSegmentStyle];
    
    self.infoDict = [NSMutableDictionary dictionary];
    self.reducedFatQuestionArray = [NSMutableArray array];
    self.reducedFatLineArray = [NSMutableArray array];

    if (_isMyMessagePage !=YES) {
        
    }
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self setRefrshWithTableView:self.tableview];
    pageSize= 30;
    self.segment.selectedSegmentIndex = 1;
    [self.tableview.mj_header beginRefreshing];
    
    [self buildGuidePage];
}

-(void)setSegmentStyle
{
    [self.segment setTintColor:[UIColor whiteColor]];
    [self.segment setBackgroundImage:[UIImage imageNamed:@"selectImg"]
                       forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    UIFont *font = [UIFont boldSystemFontOfSize:17.0f];   // 设置字体大小

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:19.0f],NSFontAttributeName,nil];
    
    
    NSDictionary *dics = [NSDictionary dictionaryWithObjectsAndKeys:HEXCOLOR(0x666666),NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:15.0f],NSFontAttributeName,nil];
    
    [self.segment setTitleTextAttributes:dics forState:UIControlStateNormal];
    [self.segment setTitleTextAttributes:dic forState:UIControlStateSelected];

}
-(void)buildHeadViewWithIndex:(NSInteger)index
{
    if (index==1&&self.isMyMessagePage !=YES) {
        UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH*0.4+100)];
        self.tableview.tableHeaderView = headView;
        
    
        headView.backgroundColor =[UIColor whiteColor];

        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH*0.4)];
        imageView.image = getImage(@"reducedFatBanner_1_");
        [headView addSubview:imageView];
        
        
//        ADCarouselView *carouselView = [ADCarouselView carouselViewWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH/3)];
//        carouselView.loop = YES;
//        carouselView.delegate = self;
//        carouselView.automaticallyScrollDuration = 5;
//
//        carouselView.imgs = @[@"reducedFatBanner_1_"];
//        carouselView.placeholderImage = [UIImage imageNamed:@"zhanweifu"];
//        [headView addSubview:carouselView];

        
        
        UIButton * leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(JFA_SCREEN_WIDTH/4-25, JFA_SCREEN_WIDTH*0.4+20, 50, 50)];
        [leftBtn setBackgroundImage:getImage(@"fatStar_left_") forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(showReducedFatStarVc) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:leftBtn];
        
        UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(JFA_SCREEN_WIDTH/4*3-25, JFA_SCREEN_WIDTH*0.4+20, 50, 50)];
        [rightBtn setBackgroundImage:getImage(@"fatStar_right_") forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(showReducedFatInfo) forControlEvents:UIControlEventTouchUpInside];

        [headView addSubview:rightBtn];

        
        UILabel * leftLb = [[UILabel alloc]initWithFrame:CGRectMake(JFA_SCREEN_WIDTH/4-25, JFA_SCREEN_WIDTH*0.4+72, 50, 15)];
        leftLb.text =  @"减脂明星";
        leftLb.textColor = HEXCOLOR(0x666666);
        leftLb.font  =[UIFont systemFontOfSize:13];
        leftLb.textAlignment = NSTextAlignmentCenter;
        leftLb.adjustsFontSizeToFitWidth = YES;
        [headView addSubview:leftLb];
        
        UILabel * rightLb = [[UILabel alloc]initWithFrame:CGRectMake(JFA_SCREEN_WIDTH/4*3-25, JFA_SCREEN_WIDTH*0.4+72, 50, 15)];
        rightLb.text =  @"健康知识";
        rightLb.textColor = HEXCOLOR(0x666666);
        rightLb.font  =[UIFont systemFontOfSize:13];
        rightLb.textAlignment = NSTextAlignmentCenter;
        rightLb.adjustsFontSizeToFitWidth = YES;
        [headView addSubview:rightLb];
    }else{
        UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.5, 0.5)];
        self.tableview.tableHeaderView = view;
    }
}



-(void)refreshTableView
{
    [self.tableview.mj_header beginRefreshing];
}
-(void)buildRightNaviBarItem
{
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"settings_"] style:UIBarButtonItemStylePlain target:self action:@selector(didEnterWritePage)];
    
    self.navigationItem.rightBarButtonItem = rightItem;

}


- (IBAction)enterWirte:(id)sender {
    [self didEnterWritePage];
}
-(void)didEnterWritePage
{
    WriteArtcleViewController * pr = [[WriteArtcleViewController alloc]init];
    pr.hidesBottomBarWhenPushed = YES;
    pr.shareType = @"6";
    [self.navigationController pushViewController:pr animated:YES];
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
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (IBAction)didEdit:(id)sender {
}
#pragma mark ---newwork requeset  网络请求
-(void)getinfo
{
    NSString * urlStr = @"";
    if (self.isMyMessagePage ==YES) {
        urlStr = @"app/community/articlepage/queryMyMsg.do";
    }else{
        if (self.segment.selectedSegmentIndex ==2) {
            urlStr =@"app/community/articlepage/queryAllArticleByUserId.do";
        }else if(self.segment.selectedSegmentIndex ==1){
            urlStr =@"app/community/articlepage/queryAllArticle.do";
        }
        else
        {
            urlStr = @"app/community/usertArticleDetail/queryUserHome.do";
        }
    }
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:@(pageSize) forKey:@"pageSize"];
    [params safeSetObject:@(page) forKey:@"page"];
    self.currentTasks = [[BaseSservice sharedManager]post1:urlStr HiddenProgress:NO paramters:params  success:^(NSDictionary *dic) {
        [self.tableview.mj_footer endRefreshing];
        [self.tableview.mj_header endRefreshing];
        
        if (page ==1) {
            [self.dataArray removeAllObjects];
            self.tableview.mj_footer.hidden = NO;
        }
        NSDictionary * dataDic  = [dic safeObjectForKey:@"data"];
        if (self.segment.selectedSegmentIndex ==0) {
            self.infoDict = [dataDic safeObjectForKey:@"article"];
        }else{
            self.infoDict = nil;
        }
        NSMutableArray * infoArr = [dataDic safeObjectForKey:@"array"];
        if (infoArr.count<30) {
            self.tableview.mj_footer.hidden=YES;
        }
        
        [self buildHeadViewWithIndex:self.segment.selectedSegmentIndex];
        
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
            [self.dataArray addObject:item];
        }
        [self.tableview reloadData];
        
        DLog(@"%@",dic);
    } failure:^(NSError *error) {
        [self.tableview.mj_footer endRefreshing];
        [self.tableview.mj_header endRefreshing];
        if (page ==1) {
            [_dataArray removeAllObjects];
            [self.tableview reloadData];
        }
        [self buildHeadViewWithIndex:self.segment.selectedSegmentIndex];
    }];
}

//关注接口


#pragma mark ---tableview delegate dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.segment.selectedSegmentIndex==0) {
        return 6;
    }else{
    return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.segment.selectedSegmentIndex==0) {
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
    else
    {
    return _dataArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.segment.selectedSegmentIndex ==0) {
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

    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_segment.selectedSegmentIndex==0) {
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
                return 0.01;
                break;
                
            default:
                return 0.01;
                break;
        }
        return 0.01;
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.segment.selectedSegmentIndex ==0) {
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
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_segment.selectedSegmentIndex==0) {
        UIView * view =[[UIView alloc]init];
        view.backgroundColor =HEXCOLOR(0xeeeeee);
        return view;
    }else{
        return nil;
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.segment.selectedSegmentIndex==0) {
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
    else
    {
    
        CommunityModel * item =self.dataArray.count>0?[self.dataArray objectAtIndex:indexPath.row]:nil;
        if (!item) {
            return 0;
        }
    float rowheight = item.rowHieght;
    return rowheight;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segment.selectedSegmentIndex ==0)
    {
        if (indexPath.section ==0) {
            static NSString * identifier = @"NewMineHomePageCell";
            NewMineHomePageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [self getXibCellWithTitle:identifier];
            }
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setUpCellWithDict:_infoDict userId:[UserModel shareInstance].userId];
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
    else{
        
        CommunityModel * item =self.dataArray.count<1?nil:[self.dataArray objectAtIndex:indexPath.row];
    
    if (item.pictures.count==1||item.movieStr.length>5) {
        static  NSString * identifier = @"CommunityCell";
        CommunityCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.delegate = self;
        cell.tag = indexPath.row;
        [cell setInfoWithDict:item];
        
        if (self.isMyMessagePage==YES||[item.userId isEqualToString:[UserModel shareInstance].userId]) {
            cell.gzBtn.hidden = YES;
        }else{
            cell.gzBtn.hidden = NO;
        }
        if (self.segment.selectedSegmentIndex ==2) {
            cell.gzBtn.selected = YES;
            cell.gzBtn.layer.borderColor = HEXCOLOR(0x666666).CGColor;

        }
        
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
        
        if (self.isMyMessagePage==YES||[item.userId isEqualToString:[UserModel shareInstance].userId]) {
            cell.gzBtn.hidden = YES;
        }else{
            cell.gzBtn.hidden = NO;
        }
        if (self.segment.selectedSegmentIndex ==2) {
            cell.gzBtn.selected = YES;
            cell.gzBtn.layer.borderColor = HEXCOLOR(0x666666).CGColor;
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    }
}
//cell离开tableView时调用
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //因为复用，同一个cell可能会走多次
    if ([PlayingCell isEqual:cell]) {
        //区分是否是播放器所在cell,销毁时将指针置空
        [_playerView destroyPlayer];
        PlayingCell = nil;
    }
}



#pragma mark - 滑动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // visibleCells 获取界面上能显示出来了cell
    NSArray<PublicArticleCell *> *array = [self.tableview visibleCells];
    //enumerateObjectsUsingBlock 类似于for，但是比for更快
    [array enumerateObjectsUsingBlock:^(PublicArticleCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [obj cellOffset];
    }];
}
//#pragma mark - 布局
//-(void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.navigationController.navigationBar.mas_bottom);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
//        make.width.equalTo(self.view);
//    }];
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.segment.selectedSegmentIndex ==0) {
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
    else
    {
        [self enterDetailPageWithIndex:indexPath.row];
    }
}



#pragma mark ---cell delegate
-(void)didPlayVideoWithCell:(NewMineHomePageCell*)cell
{
    //销毁播放器
    [_playerView destroyPlayer];
    CLPlayerView *playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, 0, (JFA_SCREEN_WIDTH), JFA_SCREEN_WIDTH*0.6)];
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

-(void)didGzWithCell:(PublicArticleCell*)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
    
    if (cell.gzBtn.selected==YES) {
        [SVProgressHUD showWithStatus:@"修改中..."];
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
            
            //遍历数据，清除已经取消关注的model
            [_dataArray enumerateObjectsUsingBlock:^(id key, NSUInteger value, BOOL *stop) {
                CommunityModel * keyModel = key;
                if ([keyModel.userId isEqualToString:model.userId]) {
                    *stop =YES;
                    if (*stop ==YES) {
                        if (self.segment.selectedSegmentIndex==2) {
                            [_dataArray removeObject:keyModel];
                        }else{
                            keyModel.isFollow=@"0";
                        }
                    }
                }
            }];
            [[UserModel shareInstance]showSuccessWithStatus: @"取消关注成功"];
            [self.tableview reloadData];
        } failure:^(NSError *error) {
        }];
    }else{
        [SVProgressHUD showWithStatus:@"修改中"];
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
            
            if (_dataArray.count>100) {
                return ;
            }
            for (CommunityModel * allmodel  in _dataArray) {
                if ([allmodel.userId isEqualToString:model.userId]) {
                    allmodel.isFollow = @"1";
                }
            }
            [self.tableview reloadData];
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
            
            //遍历数据，清除已经取消关注的model
            [_dataArray enumerateObjectsUsingBlock:^(id key, NSUInteger value, BOOL *stop) {
                CommunityModel * keyModel = key;
                if ([keyModel.userId isEqualToString:model.userId]) {
                    *stop =YES;
                    if (*stop ==YES) {
                        if (self.segment.selectedSegmentIndex==2) {
                            [_dataArray removeObject:keyModel];
                        }else{
                            keyModel.isFollow=@"0";
                        }
                    }
                }
            }];
            
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
            
            if (_dataArray.count>100) {
                return ;
            }
            for (CommunityModel * allmodel  in _dataArray) {
                if ([allmodel.userId isEqualToString:model.userId]) {
                    allmodel.isFollow = @"1";
                }
            }
            [self.tableview reloadData];
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

//        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:@"希望您能正确对待社群内容，不要随意举报他人，请确认该用户发表不良信息再进行举报。" preferredStyle:UIAlertControllerStyleAlert];
//        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//
//        }];
//        [alert addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//        [alert addAction: [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSString *strUrl = [alert.textFields.firstObject.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//
//            if (strUrl.length<5) {
//                [[UserModel shareInstance]showInfoWithStatus:@"举报内容不能小于5个字。"];
//                return ;
//            }
//            if (strUrl.length>64) {
//                [[UserModel shareInstance]showInfoWithStatus:@"举报内容不能大于64个字。"];
//                return ;
//            }
//
//            NSMutableDictionary * params = [NSMutableDictionary dictionary];
//            [params safeSetObject:model.uid forKey:@"articleId"];
//            [params safeSetObject:alert.textFields.firstObject.text forKey:@"reportContent"];
//            [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
//            self.currentTasks =[[BaseSservice sharedManager]post1:@"app/reportArticle/updateIsreported.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
//                [[UserModel shareInstance]showSuccessWithStatus:@"您已成功举报"];
//            } failure:^(NSError *error) {
//
//            }];
//        }]];
//        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)enterDetailPageWithIndex:(NSInteger)index
{
    CommunityModel * model = [_dataArray objectAtIndex:index];
    ArticleDetailViewController * ard =[[ArticleDetailViewController alloc]init];
    ard.infoModel = model;
    ard.delegate = self;
    ard.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ard animated:YES];

}



-(void)loadImageSuccessWithCell:(PublicArticleCell *)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
    model.loadSuccess = @"1";
}
-(void)didShowChangeUserInfoPage
{
    EditUserInfoViewController * edit =[[EditUserInfoViewController alloc]init];
    edit.infoDict = self.infoDict;
    [edit.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"userId"] forKey:@"userId"];
    [edit.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"nickName"] forKey:@"nickName"];
    [edit.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"sex"] forKey:@"sex"];
    [edit.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"heigth"] forKey:@"heigth"];
    [edit.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"birthday"] forKey:@"birthday"];
    edit.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:edit animated:YES];

}
-(void)didChangeHeaderImage
{
    [self didShowChangeUserInfoPage];
}
-(void)changeBgImageView
{
    changeImageNum =2;
    [self ChangeHeadImageWithTitle:@"更换背景"];
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
        [self.tableview.mj_header beginRefreshing];
        [[UserModel shareInstance] showSuccessWithStatus:@"上传成功"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kRefreshInfo object:nil];
    } failure:^(NSError *error) {
        
        DLog(@"faile-error-%@",error);
    }];
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
                     [[UserModel shareInstance]didCompleteTheTaskWithId:@"5"];
                     
                     break;
                 }
                 case SSDKResponseStateFail:
                 {
                     [[UserModel shareInstance]dismiss];
#ifdef DEBUG
                     [[UserModel shareInstance] showErrorWithStatus:@"分享失败"];
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

-(void)clearSDCeche
{
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    
}



- (IBAction)didClickSegment:(UISegmentedControl *)sender {
    
//    jbv.hidden = YES;
//    [jbv removeFromSuperview];
    [self.tableview.mj_header beginRefreshing];
}


#pragma mark---nextVCdelegate
-(void)refreshCommentWithModel:(CommunityModel *)model
{
    for (CommunityModel * model1 in _dataArray) {
        if ([model1.uid isEqualToString:model.uid]) {
            model1.commentnum = [NSString stringWithFormat:@"%d",[model1.commentnum intValue]+1];
        }
    }
    [self.tableview reloadData];
}
-(void)refreshGzStatusWithModel:(CommunityModel *)model isFollow:(NSString*)isFollow
{
    for (CommunityModel * model1 in _dataArray) {
        if ([model1.uid isEqualToString:model.uid]) {
            model1.isFollow =isFollow ;
        }
    }
    [self.tableview reloadData];

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

-(void)showReducedFatStarVc
{
    ReducedFatStarViewController * reduceFat =[[ReducedFatStarViewController alloc]init];
    reduceFat.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:reduceFat animated:YES];
}
-(void)showReducedFatInfo
{
    ReducedFatWebViewController * school = [[ReducedFatWebViewController alloc]init];
    school.urlStr = [NSString stringWithFormat:@"%@%@",kMyBaseUrl,@"app/fatTeacher/health.html"];
    school.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:school animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
//    [self clearSDCeche];
    DLog(@"内存溢出");
    // Dispose of any resources that can be recreated.
    if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
    {
        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
    
}





#pragma mark ---引导页
-(void)buildGuidePage
{
    if (self.isMyMessagePage==YES) {
        return;
    }
        if ([[NSUserDefaults standardUserDefaults]objectForKey:kShowGuidePage3]) {
            return;
        }
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:kShowGuidePage3];
    yd7 = [self getXibCellWithTitle:@"Yd7View"];
    yd8 = [self getXibCellWithTitle:@"Yd8View"];
    yd9 = [self getXibCellWithTitle:@"Yd9View"];
    
    yd7.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT);
    yd8.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT);
    yd9.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT);
    
    yd7.tag = 1;
    yd8.tag = 2;
    yd9.tag = 3;
    
    
    yd7.hidden = NO;
    yd8.hidden = YES;
    yd9.hidden = YES;
    
    UIApplication *ap = [UIApplication sharedApplication];
    
    [ap.keyWindow addSubview:yd7];
    [ap.keyWindow addSubview:yd8];
    [ap.keyWindow addSubview:yd9];
    
    [yd7.nextBtn addTarget:self action:@selector(showNextView:) forControlEvents:UIControlEventTouchUpInside];
    [yd8.nextBtn addTarget:self action:@selector(showNextView:) forControlEvents:UIControlEventTouchUpInside];
    [yd9.nextBtn addTarget:self action:@selector(showNextView:) forControlEvents:UIControlEventTouchUpInside];
    
    [yd7.jumpBtn addTarget:self action:@selector(guideOver:) forControlEvents:UIControlEventTouchUpInside];
    [yd8.jumpBtn addTarget:self action:@selector(guideOver:) forControlEvents:UIControlEventTouchUpInside];
    [yd9.jumpBtn addTarget:self action:@selector(guideOver:) forControlEvents:UIControlEventTouchUpInside];

    [yd7 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showNextsView:)]];
    [yd8 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showNextsView:)]];

}

-(void)showNextsView:(UIGestureRecognizer *)gest
{
    if ([gest.view isEqual:yd7]) {
        
        yd7.hidden = YES;
        yd8.hidden =NO;
    }
    else if([gest.view isEqual:yd8])
    {
        yd8.hidden = YES;
        yd9.hidden =NO;
    }
}



-(void)showNextView:(UIButton *)sender
{
    if (sender==yd7.nextBtn) {
        yd7.hidden = YES;
        yd8.hidden =NO;
    }
    else if(sender ==yd8.nextBtn)
    {
        yd8.hidden = YES;
        yd9.hidden =NO;
    }
    else if(sender ==yd9.nextBtn)
    {
        yd9.hidden = YES;
        [yd7 removeFromSuperview];
        [yd8 removeFromSuperview];
        [yd9 removeFromSuperview];
        
    }
}
-(void)guideOver:(UIButton *)sender
{
    yd7.hidden = YES;
    yd8.hidden = YES;
    yd9.hidden = YES;
    [yd7 removeFromSuperview];
    [yd8 removeFromSuperview];
    [yd9 removeFromSuperview];

}


@end
