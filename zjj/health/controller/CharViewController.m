//
//  CharViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/24.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "CharViewController.h"
#import "AAGlobalMacro.h"
#import "AAChartKit.h"
#import "NSDate+CustomDate.h"
#import "ShareHealthItem.h"
#import "NSString+dateWithString.h"
@interface CharViewController ()
@property(nonatomic,strong) AAChartModel   *    chartModel;
@property(nonatomic,strong) AAChartView    *    chartView;
@property(nonatomic,strong) NSMutableArray *    dataArray;
@property(nonatomic,assign) int                 timeLength;
@property(nonatomic,copy  ) NSDate         *    startDate;
@property(nonatomic,copy  ) NSDate         *    endDate;
@property(nonatomic,strong) NSMutableArray *    dateArray;
@property(nonatomic,strong) NSMutableArray *    bmiArray;
@property(nonatomic,strong) NSMutableArray *    mfatArray;
@property(nonatomic,strong) NSMutableArray *    waterArray;
@property(nonatomic,strong) NSMutableArray *    mCalorieArray;
@property(nonatomic,strong) NSMutableArray *    mBoneArray;
@end

@implementation CharViewController
{
    UIButton * selectBtn;
    UIButton * dateLengthBtn;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.tabBarController.tabBar.hidden=YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTBRedColor];
    self.title = @"历史趋势";
    self.timeLength = 7;
    self.endDate = [NSDate date];
    self.startDate =[self.endDate dateByAddingTimeInterval:(-self.timeLength * 24 * 60 * 60)];
    self.dateLabel.text = [NSString stringWithFormat:@"%@-%@",[self.startDate mmdd],[self.endDate mmdd]];

    
    self.dataArray =[NSMutableArray array];
    self.dateArray = [NSMutableArray array];
    self.mfatArray = [NSMutableArray array];
    self.mBoneArray = [NSMutableArray array];
    self.mCalorieArray = [NSMutableArray array];
    self.bmiArray = [NSMutableArray array];
    self.waterArray = [NSMutableArray array];

    
//    self.lenghtSegment.selectedSegmentIndex =0;
//    self.listSegment.selectedSegmentIndex = 0;
    
    UIButton *button =(UIButton *)[self.view viewWithTag:11];
    button.selected = YES;
    dateLengthBtn = button;
    
    
    for (int i =0;i<5; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:i+1];
        if (i==0) {
            btn.selected = YES;
            selectBtn = btn;
        }else{
            btn.selected = NO;
        }
    }
    
    
    [self getListInfo];
    [self configTheChartView:AAChartTypeLine];

    
    // Do any additional setup after loading the view from its nib.
}

-(void)getListInfo
{
    NSMutableDictionary * param  = [NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].subId forKey:@"subUserId"];
    [param safeSetObject:self.startDate forKey:@"startDate"];
    [param safeSetObject:self.endDate forKey:@"endDate"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/evaluatData/queryEvaluatTrend.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        NSDictionary * dataDict =[dic safeObjectForKey:@"data"];
        NSArray * arr = [dataDict safeObjectForKey:@"array"];
        [_dataArray removeAllObjects];
        for (int i =0; i<arr.count; i++) {
            NSDictionary * dict =[arr objectAtIndex:i];
            ShareHealthItem * item =[[ShareHealthItem alloc]init];
            [item setobjectWithDic:dict];
            [_dataArray addObject:item];
        }
        [self getDateArrayWithDadaArray];
        
        DLog(@"%@",dic);
    } failure:^(NSError *error) {
        if (error.code ==402) {
            [self.dataArray removeAllObjects];
            [self getDateArrayWithDadaArray];

        }
        
    }];
}

