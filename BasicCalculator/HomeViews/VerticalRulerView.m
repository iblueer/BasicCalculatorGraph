//
//  VerticalRulerView.m
//  BasicCalculator
//
//  Created by 宅音かがや on 2018/04/16.
//  Copyright © 2018年 宅音かがや. All rights reserved.
//

#import "AppDelegate.h"
#import "VerticalRulerView.h"
#import "CalculatorViewController.h"

@implementation VerticalRulerView

- (void)drawRect:(CGRect)rect {
    // 创建calc对象
    CalculatorViewController *cvc = [[CalculatorViewController alloc] init];
    
    // 检查是否存在一个dicts文件
    NSArray *tempArray = [NSArray arrayWithContentsOfFile:docPathOfDicts()];
    if (tempArray) {
        cvc.dicts = [NSMutableArray arrayWithArray:tempArray];
        NSLog(@"VerticlaRulerView已从文件读取Dicts数组");
    } else {
        cvc.dicts = [[NSMutableArray alloc] init];
        NSLog(@"VerticalRulerView已创建全新Dicts数组");
    }
    // 查看dicts的内容
    NSLog(@"VerticalRulerView得知Dicts中一共有%lu个数据", [cvc.dicts count]);
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
    CGPoint points[11];//12个点的CGPoint数组
    // 创建PointsLeft数组
    CGPoint pointsLeft[11];//12个点的CGPoint数组
    
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    float shortLine = width/2; //12个点，11个线段
    float x = 3*shortLine/2.0;
    float y = 0;
    float add = height/10.0;
    
    for (int i = 0; i< 11; i++,y+=add) {
        points[i] = CGPointMake(x, y);// 赋值
        pointsLeft[i] = CGPointMake(width, y);
    }
    // 列出points数组的内容
    for (int i = 0; i < 11; i++) {
        NSLog(@"VerticalRulerView - (%.2f,%.2f)", points[i].x, points[i].y);
    }
    
    // 画线
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(width, 0)];
    [path addLineToPoint:CGPointMake(width, height)];
    
    // 画刻度
    for (int i = 0; i < 11; i++) {
        [path moveToPoint:points[i]];
        [path addLineToPoint:pointsLeft[i]];
    }
    // 设置画笔颜色
    [[UIColor whiteColor] setStroke];
    // 设置线的粗细
    [path setLineWidth:1];
    // 绘制
    [path stroke];
    
    // 添加刻度文字
    // 创建一个Frame数组
    float value = max;
    for (int i = 0; i < 10; i++,value-=max/10.0) {
        CGRect frame = CGRectMake(points[i].x - 18, points[i].y-5, 20, 15);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.text = [NSString stringWithFormat:@"%.2f",value];
        label.textColor = [UIColor whiteColor];
        label.adjustsFontSizeToFitWidth = YES;
        [self addSubview:label];
    }
}

@end
