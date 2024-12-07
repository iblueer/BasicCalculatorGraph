//
//  CalculatorViewController.h
//  BasicCalculator
//
//  Created by 宅音かがや on 2018/04/08.
//  Copyright © 2018年 宅音かがや. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController
//data
@property (nonatomic) NSNumber *totalNow;//一个可变字符串，只用来储存当前的total，自动储存
@property (nonatomic) NSMutableArray *dicts;//一个可变数组，用来储存下面所有信息组成的一个NSDict对象
@property (nonatomic) NSDictionary *dict;//一个字典，用来储存下面所有内容组成的一条信息

// date_mark
@property (nonatomic) NSNumber *year; //年份
@property (nonatomic) NSNumber *month; //月份

// model
@property (nonatomic) float total; //总额度
@property (nonatomic) float debtold; //原有债务
@property (nonatomic) float payment; //支付金额
@property (nonatomic) float usable; //当前可用额度
@property (nonatomic) float decrease; //债务消除（本金）
@property (nonatomic) float interest; //手续费（利息）
@property (nonatomic) float debtnow; //当前债务

// view
@property (nonatomic) IBOutlet UITextField *debtoldField;
@property (nonatomic) IBOutlet UITextField *paymentField;
@property (nonatomic) IBOutlet UITextField *usableField;

@property (nonatomic) IBOutlet UILabel *decreaseLabel;
@property (nonatomic) IBOutlet UILabel *interestLabel;

// controller
- (void)inputTotal;//弹窗要求输入total

// method

- (NSString *)getDocPathOfTotalNow;
- (NSString *)getDocPathOfDicts;

@end
