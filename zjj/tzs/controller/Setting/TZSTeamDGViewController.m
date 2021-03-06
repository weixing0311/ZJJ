//
//  TZSTeamDGViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/27.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TZSTeamDGViewController.h"
#import "UpDateOrderCell.h"
#import "OrderFooter.h"
#import "OrderFootBtnView.h"
#import "TZSTeamHeaderView.h"
#import "TZSDingGouViewController.h"
#import "TeamOrderDetailViewController.h"
#import "NSString+dateWithString.h"
@interface TZSTeamDGViewController ()<orderFootBtnViewDelegate,teamOrderDetailDelegate>

@end

@implementation TZSTeamDGViewController
{
    NSMutableArray * _dataArray;
    NSMutableArray * _infoArray;
    int page;
    int pageSize;
    OrderFootBtnView * footBtn;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"团队订购";
    [self setNbColor];
    
    _dataArray = [NSMutableArray array];
    _infoArray = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource= self;
    pageSize =30;
    [self ChangeMySegmentStyle:self.segment];
    [self setExtraCellLineHiddenWithTb:self.tableView];
    [self setRefrshWithTableView:self.tableView];
    [self.tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}

-(void)buildHeadView
{
    [self.tableView.tableHeaderView removeFromSuperview];
    self.tableView.tableHeaderView = nil;

    
    if (self.segment.selectedSegmentIndex ==0||self.segment.selectedSegmentIndex==2) {
        UIView * headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 5)];
        self.tableView.tableHeaderView = headView ;
    }else{
    
    
    UIView * headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 50)];
    headView.backgroundColor =HEXCOLOR(0xfffbf1);
    self.tableView.tableHeaderView=headView;
    
    UIView * line1View =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 1)];
    line1View.backgroundColor =[UIColor orangeColor];
    [headView addSubview:line1View];
    UIView * line2View =[[UIView alloc]initWithFrame:CGRectMake(0, 49, JFA_SCREEN_WIDTH, 1)];
    line2View.backgroundColor =[UIColor orangeColor];
    [headView addSubview:line2View];
    
    
    UILabel * lb =[[UILabel alloc]initWithFrame:CGRectMake(20, 5, JFA_SCREEN_WIDTH-40, 40)];
    
    lb.textColor =[UIColor redColor];
    lb.text = @"如24小时内未能补充订购，订单将自动由上阶成员或平台自动完成补充";
    lb.numberOfLines=2;
    lb.font = [UIFont systemFontOfSize:14];
    [headView addSubview:lb];
    
    }
}



-(void)headerRereshing
{
    [super headerRereshing];
    page =1;
    
    [self getListInfo];
    
}
-(void)footerRereshing
{
    [super footerRereshing];
    page ++;
    [self getListInfo];
    
}

