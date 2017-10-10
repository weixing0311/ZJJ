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
#import "PostArticleViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CLPlayerView.h"
#import "UIView+CLSetRect.h"
#import "Masonry.h"
#import "EditUserInfoImageCell.h"
#import "ArticleDetailViewController.h"
#import "EditUserInfoViewController.h"
#import "BeforeAfterContrastCell.h"
@interface NewMineHomePageViewController ()<UITableViewDataSource,UITableViewDelegate,PublicArticleCellDelegate,NewMineHomePageHeaderCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic, weak) CLPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (nonatomic,strong)NSMutableDictionary * infoDict;
@end

@implementation NewMineHomePageViewController
{
    int page;
    int pageSize;
    PublicArticleCell * PlayingCell;

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![self.userId isEqualToString:[UserModel shareInstance].userId]) {
        self.shareBtn.hidden = YES;
    }else{
        self.shareBtn.hidden = NO;
    }
    self.tableview.delegate=self;
    self.tableview.dataSource= self;
    pageSize = 30;
    self.dataArray = [NSMutableArray array];
    self.infoDict = [NSMutableDictionary dictionary];
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self setRefrshWithTableView:self.tableview];
    [self.tableview headerBeginRefreshing];
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
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/usertArticleDetail/queryUserHome.do" paramters:params success:^(NSDictionary *dic) {
        [self.tableview footerEndRefreshing];
        [self.tableview headerEndRefreshing];
        
        if (page ==1) {
            [self.dataArray removeAllObjects];
            [self.tableview setFooterHidden:NO];
            
        }
        
        
        NSDictionary * dataDic  = [dic safeObjectForKey:@"data"];
        self.infoDict = [dataDic safeObjectForKey:@"article"];
        
        NSArray * infoArr = [dataDic safeObjectForKey:@"array"];
        if (infoArr.count<30) {
            [self.tableview setFooterHidden:YES];
        }
        for (NSMutableDictionary * infoDic in infoArr) {
            CommunityModel * item = [[CommunityModel alloc]init];
            [item setInfoWithDict:infoDic];
            [self.dataArray addObject:item];
        }
        [self.tableview reloadData];

        
        DLog(@"%@",dic);
    } failure:^(NSError *error) {
        [self.tableview footerEndRefreshing];
        [self.tableview headerEndRefreshing];
    }];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * fatBefore =[_infoDict safeObjectForKey:@"fatBefore"];

    if (indexPath.section ==0) {
        return JFA_SCREEN_WIDTH/320*199;
    }
    else if(indexPath.section ==1)
    {
        return 130;
    }
    else if(indexPath.section==2)
    {
        if (fatBefore.length>0)
        {
            return 250;
        }else{
            return 0;
        }
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
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString * fatBefore =[_infoDict safeObjectForKey:@"fatBefore"];
    
    if (section ==0) {
        return 1;
    }
    else if(section ==1)
    {
        return 1;
    }
    else if(section==2)
    {
        if (fatBefore.length>0)
        {
            return 1;
        }else{
            return 0;
        }
    }
    else
    {
        return self.dataArray.count;

    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0||section ==1) {
        return 1;
    }
    return 25;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
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
        [cell.headImageView sd_setBackgroundImageWithURL:[NSURL URLWithString:[_infoDict safeObjectForKey:@"headimgurl"]] forState:UIControlStateNormal placeholderImage:getImage(@"defaultHead")
         ];
        cell.nicknamelb.text = [_infoDict safeObjectForKey:@"nickName"];
        NSString * introduction = [_infoDict safeObjectForKey:@"introduction"];
        if (introduction.length<1) {
            cell.jjlb.text = @"还没有编辑简介~";
        }else{
            cell.jjlb.text = [NSString stringWithFormat:@"简介：%@",introduction];
        }
        int  sex = [UserModel shareInstance].gender;
        if (sex ==1) {
            cell.sexImageView.image = getImage(@"man");
            
        }else{
            cell.sexImageView.image =getImage(@"woman_");
        }
        
        if ([self.userId isEqualToString:[UserModel shareInstance].userId]) {
            cell.gzBtn.hidden = YES;
        }else{
            cell.gzBtn.hidden = NO;
        }
        
        return cell;
    }
    
    else if(indexPath.section ==1)
    {
        static NSString * identifier = @"BeforeAfterContrastCell";
        BeforeAfterContrastCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.beforeWeightlb.text = [NSString stringWithFormat:@"%.0fkg",[[_infoDict safeObjectForKey:@"beforeWeight"] floatValue]];
        cell.afterweightlb.text = [NSString stringWithFormat:@"%.0fkg",[[_infoDict safeObjectForKey:@"afterWeight"] floatValue]];
        cell.continuousDatelb.text = [NSString stringWithFormat:@"%@",[_infoDict safeObjectForKey:@"registerDate"]?[_infoDict safeObjectForKey:@"registerDate"]:@"0"];
        cell.lossWeightlb.text = [NSString stringWithFormat:@"%.0f",[[_infoDict safeObjectForKey:@"beforeWeight"]floatValue]-[[_infoDict safeObjectForKey:@"afterWeight"]floatValue]];

        return cell;
    }
    else if(indexPath.section ==2)
    {
        static NSString * identifier = @"EditUserInfoImageCell";
        EditUserInfoImageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        
        [cell.fatBeforeBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[_infoDict safeObjectForKey:@"fatBefore"]] placeholderImage:getImage(@"before")];
        [cell.fatAfterBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[_infoDict safeObjectForKey:@"fatAfter"]] placeholderImage:getImage(@"last")];
        
        return cell;
        
    }
    else
    {
        CommunityModel * item =[self.dataArray objectAtIndex:indexPath.row];
        static  NSString * identifier = @"PublicArticleCell";
        PublicArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        
        if ([self.userId isEqualToString:[UserModel shareInstance].userId]) {
            cell.gzBtn.hidden = YES;
            cell.jbBtn.hidden = YES;
        }else{
            cell.gzBtn.hidden = NO;
            cell.jbBtn.hidden = NO;
        }
        
        cell.delegate = self;
        cell.tag = indexPath.row;
        [cell setInfoWithDict:item];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
}
//cell离开tableView时调用
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //因为复用，同一个cell可能会走多次
    if (indexPath.section ==1) {
        if ([PlayingCell isEqual:cell]) {
            //区分是否是播放器所在cell,销毁时将指针置空
            [_playerView destroyPlayer];
            PlayingCell = nil;
        }

    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return @"";
    }
    else if (section==1)
    {
        return @"";
    }else if(section ==2){
        return @"减脂前后";
    }else{
        return @"最新动态";

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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==3){
    CommunityModel * model = [_dataArray objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ArticleDetailViewController * ard =[[ArticleDetailViewController alloc]init];
    ard.infoModel = model;
    [self.navigationController pushViewController:ard animated:YES];
    }
}



