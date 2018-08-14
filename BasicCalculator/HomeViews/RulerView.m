//
//  RulerView.m
//  BasicCalculator
//
//  Created by 宅音かがや on 2018/04/09.
//  Copyright © 2018年 宅音かがや. All rights reserved.
//

#import "RulerView.h"

@implementation RulerView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGPoint points[12];//12个点的CGPoint数组
    CGPoint pointsDown[12];
    float width = self.bounds.size.width;
    float add = width/13; //12个点，11个线段
    float x = add;//每次循环不论有没有y，都要增加一个seperate
    for (int i = 0; i< 12; i++,x+=add) {
        points[i] = CGPointMake(x, 0);// 赋值
        pointsDown[i] = CGPointMake(x, 10);
    }
    
    // 画线
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(width, 0)];
    
    // 画刻度
    for (int i = 0; i < 12; i++) {
        [path moveToPoint:points[i]];
        [path addLineToPoint:pointsDown[i]];
    }
    // 设置画笔颜色
    [[UIColor colorWithRed:(21/255.0) green:(126/255.0) blue:(251/255.0) alpha:1.0] setStroke];
    // 设置线的粗细
    [path setLineWidth:1];
    // 绘制
    [path stroke];
    
    // 添加刻度文字
    for (int i = 0; i < 12; i++) {
        CGRect frame = CGRectMake(pointsDown[i].x - 10, pointsDown[i].y + 5, 20, 10);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.text = [NSString stringWithFormat:@"%d月",i+1];
        label.textColor = [UIColor colorWithRed:(21/255.0) green:(126/255.0) blue:(251/255.0) alpha:1.0];
        label.adjustsFontSizeToFitWidth = YES;
        [self addSubview:label];
    }
    // 创建完后，依次创建uilabel上去
    
    
}


@end