-(void)getListInfo
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param safeSetObject:@(page) forKey:@"page"];
    [param safeSetObject:@(pageSize) forKey:@"pageSize"];
    [param safeSetObject:[NSString stringWithFormat:@"2,3"] forKey:@"stockType"];
    [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"/app/order/info/queryOrderInfoList.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (page==1) {
            [_infoArray removeAllObjects];
            self.tableView.mj_footer.hidden = NO;

        }
 
       [ _infoArray  addObjectsFromArray:[[dic objectForKey:@"data"]objectForKey:@"array"]];
        if (_infoArray.count<30) {
            self.tableView.mj_footer.hidden = YES;
        }
        [self getinfoWithStatus:0];
        [self.tableView reloadData];

        DLog(@"%@",dic);
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr =[[_dataArray objectAtIndex:section]objectForKey:@"itemJson"];
    return arr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSDictionary *dic =[_dataArray objectAtIndex:section];
    int status = [[dic objectForKey:@"stockType"]intValue];
    if (status ==2) {
        return 102;
    }else{
    return 70;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSDictionary *dic =[_dataArray objectAtIndex:section];
    int status = [[dic objectForKey:@"stockType"]intValue];
    if (status ==2) {
        return 92;
    }else
        return 46;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSDictionary *dic = [_dataArray objectAtIndex:section];
    int status = [[dic objectForKey:@"stockType"]intValue];
    float height =0.0f;
    if (status ==2) {
        height =102;
    }else{
        height =70;
    }
    UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, height)];
    view.backgroundColor =HEXCOLOR(0xeeeeee);

    TZSTeamHeaderView *header = [self getXibCellWithTitle:@"TZSTeamHeaderView"];
    header.frame = CGRectMake(0, 1, JFA_SCREEN_WIDTH, height-1);
    header.backgroundColor =[UIColor whiteColor];
    header.orderNum.text = [dic safeObjectForKey:@"orderNo"];
    header.ordername .text = [dic safeObjectForKey:@"nickName"];
    header.mobileLabel.text = [NSString stringWithFormat:@"手机号：%@",[dic safeObjectForKey:@"phone"]?[[UserModel shareInstance]changeTelephone:[dic safeObjectForKey:@"phone"]]:@""];
    if (status ==1) {
        header.typeLabel.text = @"待支付";
        header.lastTimeLabel.hidden =YES;

    }else if (status ==2) {
        header.typeLabel.text = @"待补充";
        header.lastTimeLabel.hidden =NO;
        NSString * finishTime =[dic safeObjectForKey:@"remainingTime"];
        header.lastTimeLabel.text = [NSString stringWithFormat:@"订单补充剩余时间%@",[NSString getNowTimeWithString:finishTime]];
        [header setTimeLabelText:finishTime];

    }
    else{
        header.typeLabel .text = @"已完成";
        header.lastTimeLabel.hidden =YES;

    }
    
 
    
    
    [view addSubview:header];
    
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSDictionary *dic = [_dataArray objectAtIndex:section];
    int status = [[dic objectForKey:@"stockType"]intValue];
    float height = 0.0f;
    if (status==2) {
        height =92;
    }else{
        height =46;
    }
    
    UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, height)];
    view.backgroundColor =HEXCOLOR(0xeeeeee);
    
    OrderFooter *footer = [self getXibCellWithTitle:@"OrderFooter"];
    footer.frame = CGRectMake(0, 0.5, JFA_SCREEN_WIDTH, 40);
    footer.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[[dic objectForKey:@"payableAmount"]floatValue]-[[dic safeObjectForKey:@"freight"]floatValue]];

    footer.countLabel.text = [NSString stringWithFormat:@"共计%@项服务，合计：",[dic objectForKey:@"quantitySum"]];
    [view addSubview:footer];

    if (status ==2) {
        footBtn = [self getXibCellWithTitle:@"OrderFootBtnView"];
        footBtn.frame = CGRectMake(0, 41.5, JFA_SCREEN_WIDTH, 44);
        footBtn.tag = section;
        footBtn.myDelegate = self;
        [footBtn.firstBtn setTitle:@"去订购" forState:UIControlStateNormal];
        footBtn.secondBtn.hidden = YES;
        [view addSubview:footBtn];
        
    }
    

    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"UpDateOrderCell";
    UpDateOrderCell * cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.section];
    NSArray * arr = [dic objectForKey:@"itemJson"];
    NSDictionary * infoDic = [arr objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = [infoDic safeObjectForKey:@"productName"];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[infoDic safeObjectForKey:@"picture"]] placeholderImage:[UIImage imageNamed:@"find_default"]];
    
    
//    int stockType = [[dic safeObjectForKey:@"stockType"]intValue];
//    if (stockType ==3) {
//        cell.price2label.text = [NSString stringWithFormat:@"成本单价:￥%.2f",[[infoDic safeObjectForKey:@"costPrice"] floatValue]];
//
//    }else{
//        cell.price2label.text = @"";
//    }
    
    cell.priceLabel.text = [NSString stringWithFormat:@"销售单价:￥%.2f",[[infoDic safeObjectForKey:@"normalPrice"] floatValue]];
    cell.countLabel.text = [NSString stringWithFormat:@"x%@",[infoDic safeObjectForKey:@"quantity"]];
    
    
    NSString * isgift = [NSString stringWithFormat:@"%@",[infoDic safeObjectForKey:@"isGift"]];
    
    if ([isgift isEqualToString:@"1"]) {
        cell.zengimageView.hidden =NO;
    }else{
        cell.zengimageView.hidden =YES;
    }

    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic =[_dataArray objectAtIndex:indexPath.section];
    
    TeamOrderDetailViewController * tmo = [[TeamOrderDetailViewController alloc]init];
    tmo.orderNo =[dic objectForKey:@"orderNo"];
    tmo.delegate = self;
    [self.navigationController pushViewController:tmo animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getinfoWithStatus:(NSInteger)segmentIndex
{
    int type = 0;
    if (segmentIndex ==0) {
        type =100;
    }else if(segmentIndex ==1){
        type =2;
    }else if(segmentIndex ==2){
        type =3;
    }
//    [self buildHeadView];
    [_dataArray removeAllObjects];
    
    if (type==100) {
        [_dataArray  addObjectsFromArray:_infoArray];
        return;
    }
    
    for (int i =0; i<_infoArray.count; i++) {
        NSDictionary * dic =[_infoArray objectAtIndex:i];
        int allType = [[dic objectForKey:@"stockType"]intValue];
        if (allType ==type) {
            [_dataArray addObject:dic];
        }
    }
    
}

- (IBAction)ChangeType:(UISegmentedControl*)sender {
    
    [self getinfoWithStatus:sender.selectedSegmentIndex];
    [self.tableView reloadData];

}

-(void)didClickFirstBtnWithView:(OrderFootBtnView*)view
{
    TZSDingGouViewController *dg =[[TZSDingGouViewController alloc]init];
    [self.navigationController pushViewController:dg animated:YES];
}

-(void)teamOrderChange
{
    [self.tableView.mj_header beginRefreshing];
}
@end