#pragma mark ---cell delegate

-(void)didPlayWithCell:(PublicArticleCell *)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
    //记录被点击的Cell
    PlayingCell = cell;
    //销毁播放器
    [_playerView destroyPlayer];
    CLPlayerView *playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, 0, (JFA_SCREEN_WIDTH-20), (JFA_SCREEN_WIDTH-20)*0.7)];
    _playerView = playerView;
    [cell.collectionView addSubview:_playerView];
    //    _playerView.fillMode = ResizeAspectFill;
    
    //视频地址
    _playerView.url = [NSURL URLWithString:model.movieStr];
    //播放
    [_playerView playVideo];
    //返回按钮点击事件回调
    [_playerView backButton:^(UIButton *button) {
        NSLog(@"返回按钮被点击");
    }];
    //播放完成回调
    [_playerView endPlay:^{
        //销毁播放器
        [_playerView destroyPlayer];
//        PlayingCell.playerBtn.hidden = NO;
        _playerView = nil;
        PlayingCell = nil;
        
        NSLog(@"播放完成");
    }];
    
}

- (IBAction)didClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)didClickShare:(id)sender {
}

#pragma  mark ---cell delegate
-(void)didShowChangeUserInfoPage
{
    
    if ([self.userId isEqualToString:[UserModel shareInstance].userId]) {
        EditUserInfoViewController * edit =[[EditUserInfoViewController alloc]init];
        edit.infoDict = self.infoDict;
        [self.navigationController pushViewController:edit animated:YES];
    }
}
-(void)didChangeHeaderImage
{
    if ([self.userId isEqualToString:[UserModel shareInstance].userId]) {

    }
}
-(void)didShareMyInfo
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
