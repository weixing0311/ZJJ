//
//  GrowthStstemViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "GrowthStstemViewController.h"
#import "PublicCell.h"
#import "GrowthStstemHeaderCell.h"
#import "GrowthCell.h"
#import "LevelSnstructionsViewController.h"
#import "IntegralSignInView.h"
@interface GrowthStstemViewController ()<UITableViewDelegate,UITableViewDataSource,growthHeaderCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSArray * dataArray;
@property (nonatomic,strong)NSDictionary * infoDict;
@end

@implementation GrowthStstemViewController
{
//    GrowthHeader2View * grView;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"成长积分";
    [self setTBWhiteColor];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem * rightitem =[[UIBarButtonItem alloc]initWithImage:getImage(@"Prompt_") style:UIBarButtonItemStylePlain target:self action:@selector(enterRightPage)];
    self.navigationItem.rightBarButtonItem = rightitem;
    
    
    _dataArray = [NSArray array];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    
    [self getInfo];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)getInfo
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/integral/growthsystem/queryAll.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        self.infoDict = [NSDictionary dictionaryWithDictionary:[dic objectForKey:@"data"]];

        self.dataArray = [self.infoDict safeObjectForKey:@"taskArry"];
        
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        return JFA_SCREEN_WIDTH*0.55<200?200:JFA_SCREEN_WIDTH*0.55 ;
    }else{
    return 60;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else{
    return self.dataArray.count;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section ==1) {
        return @"成长任务";
    }else{
        return @"";
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return 0.01;
    }else{
        return 30;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        static NSString * identifier = @"GrowthStstemHeaderCell";
        GrowthStstemHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.todayIntegerallb.text = [NSString  stringWithFormat:@"今日已赚取积分：%d",[[_infoDict safeObjectForKey:@"todayIntegeral"]intValue]];
        cell.totalIntegerallb.text = [NSString  stringWithFormat:@"%@分",[_infoDict safeObjectForKey:@"countIntegral"]];
        cell.dayslb.text = [NSString stringWithFormat:@"连续签到%@天",[_infoDict safeObjectForKey:@"cumulDays"]];
        
        int  countIntegral = [[self.infoDict objectForKey:@"countIntegral"]intValue];
        NSMutableArray * bigArr =[NSMutableArray array];
        NSArray * arr = [self.infoDict objectForKey:@"integeralGrade"];
        for (int i =0; i<arr.count; i++) {
            NSDictionary * dic = [arr objectAtIndex:i];
            int  integral = [[dic objectForKey:@"integral"]intValue];
            if (countIntegral<integral) {
                [bigArr addObject:dic];
            }
        }
        NSDictionary * currDic ;
        NSDictionary * nextDict;
        DLog(@"bigArr--%@",bigArr);
        if (bigArr.count==0) {
            currDic = [arr lastObject];
            nextDict = nil;
        }
        else if (bigArr.count ==arr.count) {
            currDic = bigArr[0];
            nextDict = bigArr[1];
        }
        else{
            currDic = bigArr[0];
            nextDict = bigArr[1];
        }
        cell.levellb.text = [currDic objectForKey:@"gradeName"];
        cell.level1lb.text = [currDic objectForKey:@"gradeName"];
        cell.level2lb.text = [nextDict objectForKey:@"gradeName"];
        cell.lessIntrgrallb.text =[NSString stringWithFormat:@"距离下个等级还需%d积分",[[currDic objectForKey:@"integral"]intValue]-countIntegral];
        double progress = countIntegral/[[currDic objectForKey:@"integral"]doubleValue];;
        if (progress>0) {
            cell.progressView.frame = CGRectMake(0, 0, (JFA_SCREEN_WIDTH-100)*progress, 5);
            cell.progressImg.frame = CGRectMake(20+cell.progressView.frame.size.width-5, 5, 10, 10);
        }
        
        //判断是否签到
        
        NSArray * qdArr = [_infoDict safeObjectForKey:@"taskArry"];
        for (NSDictionary *QDdict in qdArr) {
            NSString * taskName = [QDdict safeObjectForKey:@"taskName"];
            if ([taskName isEqualToString:@"签到"]) {
                if ([[QDdict allKeys]containsObject:@"success"]) {
                    cell.qdBtn.selected =YES;
                    cell.qdBtn.userInteractionEnabled =NO;
                }
            }
        }
        return cell;

    }else
    {
        
    static NSString * identifier = @"GrowthCell";
    GrowthCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSDictionary * dic = [self.dataArray objectAtIndex:indexPath.row];
    cell.titlelb.text = [dic safeObjectForKey:@"taskName"];
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:[dic safeObjectForKey:@"picture"]] placeholderImage:getImage(@"")];
        cell.secondlb.text = [NSString stringWithFormat:@"积分+%@",[dic safeObjectForKey:@"integral"]];
        if ([dic safeObjectForKey:@"success"]) {
            cell.statusLb.text = @"已完成";
            cell.statusLb.textColor = HEXCOLOR(0x666666);
        }else{
            if ([[dic allKeys]containsObject:@"topTimes"]) {
                cell.statusLb.text = [NSString stringWithFormat:@"%@次",[dic objectForKey:@"topTimes"]];
                cell.statusLb.textColor = HEXCOLOR(0x666666);
            }else{
                cell.statusLb.text = @"未完成";
                cell.statusLb.textColor =[UIColor redColor];
            }
        }
    return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark ---subView Delegate
-(void)didClickQdWithCell:(GrowthStstemHeaderCell *)cell
{
    NSMutableDictionary * params  = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"taskId"];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/integral/growthsystem/gainPoints.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        DLog(@"签到success-dic:%@",dic);
        [[UserModel shareInstance]showSuccessWithStatus:@"签到成功！"];
        [self getInfo];
        [self showSignInPage];
    } failure:^(NSError *error) {
        DLog(@"签到失败-error:%@",error);
        [self showSignInPage];
    }];
}

-(void)showSignInPage
{
    IntegralSignInView  * signView = [[[NSBundle mainBundle]loadNibNamed:@"IntegralSignInView" owner:nil options:nil]lastObject];
    signView.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT);
    signView.signInBtn.selected =YES;
    signView.signInBtn.backgroundColor = HEXCOLOR(0x9b9b9b);
    [self.view addSubview:signView];
}
-(void)enterRightPage
{
    LevelSnstructionsViewController * lev = [[LevelSnstructionsViewController alloc]init];
    lev.infoDict =_infoDict;
    [self.navigationController pushViewController:lev animated:YES];
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
