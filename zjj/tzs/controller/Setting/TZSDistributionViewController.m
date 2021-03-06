//
//  TZSDistributionViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/23.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TZSDistributionViewController.h"
#import "UpDateOrderCell.h"
#import "TZSOrderHeader.h"
#import "OrderFooter.h"
#import "OrderFootBtnView.h"
#import "BaseWebViewController.h"
#import "TZSDistributionDetailViewController.h"

@interface TZSDistributionViewController ()<orderFootBtnViewDelegate,distributionDetailDelegate>

@end

@implementation TZSDistributionViewController
{
    NSMutableArray * _dataArray;
    NSMutableArray * _infoArray;
    int page;
    int pageSize;
    OrderFootBtnView * footBtn;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的配送";
    [self setNbColor];
    self.tableview.delegate = self;
    self.tableview.dataSource =self;
    // Do any additional setup after loading the view from its nib.
    _dataArray =[NSMutableArray array];
    _infoArray =[NSMutableArray array];
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self setRefrshWithTableView:self.tableview];
    [self ChangeMySegmentStyle:self.segment];
    [self.tableview.mj_header beginRefreshing];

}
-(void)headerRereshing
{
    [super headerRereshing];
    page =1;
    pageSize =30;
    
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
    NSMutableDictionary * param =[NSMutableDictionary dictionary];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@(pageSize) forKey:@"pageSize"];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
//    [param setObject:@"1,10,0" forKey:@"status"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/order/orderDelivery/queryOrderDelivery.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        DLog(@"dic");
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];

        if (page ==1) {
            [_infoArray removeAllObjects];
            self.tableview.mj_footer.hidden = NO;
        }
        
        NSArray * dataArr =[[dic objectForKey:@"data"]objectForKey:@"array"];
        if (dataArr.count<30) {
            self.tableview.mj_footer.hidden =YES;
        }
        [_infoArray addObjectsFromArray:dataArr];
        
        
        
        [self getinfoWithStatus:self.segment.selectedSegmentIndex];
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];

        
    }];
}

//取消订单

-(void)cancelOrderWithOrderNo:(NSString *)orderNo
{
    NSMutableDictionary * param =[NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [param safeSetObject:[UserModel shareInstance].username forKey:@"userName"];
    [param safeSetObject:orderNo forKey:@"orderNo"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/order/orderDelivery/cancelOrderDelivery.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        
        [[UserModel shareInstance]showSuccessWithStatus:@"取消成功"];
        [self.tableview.mj_header beginRefreshing];

    } failure:^(NSError *error) {
        [[UserModel shareInstance]showErrorWithStatus:@"取消失败"];

    }];
    
    
}

