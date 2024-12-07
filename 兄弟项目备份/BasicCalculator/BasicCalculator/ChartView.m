//
//  ChartView.m
//  BasicCalculator
//
//  Created by 宅音かがや on 2018/04/09.
//  Copyright © 2018年 宅音かがや. All rights reserved.
//

#import "AppDelegate.h"
#import "ChartView.h"
#import "CalculatorViewController.h"

@implementation ChartView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // 创建calc对象
    CalculatorViewController *cvc = [[CalculatorViewController alloc] init];
    
    // 检查是否存在一个dicts文件
    NSArray *tempArray = [NSArray arrayWithContentsOfFile:docPathOfDicts()];
    if (tempArray) {
        cvc.dicts = [NSMutableArray arrayWithArray:tempArray];
        NSLog(@"ChartView已从文件读取Dicts数组");
    } else {
        cvc.dicts = [[NSMutableArray alloc] init];
        NSLog(@"ChartView已创建全新Dicts数组");
    }
    // 查看dicts的内容
    NSLog(@"ChartView得知Dicts中一共有%lu个数据", [cvc.dicts count]);
    for (NSDictionary *d in cvc.dicts) {
        NSLog(@"%@", d);
    }
    
    // 创建一个12个尺寸的数组，分别存放12个debtnow值，用来当作绘图的y坐标
    // 初始化都是负数，不过没关系，绘制的时候，到当前月份就停止绘制了。
    NSMutableArray *yArray = [[NSMutableArray alloc] initWithArray:@[@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0]];
    // 遍历dicts的每一个dict
    for (NSDictionary *d in cvc.dicts) {
        // 选择出所有本年度的dict
        int dyear = [[d valueForKey:@"year"] intValue];
        // 输出本年的年份
        NSLog(@"cvc.year = %@", cvc.year);
        if (dyear == [cvc.year intValue]) {
            //如果是本年的，那么检测他的月份
            int dmonth = [[d valueForKey:@"month"] intValue];
            //月份-1 就是放入数组yArray的index值
            //将对应的debtnow作为NSNumber对象储存在其中
            //先删除，后添加，这样子顺序不会乱
            [yArray removeObjectAtIndex:(dmonth - 1)];
            [yArray insertObject:[d valueForKey:@"debtnow"] atIndex:(dmonth - 1)];
        }
    }
    // 输出yArray
    for (NSNumber *n in yArray) {
        NSLog(@"%f",[n floatValue]);
    }
    // 建立完成yArray之后，遍历它，找到最大值
    float max = 0;
    for (NSNumber *n in yArray) {
        float y = [n floatValue];
        if (y>max) {
            max = y;
        }
    }
    NSLog(@"max = %.2f", max);
    // 建立一个CGPoint数组
    CGPoint points[12];//12个点的CGPoint数组
    float width = self.bounds.size.width;
    float add = width/11; //12个点，11个线段
    float x = 0;//每次循环不论有没有y，都要增加一个seperate
    for (int i = 0; i< [yArray count]; i++,x+=add) {
        NSNumber *n = [yArray objectAtIndex:i];
        // 按比例计算y坐标。
        float nfloat =[n floatValue];
        float tall = width * nfloat/(2*max);
        float y = width - tall;
        if (y < 0) {
            points[i] = CGPointMake(x, 0);
        } else {
            points[i] = CGPointMake(x, y);;// 赋值
        }
    }
    // 列出points数组的内容
    for (int i = 0; i < 12; i++) {
        NSLog(@"(%.2f,%.2f)", points[i].x, points[i].y);
    }
    
    // 判断graphType属性，没有的话就初始化
    if ([self.graphType isEqualToString:@"折线图"]) {
        
        // 获取数据，画Bezier折线图
        UIBezierPath *path = [[UIBezierPath alloc] init];
        // 画线
        [path moveToPoint:points[0]];
        for (int i = 1; i < 12; i++) {
            [path addLineToPoint:points[i]];
        }
        // 画圈儿
        for (int i = 0; i < 12; i++) {
            [path moveToPoint:points[i]];
            [path addArcWithCenter:points[i] radius:1 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        }
        // 设置画笔颜色
        [[UIColor whiteColor] setStroke];
        // 设置线的粗细
        [path setLineWidth:1];
        // 绘制
        [path stroke];
    } else if ([self.graphType isEqualToString:@"柱形图"]) {
        
        // 获取数据，画Bezier折线图
        UIBezierPath *path = [[UIBezierPath alloc] init];
        // 创建PointsDown数组
        CGPoint pointsDown[12];//12个点的CGPoint数组
        float width = self.bounds.size.width;
        float add = width/11; //12个点，11个线段
        float x = 0;//每次循环不论有没有y，都要增加一个seperate
        for (int i = 0; i< 12; i++,x+=add) {
            pointsDown[i] = CGPointMake(x, self.bounds.size.height);// 赋值
        }
        // 画柱子
        for (int i = 0; i < 12; i++) {
            [path moveToPoint:points[i]];
            [path addLineToPoint:pointsDown[i]];
        }
        
        // 设置画笔颜色
        [[UIColor whiteColor] setStroke];
        // 设置线的粗细
        [path setLineWidth:10];
        // 绘制
        [path stroke];
    }
    
    // 添加label
    CGRect titleFrame = CGRectMake((width-200)/2, 30, 200, 40);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
    titleLabel.text = self.graphType;
    // 设置文字颜色和排版
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    // 设置边框的圆角和颜色
    titleLabel.layer.cornerRadius = 20;
    titleLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    titleLabel.layer.borderWidth = 1;
    // 设置背景色
    titleLabel.backgroundColor = [UIColor colorWithRed:(21/255.0) green:(126/255.0) blue:(251/255.0) alpha:1.0];
    // 显示
    [self addSubview:titleLabel];
}


@end
