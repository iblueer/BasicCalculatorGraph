//
//  CalculatorViewController.m
//  BasicCalculator
//
//  Created by 宅音かがや on 2018/04/08.
//  Copyright © 2018年 宅音かがや. All rights reserved.
//

#import "CalculatorViewController.h"
#import "AppDelegate.h"

#pragma mark -  实现辅助函数
NSString *docPathOfTotalNow(void) {
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [pathList[0] stringByAppendingPathComponent:@"totalNow.td"];
}

NSString *docPathOfDicts(void) {
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [pathList[0] stringByAppendingPathComponent:@"dicts.td"];
}

@interface CalculatorViewController ()

@end

@implementation CalculatorViewController

#pragma mark - 默认方法

- (void)viewDidLoad {
    [super viewDidLoad];
    // 检查是否存在一个totalNow文件
    NSString *temp = [NSString stringWithContentsOfFile:self.getDocPathOfTotalNow encoding:NSUTF8StringEncoding error:nil];
    if (temp) {
        self.totalNow = [temp mutableCopy];
        self.total = [self.totalNow floatValue];
        NSLog(@"已从文件读取totalNow");
    } else {
        self.totalNow = nil;
        self.total = 0;
    }
    // 检查是否存在一个dicts文件
    NSArray *tempArray = [NSArray arrayWithContentsOfFile:self.getDocPathOfDicts];
    if (tempArray) {
        self.dicts = [NSMutableArray arrayWithArray:tempArray];
        NSLog(@"已从文件读取Dicts数组");
    } else {
        self.dicts = [[NSMutableArray alloc] init];
        NSLog(@"已创建全新Dicts数组");
    }
    // 查看dicts的内容
    NSLog(@"Dicts中一共有%lu个数据", [self.dicts count]);
    for (NSDictionary *d in self.dicts) {
        NSLog(@"%@", d);
    }
    // 对cvc进行一次初始化
    self.debtold = 0;
    self.payment = 0;
    self.usable = 0;
    self.decrease = 0;
    self.interest = 0;
    self.debtnow = 0;
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

#pragma mark - IBActions

- (IBAction)calculate:(id)sender {
    if (self.total == 0) {
        [self inputTotal];
    } else if ([self.paymentField.text isEqualToString:@""]){
        // 无响应
        [self inputNumbers];
    } else {
        // get
        self.debtold = [self.debtoldField.text floatValue];
//        NSLog(@"debtold = %.2f", self.debtold);
        self.payment = [self.paymentField.text floatValue];
//        NSLog(@"payment = %.2f", self.payment);
        self.usable = [self.usableField.text floatValue];
//        NSLog(@"usable = %.2f", self.usable);
        // calculate
        self.debtnow = self.total - self.usable;
//        NSLog(@"debtnow = %.2f", self.debtnow);
        self.decrease = self.debtold - self.debtnow;
//        NSLog(@"decrease = %.2f", self.decrease);
        self.interest = self.payment - self.decrease;
//        NSLog(@"interest = %.2f", self.interest);
        // show
        self.decreaseLabel.text = [NSString stringWithFormat:@"%.2f", self.decrease];
        self.interestLabel.text = [NSString stringWithFormat:@"%.2f", self.interest];
        // 收起键盘
        [self.paymentField resignFirstResponder];
        [self.debtoldField resignFirstResponder];
        [self.usableField resignFirstResponder];
    }
}

- (IBAction)saveResult:(id)sender {
    // 检测是否有输入结果
    if (self.payment == 0) {
        // 无响应
        [self inputNumbers];
    } else {
        // 获取年月
        NSDate *now = [NSDate date];
        NSCalendar *cal = [NSCalendar currentCalendar];
        unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth;
        NSDateComponents *dd = [cal components:unitFlags fromDate:now];
        self.year = [NSNumber numberWithInteger:[dd year]]; // 强制类型转换，从long int 到 int
        self.month = [NSNumber numberWithInteger:[dd month]];
        // 获取响应结果，并保存到dict中
        self.dict = @{
                      @"year":self.year,
                      @"month":self.month,
                      @"debtold":[NSNumber numberWithFloat:self.debtold],
                      @"payment":[NSNumber numberWithFloat:self.payment],
                      @"usable":[NSNumber numberWithFloat:self.usable],
                      @"decrease":[NSNumber numberWithFloat:self.decrease],
                      @"interest":[NSNumber numberWithFloat:self.interest],
                      @"debtnow":[NSNumber numberWithFloat:self.debtnow],
                      };
        //----清除掉同一个月份的数据----
        //一会儿会用dicts的内容覆盖掉dicts.dt的内容，所以随便搞。
        //遍历dicts数组，对每个dict进行key遍历，找到year=self.year;month=self.month的一个dict，删掉他
        //然后用新的数据代替旧的数据
        for (int i = 0; i < [self.dicts count]; i++) {
            NSDictionary *d = self.dicts[i];
            bool sameYear = [[[d valueForKey:@"year"] stringValue] isEqualToString:[self.year stringValue]];
            bool sameMonth = [[[d valueForKey:@"month"] stringValue] isEqualToString:[self.month stringValue]];
            if (sameYear && sameMonth) {
                [self.dicts removeObject:d];
            }
        }
        
        //----将dict加入到dicts中----
        [self.dicts addObject:[self.dict copy]];
        // 查看dicts的内容
        NSLog(@"Dicts中一共有%lu个数据", [self.dicts count]);
        for (NSDictionary *d in self.dicts) {
            NSLog(@"%@", d);
        }
        
        
        
        //----将dicts写入到文件----
        [self.dicts writeToFile:self.getDocPathOfDicts atomically:YES];
        NSLog(@"已将Dicts写入到文件");
 
    }
}

#pragma mark - 弹窗方法

- (void)inputTotal {
    // 提示设置total
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请输入总额度后再计算" preferredStyle:UIAlertControllerStyleAlert];
    //增加确定按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //获取第1个输入框；
        UITextField *userNameTextField = alertController.textFields.firstObject;
        // 获取结果
        NSLog(@"文本框输入 = %@",userNameTextField.text);
        self.total = [alertController.textFields.firstObject.text floatValue];
        NSLog(@"total = %.2f", self.total);
        // 将结果保存到字符串
        if (!self.totalNow) {
            self.totalNow = [NSNumber numberWithFloat:self.total];
        } else {
            self.totalNow = nil;
            self.totalNow = [NSNumber numberWithFloat:self.total];
        }
        // 将字符串写入到文件
        [self.totalNow.stringValue writeToFile:self.getDocPathOfTotalNow atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"已将totalNow写入到文件");
    }]];
    
    //增加取消按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    //定义第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入总额度";
    }];
    
    [self presentViewController:alertController animated:true completion:nil];
}


- (void)inputNumbers {
    // 提示设置total
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请输入全部数值后再计算" preferredStyle:UIAlertControllerStyleAlert];
    //增加确定按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:true completion:nil];
}


#pragma mark - 辅助函数方法

- (NSString *)getDocPathOfTotalNow {
    return docPathOfTotalNow();
}

- (NSString *)getDocPathOfDicts {
    return docPathOfDicts();
}

#pragma mark - 重写init方法

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Calculator";
        UIImage *i = [UIImage imageNamed:@"Hypno.png"];
        self.tabBarItem.image = i;
    }
    return self;
}

@end
