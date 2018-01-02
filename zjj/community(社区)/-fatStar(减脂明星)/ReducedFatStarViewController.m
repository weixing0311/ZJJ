//
//  ReducedFatStarViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/12/7.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ReducedFatStarViewController.h"
#import "ReducedFatCell.h"
#import "ReducedFatModel.h"
#import "NewMineHomePageViewController.h"
@interface ReducedFatStarViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation ReducedFatStarViewController
{
    int page;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"减脂明星";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTBWhiteColor];
    [self buildTableView];
    
    // Do any additional setup after loading the view.
}
-(void)buildTableView
{
    self.tableview =[[UITableView alloc]initWithFrame:CGRectMake(0, 70, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT-70) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource= self;
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableview];
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self setRefrshWithTableView:self.tableview];
}
-(void)headerRereshing
{
    page =1;
    [self getListInfo];
}
-(void)footerRereshing
{
    page++;
    [self getListInfo];
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(void)getListInfo
{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:@"10" forKey:@"pageSize"];
    
//    [SVProgressHUD showWithStatus:@"加载中..."];
    self.currentTasks =[[BaseSservice sharedManager]post1:@"app/user/star/queryUserStarList.do" HiddenProgress:YES paramters:params success:^(NSDictionary *dic) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        [self hiddenEmptyView];
//        [SVProgressHUD dismiss];
        
        if (page ==1) {
            [self.dataArray removeAllObjects];
            [self.tableview.mj_footer setHidden:NO];
        }
        NSArray * infoArr = [[dic safeObjectForKey:@"data"]objectForKey:@"array"];
        
        for (int i =0; i<infoArr.count; i++) {
            ReducedFatModel * model = [[ReducedFatModel alloc]init];
            [model setInfoWithDict:infoArr[i]];
            [self.dataArray addObject:model];
        }
        
        if (infoArr.count<10) {
            [self.tableview.mj_footer setHidden: YES];
        }
        [self.tableview reloadData];
    } failure:^(NSError *error) {
//        [SVProgressHUD dismiss];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];

        if ([error code]==402) {
            if (page==1) {
                [self.dataArray removeAllObjects];
                [self.tableview reloadData];
                [self showEmptyViewWithTitle:@"暂无数据。"];
            }else{
                page--;
            }
        }else{
            [self showEmptyViewWithTitle:@"加载失败，请检查网络后点击重新加载。"];

        }
    }];

}
-(void)refreshEmptyView
{
    [super refreshEmptyView];
    [self hiddenEmptyView];
    page=1;
    [self.tableview.mj_header beginRefreshing];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = @"ReducedFatCell";
    Class mClass =  NSClassFromString(identifier);
    return  [self.tableview cellHeightForIndexPath:indexPath model:self.dataArray[indexPath.row] keyPath:@"model" cellClass:mClass contentViewWidth:[UIScreen mainScreen].bounds.size.width];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ReducedFatModel * model = _dataArray[indexPath.row];
    
    NSString * identifier = @"ReducedFatCell";
    Class mClass =  NSClassFromString(identifier);
    
    ReducedFatCell * cell =  [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[mClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.model = model;
    cell.tag = indexPath.row;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
    ReducedFatModel * model = [_dataArray objectAtIndex:indexPath.row];
    NewMineHomePageViewController * mineVC =[[NewMineHomePageViewController alloc]init];
    mineVC.userId = model.userId;
    [self.navigationController pushViewController:mineVC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