-(void)ConfirmTheGoodsWithOrderNo:(NSString *)orderNo
{
    
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"" message:@"是否确认收货？" preferredStyle:UIAlertControllerStyleAlert];
    [al addAction:[UIAlertAction actionWithTitle:@"确认收货" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary * param =[NSMutableDictionary dictionary];
        [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
        [param safeSetObject:[UserModel shareInstance].username forKey:@"userName"];
        [param safeSetObject:orderNo forKey:@"orderNo"];
        
        self.currentTasks = [[BaseSservice sharedManager]post1:@"app/order/orderDelivery/confirmReceipt.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
            [[UserModel shareInstance]showSuccessWithStatus:@"确认收货成功"];
            [self.tableview reloadData];
            
        } failure:^(NSError *error) {
            for (NSString * str in [error.userInfo allKeys]) {
                if ([str isEqualToString:@"message"]) {
                    [[UserModel shareInstance]showErrorWithStatus:str];
                    return ;
                }
            }
            [[UserModel shareInstance]showErrorWithStatus:@"确认收货失败"];
            
            
        }];

    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"再等等" style:UIAlertActionStyleCancel handler:nil]];
    
     [self presentViewController:al animated:YES completion:nil];
     
     
    

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 50)];
    view.backgroundColor =[UIColor colorWithWhite:.95 alpha:1];
    
    TZSOrderHeader *header = [self getXibCellWithTitle:@"TZSOrderHeader"];
    header.frame = CGRectMake(0, 9, JFA_SCREEN_WIDTH, 40);
    header.backgroundColor =[UIColor whiteColor];
    NSDictionary *dic = [_dataArray objectAtIndex:section];
    header.orderNumLabel.text = [dic objectForKey:@"orderNo"];
    
    int status = [[dic objectForKey:@"status"]intValue];
    //1待付款 2付款确认中3待收货 10已完成 0已取消
    if (status ==0) {
        header.statusLabel.text = @"已取消";
    }
    else if (status ==1)
    {
        header.statusLabel .text = @"待付款";

    }
    else if (status ==2)
    {
        header.statusLabel .text = @"付款确认中";

    }
    else if (status ==3)
    {
        header.statusLabel .text = @"待收货";
        
    }
    
    else if (status ==10)
    {
        header.statusLabel .text= @"已完成";
    }
    [view addSubview:header];
    
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSDictionary *dic = [_dataArray objectAtIndex:section];
    int status = [[dic safeObjectForKey:@"status"]intValue];
    int operateStatus = [[dic safeObjectForKey:@"operateStatus"]intValue];
    float height = 0.0f;
    if (status==1||(status==3&&operateStatus==4)) {
        height =87;
    }else{
        height =41;
    }
    
    UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, height)];
    view.backgroundColor =HEXCOLOR(0xeeeeee);
    OrderFooter *footer = [self getXibCellWithTitle:@"OrderFooter"];
    footer.frame = CGRectMake(0, 1, JFA_SCREEN_WIDTH, 40);
    footer.priceLabel.text = [NSString stringWithFormat:@"%.2f元(含运费￥%.2f)",[[dic objectForKey:@"freight"]floatValue],[[dic objectForKey:@"freight"]floatValue]];
    
    NSString * payStr =@"";
    if (status ==10||status ==3) {
        payStr =@"已付款";
    }else{
        payStr =@"需付款";
    }
    

    
    footer.countLabel.text = [NSString stringWithFormat:@"共计%@项商品，%@：",[dic objectForKey:@"quantitySum"],payStr];
    [view addSubview:footer];

    footBtn = [self getXibCellWithTitle:@"OrderFootBtnView"];
    footBtn.frame = CGRectMake(0, 42, JFA_SCREEN_WIDTH, 44);
    footBtn.myDelegate =self;
    footBtn.tag = section;
    [view addSubview:footBtn];
    
    if (status ==0) {
        footBtn.hidden = YES;
    }
    else if (status ==1)
    {
        footBtn.hidden = NO;
        footBtn.secondBtn.hidden = NO;
        footBtn.firstBtn.hidden =NO;
        [footBtn.firstBtn setTitle:@"去支付" forState:UIControlStateNormal];
        [footBtn.secondBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        
    }
    else if (status ==2)
    {
        footBtn.hidden = YES;
    }
    else if (status ==3&&operateStatus==4)
    {
        [footBtn.firstBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        footBtn.firstBtn.hidden = NO;
        footBtn.secondBtn.hidden =YES;
        footBtn.thirdBtn.hidden =YES;

        //        header.statusLabel .text = @"待收货";
        
    }
    
    else if (status ==10)
    {
        footBtn.hidden = YES;
        //        header.statusLabel .text= @"已完成";
    }else{
        footBtn.hidden = YES;
    }
    
    return view;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSDictionary *dic =[_dataArray objectAtIndex:section];
    int status = [[dic objectForKey:@"status"]intValue];
    int operateStatus = [[dic safeObjectForKey:@"operateStatus"]intValue];

    if (status ==1||(status==3&&operateStatus==4)) {
        return 41+46;
    }else{
        return 41;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * arr = [_dataArray[section] objectForKey:@"itemJson"];
    return arr.count;
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
    
//    cell.priceLabel .hidden = YES;
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
    
    NSDictionary * dic = [_dataArray objectAtIndex:indexPath.section];
    
    TZSDistributionDetailViewController * dt = [[TZSDistributionDetailViewController alloc]init];
    dt.orderNo =[dic safeObjectForKey:@"orderNo"];
    dt.delegate = self;
    [self.navigationController pushViewController:dt animated:YES];
}
-(void)getinfoWithStatus:(NSInteger)segmentIndex
{
    int type = 0;
    if (segmentIndex ==0) {
        type =100;
    }else if(segmentIndex ==1){
        type =1;
    }else if(segmentIndex ==2){
        type =3;
    }else if(segmentIndex ==3){
        type =10;
    }else if(segmentIndex ==4)
    {
        type =0;
    }
    
    [_dataArray removeAllObjects];
    
    if (type==100) {
        [_dataArray  addObjectsFromArray:_infoArray];
        return;
    }
    
    for (int i =0; i<_infoArray.count; i++) {
        NSDictionary * dic =[_infoArray objectAtIndex:i];
        int allType = [[dic objectForKey:@"status"]intValue];
        if (allType ==type) {
            [_dataArray addObject:dic];
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)changeinfo:(UISegmentedControl *)sender {
    [self getinfoWithStatus:sender.selectedSegmentIndex];
    
    [self.tableview reloadData];

}
-(void)didClickFirstBtnWithView:(OrderFootBtnView*)view
{

    
    //去支付
    NSDictionary *dic = [_dataArray objectAtIndex:view.tag];
    int status = [[dic objectForKey:@"status"]intValue];
    if (status==1) {
        BaseWebViewController *web = [[BaseWebViewController alloc]init];
        web.urlStr = @"app/checkstand.html";
        web.payableAmount = [dic safeObjectForKey:@"payableAmount"];
        //payType 1 消费者订购 2 配送订购 3 服务订购 4 充值
        web.payType =2;
        web.opt =1;
        web.orderNo = [dic safeObjectForKey:@"orderNo"];
        web.title  =@"收银台";
        [self.navigationController pushViewController:web animated:YES];
        
    }
    else if (status ==3)
    {
       //确认收货
        [self ConfirmTheGoodsWithOrderNo:[dic safeObjectForKey:@"orderNo"]];
    }
}
-(void)didClickSecondBtnWithView:(OrderFootBtnView*)view
{
    NSDictionary *dic = [_dataArray objectAtIndex:view.tag];

//    int orderType = [[dic safeObjectForKey:@"orderType"]intValue];
//    if (orderType ==2) {
//        //    取消订单
//        NSMutableDictionary * param =[NSMutableDictionary dictionary];
//        [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
//        [param safeSetObject:[dic safeObjectForKey:@"orderNo"] forKey:@"orderNo"];
//        [param safeSetObject:[UserModel shareInstance].nickName  forKey:@"userName"];
//        [param safeSetObject:@"" forKey:@"cancelRemark"];
//        self.currentTasks = [[BaseSservice sharedManager]post1:@"app/order/orderDelivery/cancelOrderDelivery.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
//            DLog(@"取消订单成功--%@",dic);
//            [[UserModel shareInstance] showSuccessWithStatus:@"订单取消成功"];
//            [self.tableview.mj_header beginRefreshing];
//
//        } failure:^(NSError *error) {
//            [[UserModel shareInstance] showErrorWithStatus:@"订单取消失败"];
//            
//            DLog(@"取消订单失败--%@",error);
//        }];
//  
//    }else{
        NSMutableDictionary * param =[NSMutableDictionary dictionary];
        [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
        [param safeSetObject:[dic safeObjectForKey:@"orderNo"] forKey:@"orderNo"];
        [param safeSetObject:[UserModel shareInstance].nickName  forKey:@"userName"];
        self.currentTasks = [[BaseSservice sharedManager]post1:@"app/orderList/cancelOrder.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
            DLog(@"取消订单成功--%@",dic);
            [[UserModel shareInstance] showSuccessWithStatus:@"订单取消成功"];
            [self.tableview.mj_header beginRefreshing];

        } failure:^(NSError *error) {
            [[UserModel shareInstance] showErrorWithStatus:@"订单取消失败"];
            
            DLog(@"取消订单失败--%@",error);
        }];
 
//    }
    
}
-(void)distributionOrderChange
{
    [self.tableview.mj_header beginRefreshing];
}

@end