-(void)getDateArrayWithDadaArray
{
    
    [self.dateArray removeAllObjects];
    [self.bmiArray removeAllObjects];
    [self.waterArray removeAllObjects];
    [self.mfatArray removeAllObjects];
    [self.mCalorieArray removeAllObjects];
    [self.mBoneArray removeAllObjects];
    
    for (int i =(self.dataArray.count-1); i>=0; i--) {
        ShareHealthItem * item =[self.dataArray objectAtIndex:i];
        NSDate   *   time = item.createTime;
        float   mfat = [[NSString stringWithFormat:@"%.1f",item.fatPercentage*100]floatValue];
        float   mwater =[[NSString stringWithFormat:@"%.1f",item.waterWeight]floatValue] ;
        float   mCalorie = [[NSString stringWithFormat:@"%.1f",item.fatWeight]floatValue];
        float   bmi =[[NSString stringWithFormat:@"%.1f",item.bmi]floatValue];
        float   mbone =[[NSString stringWithFormat:@"%.1f",item.boneMuscleWeight]floatValue];
        
        [self.dateArray addObject:[time mmdd]];
        [self.mfatArray addObject:@(mfat)];
        [self.waterArray addObject:@(mwater)];
        [self.mCalorieArray addObject:@(mCalorie)];
        [self.bmiArray addObject:@(bmi)];
        [self.mBoneArray addObject:@(mbone)];
    }

    NSInteger tag  =selectBtn.tag;
    switch (tag) {
        case 1:
            [self ChartViewsetDateArray:self.dateArray infoArray:_bmiArray title:@"BMI"];
            
            break;
        case 2:
            [self ChartViewsetDateArray:self.dateArray infoArray:_mfatArray title:@"体脂"];
            
            break;
        case 3:
            [self ChartViewsetDateArray:self.dateArray infoArray:_mCalorieArray title:@"脂肪量"];
            
            break;
        case 4:
            [self ChartViewsetDateArray:self.dateArray infoArray:_waterArray title:@"水分"];
            
            break;
        case 5:
            [self ChartViewsetDateArray:self.dateArray infoArray:_mBoneArray title:@"骨量"];
            
            break;
            
        default:
            break;
    }
    
    
}

-(void)configTheChartView:(NSString *)chartType{
    self.chartView = [[AAChartView alloc]init];
    self.chartView.frame =CGRectMake(0, 0, JFA_SCREEN_WIDTH-40, JFA_SCREEN_WIDTH-40);
    self.chartView.contentWidth = JFA_SCREEN_WIDTH-40;
    self.chartView.contentHeight = JFA_SCREEN_WIDTH-40;
    [self.superChartView addSubview:self.chartView];
    self.chartModel= AAObject(AAChartModel).chartTypeSet(chartType)
    .titleSet(@"")
    .subtitleSet(@"")
    .pointHollowSet(true)
    .categoriesSet(self.dateArray)
    .yAxisTitleSet(@"")
    .crosshairsSet(NO)
    .yAxisGridLineWidthSet(@(0))
    .seriesSet(@[
                 AAObject(AASeriesElement)
                 .nameSet(@"")
                 .dataSet(self.bmiArray),
                 ]
                 ) ;
    [self.chartView aa_drawChartWithChartModel:_chartModel];
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

- (IBAction)didRed:(id)sender {
    self.endDate   = [self.endDate dateByAddingTimeInterval:(-24*60*60)];
    self.startDate = [self.startDate dateByAddingTimeInterval:(-1 * 24 * 60 * 60)];
    self.dateLabel.text = [NSString stringWithFormat:@"%@-%@",[self.startDate mmdd],[self.endDate mmdd]];
    [self getListInfo];
}

- (IBAction)didAdd:(id)sender {
    if (self.endDate ==[NSDate date]) {
        return;
    }
    
    self.startDate = [self.startDate dateByAddingTimeInterval:( 24 * 60 * 60)];
    self.endDate = [self.endDate dateByAddingTimeInterval:( 24 * 60 * 60)];
    self.dateLabel.text = [NSString stringWithFormat:@"%@-%@",[self.startDate mmdd],[self.endDate mmdd]];
    [self getListInfo];

}

- (IBAction)lengthSegment:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex ==0) {
        self.timeLength = 7;
        
    }else if (sender.selectedSegmentIndex==1)
    {
        self.timeLength=30;
    }else{
        self.timeLength = 366;
    }
    self.endDate = [NSDate date];
    self.startDate =[self.endDate dateByAddingTimeInterval:(-self.timeLength * 24 * 60 * 60)];
    self.dateLabel.text = [NSString stringWithFormat:@"%@-%@",[self.startDate mmdd],[self.endDate mmdd]];
    [self getListInfo];
}
- (IBAction)ChangeLength:(UIButton *)sender {
    UIButton * button =sender;
    
    if (button==dateLengthBtn) {
        return;
    }else{
        button.selected = YES;
        dateLengthBtn.selected =NO;
        dateLengthBtn = button;
        if (sender.tag ==11) {
            self.timeLength =7;
            self.leftBtn.hidden = NO;
            self.rightBtn.hidden = NO;
            self.dateLabel.hidden = NO;

        }else if (button.tag ==12){
            self.timeLength =30;
            self.leftBtn.hidden = NO;
            self.rightBtn.hidden = NO;
            self.dateLabel.hidden = NO;

        }else{
            self.leftBtn.hidden = YES;
            self.rightBtn.hidden = YES;
            self.dateLabel.hidden = YES;
            
            self.timeLength=366;
        }
        DLog(@"选择时长__%d",self.timeLength);
        self.endDate = [NSDate date];
        self.startDate =[self.endDate dateByAddingTimeInterval:(-self.timeLength * 24 * 60 * 60)];
        self.dateLabel.text = [NSString stringWithFormat:@"%@-%@",[self.startDate mmdd],[self.endDate mmdd]];
        [self getListInfo];

    }
    
    
    
}


