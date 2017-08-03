//
//  TZSDistributionDetailViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/7/27.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TZSDistributionDetailViewController.h"
#import "UpDateOrderCell.h"
#import "TZSOrderHeader.h"
#import "UpdataAddressCell.h"
#import "DistributionBottomCell.h"
#import "WXPsTitleCell.h"
#import "UpdataAddressCell.h"
#import "BaseWebViewController.h"
#import "OrderFootBtnView.h"
#import "OrderFooter.h"
@interface TZSDistributionDetailViewController ()<UITableViewDataSource,UITableViewDelegate,orderFootBtnViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation TZSDistributionDetailViewController
{
    NSMutableArray * _dataArray;
    NSMutableDictionary * _infoDict;
    OrderFootBtnView * footBtn;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController .navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"配送详情";
    [self setNbColor];
    self.tableview .delegate =self;
    self.tableview.dataSource = self;
    self.tableview.sectionFooterHeight = 10;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    _dataArray = [NSMutableArray array];
    _infoDict = [NSMutableDictionary dictionary ];;
    [self getlistInfo_is_tzs];
    // Do any additional setup after loading the view from its nib.
}
-(void)getlistInfo_is_tzs
{
    NSMutableDictionary * param =[NSMutableDictionary dictionary];
    [param setObject:self.orderNo forKey:@"orderNo"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/order/orderDelivery/queryOrderDetail.do" paramters:param success:^(NSDictionary *dic) {
        DLog(@"dic");
        _infoDict = [[dic safeObjectForKey:@"data"]safeObjectForKey:@"array"][0];
        [_dataArray addObjectsFromArray:[_infoDict safeObjectForKey:@"itemJson"]];
        
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
    }];
    
}
-(void)ConfirmTheGoodsWithOrderNo:(NSString *)orderNo
{
    NSMutableDictionary * param =[NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [param safeSetObject:[UserModel shareInstance].username forKey:@"userName"];
    [param safeSetObject:orderNo forKey:@"orderNo"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/order/orderDelivery/confirmReceipt.do" paramters:param success:^(NSDictionary *dic) {
        [[UserModel shareInstance]showSuccessWithStatus:@"取消订单成功"];
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
        [[UserModel shareInstance]showErrorWithStatus:@"取消订单失败"];
        
    }];
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        if (section==0) {
            return 1;
        }
        else if (section ==1)
        {
            return 1;
    
        }
    
    if (section ==2)
    {
        return _dataArray.count;
        
    }
    else if(section ==3)
    {
        return 2;
        
    }else{
        
        return 1;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section==2) {
        UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 40)];

        view.backgroundColor =HEXCOLOR(0xeeeeee);
        
        TZSOrderHeader *header = [self getXibCellWithTitle:@"TZSOrderHeader"];
        header.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, 40);
        header.backgroundColor =[UIColor whiteColor];
        header.orderNumLabel.text = [NSString stringWithFormat:@"订单号：%@",[_infoDict objectForKey:@"orderNo"]];
        
        int status = [[_infoDict objectForKey:@"status"]intValue];
        
        header.statusLabel .text = [self getStatusWithStatus:status];
        [view addSubview:header];
        return view;

        
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==2) {
        return 40;
        
    }else
        return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==4) {
        int status = [[_infoDict objectForKey:@"status"]intValue];

        if (status==1||status ==3) {
            return 87;
        }else{
            return 41;
        }

    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==4) {
        int status = [[_infoDict objectForKey:@"status"]intValue];
        int operateStatus = [[_infoDict safeObjectForKey:@"operateStatus"]intValue];

        float height = 0.0f;
        if (status==1||status ==3) {
            height =87;
        }else{
            height =41;
        }
        
        UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, height)];
        view.backgroundColor =HEXCOLOR(0xeeeeee);
        OrderFooter *footer = [self getXibCellWithTitle:@"OrderFooter"];
        footer.frame = CGRectMake(0, 1, JFA_SCREEN_WIDTH, 30);
        footer.priceLabel.text = [NSString stringWithFormat:@"%.2f元(含运费￥%.2f)",[[_infoDict objectForKey:@"freight"]floatValue],[[_infoDict objectForKey:@"freight"]floatValue]];
        footer.countLabel.text = [NSString stringWithFormat:@"共计%@项商品，合计：",[_infoDict objectForKey:@"quantitySum"]];
        
        footBtn = [self getXibCellWithTitle:@"OrderFootBtnView"];
        footBtn.frame = CGRectMake(0, 32, JFA_SCREEN_WIDTH, 44);
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

            [footBtn.firstBtn setTitle:@"去支付" forState:UIControlStateNormal];
            [footBtn.secondBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            
        }
        else if (status ==2)
        {
            footBtn.hidden = YES;
        }
        else if (status ==3)
        {
            footBtn.hidden = NO;
            [footBtn.firstBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            if (operateStatus==3) {
                footBtn.firstBtn.hidden = YES;
                footBtn.secondBtn.hidden =YES;
                footBtn.thirdBtn.hidden =NO;
            }
            else if(operateStatus==4)
            {
                footBtn.firstBtn.hidden = NO;
                footBtn.secondBtn.hidden =YES;
                footBtn.thirdBtn.hidden =YES;
                
            }
            //        header.statusLabel .text = @"待收货";
            
        }
        
        else if (status ==10)
        {
            footBtn.hidden = YES;
            //        header.statusLabel .text= @"已完成";
        }
        
        
        
        [view addSubview:footer];
        return view;
        
 
    }
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int status = [[_infoDict objectForKey:@"status"]intValue];
    if (indexPath.section ==0) {
        if (status==3) {
            return 80;

        }else{
            return 0;
        }
    }
    
    else if(indexPath.section ==1)
    {
        return 80;
    }
    
    else if (indexPath.section ==2)
    {
        return 100;
    }
    else if(indexPath.section ==3){
        if (indexPath.row==0) {
            return 44;
        }else{
            if (status==3) {
                return 44;
            }else{
            return 0;
            }
   
        }
    }else{
        return 75;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int status = [[_infoDict objectForKey:@"status"]intValue];

        if (indexPath.section ==0) {
            
            static NSString * identifier = @"WXPsTitleCell";
    
            WXPsTitleCell * cell =[tableView dequeueReusableCellWithIdentifier:identifier];

            if (!cell) {
                cell = [self getXibCellWithTitle:identifier];
            }
            
            
            if (status==3) {
                cell.payTsView.hidden = YES;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.titleLabel.text  =[_infoDict safeObjectForKey:@"clientDescription"];
                cell.timeLabel.text = [_infoDict safeObjectForKey:@"operationTime"];
            }else
            {
                cell.payTsView.hidden = YES;
                cell.titleLabel.text =@"";
                cell.timeLabel.text =@"";
            }
//            else if(status ==1){
//                cell.payTsView.hidden =NO;
//                cell.lastTime.text =[NSString stringWithFormat:@"剩余：%@",@"0小时0分"];
//                cell.paypriceLabel.text = [NSString stringWithFormat:@"需付款:￥%@",[_infoDict safeObjectForKey:@"freight"]];
//            }else{
//                cell.payTsView.hidden = YES;
//            }
            return cell;
    
    
        }
        else if (indexPath.section == 1){
            static NSString * identifier = @"UpdataAddressCell";
    
            UpdataAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [self getXibCellWithTitle:identifier];
            }
            
            cell.titleLabel.text =[_infoDict safeObjectForKey:@"consigneeName"];
            cell.addressLabel.text = [NSString stringWithFormat:@"%@",[_infoDict safeObjectForKey:@"consigneeAddress"]];
            cell.phonenumLabel.text = [_infoDict safeObjectForKey:@"consigneePhone"];
            return cell;
    
        }
    
    if (indexPath.section ==2) {
        static NSString * identifier = @"UpDateOrderCell";
        UpDateOrderCell * cell =[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        NSDictionary * dic = [_dataArray objectAtIndex:indexPath.row];
        cell.titleLabel.text = [dic safeObjectForKey:@"productName"];
        [cell.headImageView setImageWithURL:[NSURL URLWithString:[dic safeObjectForKey:@"picture"]] placeholderImage:[UIImage imageNamed:@"find_default"]];
        
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",[dic safeObjectForKey:@"unitPrice"]];
        cell.countLabel.text = [NSString stringWithFormat:@"x%@",[dic safeObjectForKey:@"quantity"]];
        
        return cell;
    }
    else if (indexPath.section ==3)
    {
        static NSString * identifier = @"cell1";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        if (indexPath.row ==0) {
            cell.textLabel.text =[NSString stringWithFormat:@"下单时间：%@",[_infoDict objectForKey:@"createTime"]];
        }else{
            if (status==3) {
                cell.textLabel.text =[NSString stringWithFormat:@"支付方式：%@",[_infoDict safeObjectForKey:@"paymentType"]];
  
            }else{
                cell.textLabel.text = @"";
            }
        }
        return cell;
        
    }
    else
    {
        static NSString * identifier = @"DistributionBottomCell";
        
        DistributionBottomCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        
        cell.totoaPriceLabel.text = [NSString stringWithFormat:@"+￥%.2f",[[_infoDict objectForKey:@"totalPrice"]floatValue]];
        cell.uhLabel.text =[NSString stringWithFormat:@"￥%.2f",[[_infoDict objectForKey:@"totalPrice"]floatValue]-[[_infoDict objectForKey:@"payableAmount"]floatValue]];
        cell.thirdTitleLabel.text = @"实付款";
        cell.ufLabel.text =[NSString stringWithFormat:@"￥%.2f",[[_infoDict objectForKey:@"payableAmount"]floatValue]];
        return cell;
        
    }
    
}
-(NSString *)getStatusWithStatus:(int)myStatus
{
    switch (myStatus) {
            //                    订单状态 1待付款   10.已完成  0已取消
        case 1:
            return @"待付款";
            break;
        case 10:
            return @"已完成";
            break;
        case 0:
            return @"已取消";
            break;
            
        default:
            break;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    int status = [[_infoDict objectForKey:@"status"]intValue];

        if (indexPath.section ==0&&status==3) {
            BaseWebViewController * web =[[BaseWebViewController alloc]init];
            web.title = @"我的配送";
            NSString * orderNo = [_infoDict safeObjectForKey:@"orderNo"];
            web.urlStr = [NSString stringWithFormat:@"app/fatTeacher/logisticsInformation.html?orderNo=%@",orderNo];
            [self.navigationController pushViewController:web animated:YES];
        }
}
-(void)didClickFirstBtnWithView:(OrderFootBtnView*)view
{
    //去支付
    
    
    //去支付
    int status = [[_infoDict objectForKey:@"status"]intValue];
    if (status==1) {
        BaseWebViewController *web = [[BaseWebViewController alloc]init];
        web.urlStr = @"app/checkstand.html";
        web.payableAmount = [_infoDict safeObjectForKey:@"payableAmount"];
        //payType 1 消费者订购 2 配送订购 3 服务订购 4 充值
        web.payType =2;
        web.opt =1;
        web.orderNo = [_infoDict safeObjectForKey:@"orderNo"];
        web.title  =@"收银台";
        [self.navigationController pushViewController:web animated:YES];
        
    }
    else if (status ==3)
    {
        //确认收货
        [self ConfirmTheGoodsWithOrderNo:[_infoDict safeObjectForKey:@"orderNo"]];
    }
    
}
-(void)didClickSecondBtnWithView:(OrderFootBtnView*)view
{
    //取消
    
    int status = [[_infoDict safeObjectForKey:@"status"]intValue];
    
    int orderType = [[_infoDict safeObjectForKey:@"orderType"]intValue];
    if (orderType ==2) {
        //    取消订单
        NSMutableDictionary * param =[NSMutableDictionary dictionary];
        [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
        [param safeSetObject:[_infoDict safeObjectForKey:@"orderNo"] forKey:@"orderNo"];
        [param safeSetObject:[UserModel shareInstance].nickName  forKey:@"userName"];
        [param safeSetObject:@"" forKey:@"cancelRemark"];
        self.currentTasks = [[BaseSservice sharedManager]post1:@"app/order/orderDelivery/cancelOrderDelivery.do" paramters:param success:^(NSDictionary *dic) {
            DLog(@"取消订单成功--%@",dic);
            [[UserModel shareInstance] showSuccessWithStatus:@"订单取消成功"];
        } failure:^(NSError *error) {
            [[UserModel shareInstance] showErrorWithStatus:@"订单取消失败"];
            
            DLog(@"取消订单失败--%@",error);
        }];
        
    }else{
        NSMutableDictionary * param =[NSMutableDictionary dictionary];
        [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
        [param safeSetObject:[_infoDict safeObjectForKey:@"orderNo"] forKey:@"orderNo"];
        [param safeSetObject:[UserModel shareInstance].nickName  forKey:@"userName"];
        self.currentTasks = [[BaseSservice sharedManager]post1:@"app/orderList/cancelOrder.do" paramters:param success:^(NSDictionary *dic) {
            DLog(@"取消订单成功--%@",dic);
            [[UserModel shareInstance] showSuccessWithStatus:@"订单取消成功"];
        } failure:^(NSError *error) {
            [[UserModel shareInstance] showErrorWithStatus:@"订单取消失败"];
            
            DLog(@"取消订单失败--%@",error);
        }];
        
    }
    

    
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