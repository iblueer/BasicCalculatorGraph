//
//  HomeViewController.m
//  BasicCalculator
//
//  Created by 宅音かがや on 2018/04/09.
//  Copyright © 2018年 宅音かがや. All rights reserved.
//

#import "HomeViewController.h"
#import "RulerView.h"

@interface HomeViewController ()

{
    NSMutableDictionary *listDic;
}

@end

@implementation HomeViewController

- (void)loadView {
    [super loadView];
//    // 创建一个UIScroll对象
//    CGRect screenFrame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
//    CGRect scrollFrame = screenFrame;
//    scrollFrame.size.height *= 2.0;
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenFrame];
//    [self.view addSubview:scrollView];
    
    //添加几个subview
    // 设置chartView属性
    CGRect chartFrame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.width);
    self.chartView = [[ChartView alloc] initWithFrame:chartFrame];
    self.chartView.graphType = @"折线图";
    self.chartView.backgroundColor = [UIColor colorWithRed:(21/255.0) green:(126/255.0) blue:(251/255.0) alpha:1.0];
    [self.view addSubview:self.chartView];
    
    //添加sege
    listDic = [NSMutableDictionary dictionary];
    
    NSArray *_graphTypes = @[@"折线图", @"柱形图", @"饼状图"];
    UISegmentedControl *sege = [[UISegmentedControl alloc] initWithItems:_graphTypes];
    
    sege.backgroundColor = [UIColor colorWithRed:(21/255.0) green:(126/255.0) blue:(251/255.0) alpha:1.0];
    sege.tintColor = [UIColor whiteColor];
    
    //默认字体颜色
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],
                          NSForegroundColorAttributeName,
                          [UIFont systemFontOfSize:12],
                          NSFontAttributeName,nil];
    
    [sege setTitleTextAttributes:dic1 forState:UIControlStateNormal];
    
    // 添加目标动作对
    [sege addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    sege.frame = CGRectMake(10, 120, self.view.bounds.size.width - 20, 40);
    [self.view addSubview:sege];

    
    CGRect rulerFrame =  CGRectMake(0, 20 + self.view.bounds.size.width, self.view.bounds.size.width, 40);
    RulerView *rulerView = [[RulerView alloc] initWithFrame:rulerFrame];
    rulerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rulerView];
    
    
    //添加鸡汤
    CGRect maximFrame = CGRectMake(0, 60 + self.view.bounds.size.width, self.view.bounds.size.width, 40);
    UILabel *maximLabel = [[UILabel alloc] initWithFrame:maximFrame];
    maximLabel.text = @"ちゃんと見ててよね";
    maximLabel.textColor = [UIColor whiteColor];
    maximLabel.textAlignment = NSTextAlignmentCenter;
    maximLabel.backgroundColor = [UIColor colorWithRed:(21/255.0) green:(126/255.0) blue:(251/255.0) alpha:1.0];
    [self.view addSubview:maximLabel];

}

//根据字典中是否存在相关页面对应的key，没有的话存储
- (NSString *)graphTypeForSegIndex:(NSUInteger)segIndex {
    NSString *keyName = [NSString stringWithFormat:@"%ld",segIndex];
    
    NSString *c = (NSString *)[listDic objectForKey:keyName];
    
    if (!c) {
        if (segIndex == 0) {
            c = @"折线图";
        }else if (segIndex == 1) {
            c = @"柱形图";
        }else{
            c = @"饼状图";
        }
        [listDic setObject:c forKey:keyName];
    }
    
    return c;
}

//点击按钮事件
- (void)segmentValueChanged:(UISegmentedControl *)seg{
    
    NSUInteger segIndex = [seg selectedSegmentIndex];
    NSString *c = [self graphTypeForSegIndex:segIndex];
    NSLog(@"seg.tag-->%ld",segIndex);
    self.chartView.graphType = c;
    [self.chartView setNeedsDisplay];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    //每次打开这个页面都刷新一下
    [self.view setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Home";
        
        // 从文件创建一个UIImage对象，在Retina屏幕上会自动显示Hypno@2x.png
        UIImage *i = [UIImage imageNamed:@"Hypno.png"];
        
        self.tabBarItem.image = i;
    }
    return self;
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
