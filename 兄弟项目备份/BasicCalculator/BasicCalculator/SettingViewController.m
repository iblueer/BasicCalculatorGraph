//
//  SettingViewController.m
//  BasicCalculator
//
//  Created by 宅音かがや on 2018/04/09.
//  Copyright © 2018年 宅音かがや. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingViewController.h"
#import "AboutView.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 重写init方法

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Setting";
        UIImage *i = [UIImage imageNamed:@"Hypno.png"];
        self.tabBarItem.image = i;
        
        // 插入子View
        float width = self.view.bounds.size.width;
        CGRect aboutFrame = CGRectMake(0, 20, width, width * 0.75);
        AboutView *aboutView = [[AboutView alloc] initWithFrame:aboutFrame];
        aboutView.backgroundColor = [UIColor colorWithRed:(21/255.0) green:(126/255.0) blue:(251/255.0) alpha:1.0];
        [self.view addSubview:aboutView];
        
        // 添加按钮
        CGRect buttonFrame = CGRectMake((width - 100)/2, width+20, 100, 20);
        UIButton *changeTotal = [[UIButton alloc]initWithFrame:buttonFrame];
        [changeTotal setTitle:@"修改总额度" forState:UIControlStateNormal];
        [changeTotal setTitleColor:[UIColor colorWithRed:(21/255.0) green:(126/255.0) blue:(251/255.0) alpha:1.0] forState:UIControlStateNormal];
        [changeTotal setTitleColor:[UIColor grayColor] forState:UIControlStateFocused | UIControlStateSelected];
        [self.view addSubview:changeTotal];
        //    Button监听事件，非常重要
        /**
         *addTarget:目标（让谁做这个事情）
         *action:方法（做什么事情-->方法）
         *forControlEvents:事件
         */
        [changeTotal addTarget:self action:@selector(changeTotalClicked:) forControlEvents:UIControlEventTouchUpInside];

        
        //添加鸡汤
        CGRect maximFrame = CGRectMake(0, 60 + self.view.bounds.size.width, self.view.bounds.size.width, 40);
        UILabel *maximLabel = [[UILabel alloc] initWithFrame:maximFrame];
        maximLabel.text = @"どこかに行っちゃうよ";
        maximLabel.textColor = [UIColor whiteColor];
        maximLabel.textAlignment = NSTextAlignmentCenter;
        maximLabel.backgroundColor = [UIColor colorWithRed:(21/255.0) green:(126/255.0) blue:(251/255.0) alpha:1.0];
        [self.view addSubview:maximLabel];
        
        // 初始化cvc
        self.cvc = [[CalculatorViewController alloc] init];
    }
    return self;
}

#pragma mark - 按钮事件
-(void)changeTotalClicked:(UIButton *) button{
    NSLog(@"%@",button);
    [self changeTotal];
    [self.view setNeedsDisplay];
}

- (void)changeTotal {
    // 提示设置total
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入新的总额度" message:@"应用重启后生效" preferredStyle:UIAlertControllerStyleAlert];
    //增加确定按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //获取第1个输入框；
        UITextField *userNameTextField = alertController.textFields.firstObject;
        // 获取结果
        NSLog(@"文本框输入 = %@",userNameTextField.text);
        self.cvc.total = [alertController.textFields.firstObject.text floatValue];
        NSLog(@"total = %.2f", self.cvc.total);
        // 将结果保存到字符串
        if (!self.cvc.totalNow) {
            self.cvc.totalNow = [NSNumber numberWithFloat:self.cvc.total];
        } else {
            self.cvc.totalNow = nil;
            self.cvc.totalNow = [NSNumber numberWithFloat:self.cvc.total];
        }
        // 将字符串写入到文件
        [self.cvc.totalNow.stringValue writeToFile:docPathOfTotalNow() atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"已将totalNow写入到文件");
    }]];
    
    //增加取消按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    //定义第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = [NSString stringWithFormat:@"%.2f", self.cvc.total];
    }];
    
    [self presentViewController:alertController animated:true completion:nil];
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
