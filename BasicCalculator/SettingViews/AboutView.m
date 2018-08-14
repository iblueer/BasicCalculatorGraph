//
//  AboutView.m
//  BasicCalculator
//
//  Created by 宅音かがや on 2018/04/09.
//  Copyright © 2018年 宅音かがや. All rights reserved.
//

#import "AppDelegate.h"
#import "AboutView.h"
#import "CalculatorViewController.h"

@implementation AboutView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // 添加标题
    float width = self.bounds.size.width;
    CGRect titleFrame = CGRectMake((width-200)/2, 30, 200, 40);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
    titleLabel.text = @"设置和关于程序";
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
    [self addSubview:titleLabel];
    
    // 添加logo
    CGRect imageFrame = CGRectMake(50, 110, 100, 100);
    UIImage *logoImage = [UIImage imageNamed:@"460_460.png"];
    [logoImage drawInRect:imageFrame];
    
    // 添加文字
    CGRect appNameFrame = CGRectMake(180, 120, 100, 30);
    UILabel *appNameLabel = [[UILabel alloc] initWithFrame:appNameFrame];
    appNameLabel.text = @"花计";
    appNameLabel.textColor = [UIColor whiteColor];
    appNameLabel.textAlignment = NSTextAlignmentLeft;
    appNameLabel.font = [UIFont fontWithName:@"Arial" size:30];
    [self addSubview:appNameLabel];
    
    CGRect appVersionFrame = CGRectMake(180, 160, 100, 20);
    UILabel *appVersionLabel = [[UILabel alloc] initWithFrame:appVersionFrame];
    appVersionLabel.text = @"V3.14";
    appVersionLabel.textColor = [UIColor whiteColor];
    appVersionLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:appVersionLabel];
    
    CGRect appHomepageFrame = CGRectMake(180, 185, 200, 20);
    UILabel *appHomepageLabel = [[UILabel alloc] initWithFrame:appHomepageFrame];
    appHomepageLabel.text = @"www.maemo.cc";
    appHomepageLabel.textColor = [UIColor whiteColor];
    appHomepageLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:appHomepageLabel];
    
    // 当前总额度
    CalculatorViewController *cvc = [[CalculatorViewController alloc] init];
    // 检查是否存在一个totalNow文件
    NSString *temp = [NSString stringWithContentsOfFile:docPathOfTotalNow() encoding:NSUTF8StringEncoding error:nil];
    if (temp) {
        cvc.totalNow = [temp mutableCopy];
        cvc.total = [cvc.totalNow floatValue];
        NSLog(@"AboutView已从文件读取totalNow");
        NSLog(@"totalNow = %.2f", cvc.total);
    } else {
        cvc.totalNow = nil;
        cvc.total = 0;
    }
    
    // 显示总额度
    CGRect totalFrame =  CGRectMake((width - 200)/2.0, 235, 200, 20);
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:totalFrame];
    totalLabel.text = [NSString stringWithFormat:@"当前总额度：%.2f", cvc.total];
    totalLabel.textColor = [UIColor whiteColor];
    totalLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:totalLabel];
}


@end
