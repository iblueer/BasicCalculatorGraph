//
//  ListViewController.m
//  BasicCalculator
//
//  Created by 宅音かがや on 2018/04/16.
//  Copyright © 2018年 宅音かがや. All rights reserved.
//

#import "AppDelegate.h"
#import "ListViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController

- (void)loadView {
    [super loadView];
    CGRect tableFrame = CGRectMake(0, 120, self.view.bounds.size.width, self.view.bounds.size.height - 140);
    self.dictTable = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.dictTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    // 将当前对象设置为UITableView对象的dataSource
    self.dictTable.dataSource = self;
    
    // 需要创建新的单元格时，告诉UITableView对象要实例化哪个类
    [self.dictTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    // 加入View
    [self.view addSubview:self.dictTable];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dicts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *c = [self.dictTable dequeueReusableCellWithIdentifier:@"Cell"];
    // 获取model数据
    NSString *item = [NSString stringWithFormat:@"%@年%@月 还款 %.2f 元 仍负债 %.2f 元" ,[[self.dicts objectAtIndex:indexPath.row] valueForKey:@"year"], [[self.dicts objectAtIndex:indexPath.row] valueForKey:@"month"], [[[self.dicts objectAtIndex:indexPath.row] valueForKey:@"payment"] floatValue], [[[self.dicts objectAtIndex:indexPath.row] valueForKey:@"debtnow"] floatValue]];
    // 设置cell的文本内容
    c.textLabel.text = item;
    // 返回cell
    return c;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"List";
        UIImage *i = [UIImage imageNamed:@"Hypno.png"];
        self.tabBarItem.image = i;
        
        
        // 检查是否存在一个dicts文件
        NSArray *tempArray = [NSArray arrayWithContentsOfFile:docPathOfDicts()];
        if (tempArray) {
            // 对dicts数组进行排序
            NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"month" ascending:NO];
            NSArray *sortDescriptors = [NSArray arrayWithObjects:sd, nil];
            NSArray *newArray = [tempArray sortedArrayUsingDescriptors:sortDescriptors];
            // 赋值
            self.dicts = [NSMutableArray arrayWithArray:newArray];
            NSLog(@"已从文件读取Dicts数组【并排序】");
        } else {
            self.dicts = [[NSMutableArray alloc] init];
            NSLog(@"已创建全新Dicts数组");
        }
        
        
        
        // 画方块背景
        float width = self.view.bounds.size.width;
        CGRect rectangleFrame = CGRectMake(0, 20, width, 100);
        UIView *rectangleView = [[UIView alloc] initWithFrame:rectangleFrame];
        rectangleView.backgroundColor = [UIColor colorWithRed:(21/255.0) green:(126/255.0) blue:(251/255.0) alpha:1.0];
        [self.view addSubview:rectangleView];
        
        // 添加标题
        // 添加label
        CGRect titleFrame = CGRectMake((width-200)/2, 30, 200, 40);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
        titleLabel.text = @"历史数据清单";
        // 设置文字颜色和排版
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        // 设置边框的圆角和颜色
        titleLabel.layer.cornerRadius = 20;
        titleLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        titleLabel.layer.borderWidth = 1;
        // 设置背景色
        titleLabel.backgroundColor = [UIColor clearColor];
        // 显示
        [rectangleView addSubview:titleLabel];
        
        
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