-(void)setDateWithLengthSegment
{
    self.endDate = [NSDate date];
    self.startDate =[self.endDate dateByAddingTimeInterval:(-self.timeLength * 24 * 60 * 60)];
    self.dateLabel.text = [NSString stringWithFormat:@"%@-%@",[self.startDate mmdd],[self.endDate mmdd]];
    [self getListInfo];

}




- (IBAction)listSegment:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self ChartViewsetDateArray:self.dateArray infoArray:_bmiArray title:@"BMI"];
            
            break;
        case 1:
            [self ChartViewsetDateArray:self.dateArray infoArray:_mfatArray title:@"体脂"];
            break;
        case 2:
             [self ChartViewsetDateArray:self.dateArray infoArray:_mCalorieArray title:@"脂肪量"];
            break;
        case 3:
             [self ChartViewsetDateArray:self.dateArray infoArray:_waterArray title:@"水分"];
            break;
        case 4:
             [self ChartViewsetDateArray:self.dateArray infoArray:_mBoneArray title:@"骨量"];
            break;
            
        default:
            break;
    }
    

}
-(void)ChartViewsetDateArray:(NSMutableArray *)dateArray infoArray:(NSMutableArray *)infoarray title:(NSString *)title
{
    // AAChartTypeLine
    self.chartModel= AAObject(AAChartModel).chartTypeSet(AAChartTypeLine)
    .titleSet(title)
    .subtitleSet(@"")
    .pointHollowSet(true)
    .crosshairsSet(NO)
    .yAxisGridLineWidthSet(@(0))

    .categoriesSet(dateArray)
    .yAxisTitleSet(@"")
    .seriesSet(@[
                 AAObject(AASeriesElement)
                 .nameSet(@"")
                 .dataSet(infoarray),
                 ]
               ) ;
    [self.chartView aa_drawChartWithChartModel:_chartModel];

}
- (IBAction)didChangeChart:(UIButton *)sender {
    
    if (sender.tag == selectBtn.tag) {
        return;
    }
    selectBtn.selected = NO;
    sender.selected = YES;
    selectBtn = sender;
    switch (sender.tag) {
        case 1:
            [self ChartViewsetDateArray:self.dateArray infoArray:_bmiArray title:@"BMI"];
            
            break;
        case 2:
            [self ChartViewsetDateArray:self.dateArray infoArray:_mfatArray title:@"体脂"];
            break;
        case 3:
            [self ChartViewsetDateArray:self.dateArray infoArray:_mCalorieArray title:@"脂肪量"];
            break;
        case 4:
            [self ChartViewsetDateArray:self.dateArray infoArray:_waterArray title:@"水分"];
            break;
        case 5:
            [self ChartViewsetDateArray:self.dateArray infoArray:_mBoneArray title:@"量"];
            break;
            
        default:
            break;
    }
    

    
    
    
    
    
    
    
    
}
@end
