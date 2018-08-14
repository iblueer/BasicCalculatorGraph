//
//  ChartView.m
//  BasicCalculator
//
//  Created by 宅音かがや on 2018/04/09.
//  Copyright © 2018年 宅音かがや. All rights reserved.
//


#import "ChartView.h"
#import <math.h>


@implementation ChartView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
#pragma mark - 计算
    // 创建calc对象
    self.cvc = [[CalculatorViewController alloc] init];
    
    // 检查是否存在一个dicts文件
    NSArray *tempArray = [NSArray arrayWithContentsOfFile:docPathOfDicts()];
    if (tempArray) {
        self.cvc.dicts = [NSMutableArray arrayWithArray:tempArray];
        NSLog(@"ChartView已从文件读取Dicts数组");
    } else {
        self.cvc.dicts = [[NSMutableArray alloc] init];
        NSLog(@"ChartView已创建全新Dicts数组");
    }
    // 查看dicts的内容
    NSLog(@"ChartView得知Dicts中一共有%lu个数据", [self.cvc.dicts count]);
    for (NSDictionary *d in self.cvc.dicts) {
        NSLog(@"%@", d);
    }
    
    //创建两个float值，保存allDecrease和allInterest
    float allDecrease = 0;
    float allInterest = 0;
    float allPayment = 0;
    
    // 创建一个12个尺寸的数组，分别存放12个debtnow值，用来当作绘图的y坐标
    // 初始化都是负数，不过没关系，绘制的时候，到当前月份就停止绘制了。
    NSMutableArray *yArray = [[NSMutableArray alloc] initWithArray:@[@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0]];
    // 遍历dicts的每一个dict
    for (NSDictionary *d in self.cvc.dicts) {
        // 选择出所有本年度的dict
        int dyear = [[d valueForKey:@"year"] intValue];
        // 输出本年的年份
        NSLog(@"cvc.year = %@", self.cvc.year);
        if (dyear == [self.cvc.year intValue]) {
            //如果是本年的，那么检测他的月份
            int dmonth = [[d valueForKey:@"month"] intValue];
            //月份-1 就是放入数组yArray的index值
            //将对应的debtnow作为NSNumber对象储存在其中
            //先删除，后添加，这样子顺序不会乱
            [yArray removeObjectAtIndex:(dmonth - 1)];
            [yArray insertObject:[d valueForKey:@"debtnow"] atIndex:(dmonth - 1)];
        }
        // 计算本金和利息的和
        allDecrease += [[d valueForKey:@"decrease"] floatValue];
        allInterest += [[d valueForKey:@"interest"] floatValue];
    }
    // 计算总支出
    allPayment = allDecrease + allInterest;
    NSLog(@"allPayment is %.2f, allDecrease is %.2f, allInterest is %.2f.", allPayment, allDecrease, allInterest);
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
    // 创建PointsDown数组
    CGPoint pointsDown[12];//12个点的CGPoint数组
    
    float width = self.bounds.size.width;
    float add = width/13; //12个点，11个线段
    float x = add;//每次循环不论有没有y，都要增加一个seperate
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
        pointsDown[i] = CGPointMake(x, self.bounds.size.height);// 赋值
    }
    // 列出points数组的内容
    for (int i = 0; i < 12; i++) {
        NSLog(@"(%.2f,%.2f)", points[i].x, points[i].y);
    }
/*-----------------------画图-----------------------*/
#pragma mark - 画图
    // 添加label
    CGRect titleFrame = CGRectMake((width-200)/2, 50, 200, 40);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
    titleLabel.text = [NSString stringWithFormat:@"每月负债%@", self.graphType];
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
    [self.superview addSubview:titleLabel];
    
    // 添加小刻度View
    CGRect verticalRulerFrame = CGRectMake(0, width/2.0, width/13.0 - 4, width/2.0);
    self.verticalRulerView = [[VerticalRulerView alloc] initWithFrame:verticalRulerFrame];
    self.verticalRulerView.backgroundColor = [UIColor colorWithRed:(21/255.0) green:(126/255.0) blue:(251/255.0) alpha:1.0];
    
    UIView *coverView = [[UIView alloc] initWithFrame:verticalRulerFrame];
    coverView.backgroundColor = self.verticalRulerView.backgroundColor;
    
    
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
        [self addSubview:self.verticalRulerView];
    } else if ([self.graphType isEqualToString:@"柱形图"]) {
        
        // 获取数据，画Bezier折线图
        UIBezierPath *path = [[UIBezierPath alloc] init];
        
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
        [self addSubview:self.verticalRulerView];
    } else if ([self.graphType isEqualToString:@"饼状图"]) {
        [self addSubview:coverView];
        
//        // 画矩形
//        UIBezierPath *rectangle = [[UIBezierPath alloc] init];
//        [rectangle moveToPoint:verticalRulerFrame.origin];
//        [rectangle addLineToPoint:CGPointMake(verticalRulerFrame.origin.x + verticalRulerFrame.size.width, 0)];
//        [rectangle addLineToPoint:CGPointMake(verticalRulerFrame.origin.x + verticalRulerFrame.size.width, verticalRulerFrame.origin.y + verticalRulerFrame.size.height)];
//        [rectangle addLineToPoint:CGPointMake(0, verticalRulerFrame.origin.y + verticalRulerFrame.size.height)];
//        [rectangle addLineToPoint:verticalRulerFrame.origin];
//        [[UIColor colorWithRed:(21/255.0) green:(126/255.0) blue:(251/255.0) alpha:1.0] setFill];
//        [rectangle fill];
        
        // 画饼
        UIBezierPath *path = [[UIBezierPath alloc] init];
        CGPoint circleCenter = CGPointMake(width/2.0,(width + 140)/2.0);
        float radius = (width - 140)/2.0 - 20;
        [path moveToPoint:CGPointMake(circleCenter.x + radius, circleCenter.y)];
        [path addArcWithCenter:circleCenter radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        [[UIColor whiteColor] setFill];
        [path fill];
        // 画扇形
        UIBezierPath *fan = [[UIBezierPath alloc] init];
        [fan moveToPoint:circleCenter];
        [fan addLineToPoint:CGPointMake(circleCenter.x, circleCenter.y - radius + 1)];
        [fan addArcWithCenter:circleCenter radius:radius - 1 startAngle:0 - M_PI_2 endAngle:(allInterest / allPayment) * 2 * M_PI - M_PI_2 clockwise:YES];
        [fan addLineToPoint:circleCenter];
        [[UIColor colorWithRed:(21/255.0) green:(126/255.0) blue:(251/255.0) alpha:1.0] setFill];
        [fan fill];
        // 添加箭头1
        UIBezierPath *arrow = [[UIBezierPath alloc] init];
        CGPoint startPoint1 = CGPointMake(circleCenter.x + 5, circleCenter.y - radius + 40);
        CGPoint endPoint1 = CGPointMake(startPoint1.x + radius,startPoint1.y);

        
        [arrow addArcWithCenter:startPoint1 radius:1 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        [arrow moveToPoint:startPoint1];
        [arrow addLineToPoint:endPoint1];
        
        [[UIColor whiteColor] setStroke];
        [arrow stroke];
        
        
        // 添加箭头2
        UIBezierPath *arrow2 = [[UIBezierPath alloc] init];
        CGPoint startPoint2 = CGPointMake(circleCenter.x - 5, circleCenter.y - radius + 20);
        CGPoint endPoint2 = CGPointMake(startPoint2.x - radius, startPoint2.y);
        
        [arrow2 moveToPoint:startPoint2];
        [arrow2 addArcWithCenter:startPoint2 radius:1 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        [arrow2 moveToPoint:startPoint2];
        [arrow2 addLineToPoint:endPoint2];
        [[UIColor colorWithRed:(21/255.0) green:(126/255.0) blue:(251/255.0) alpha:1.0] setStroke];
        [arrow2 stroke];
        
        // 添加箭头2的追加部分
        UIBezierPath *arrow3 = [[UIBezierPath alloc] init];
        CGPoint startPoint3 = CGPointMake(circleCenter.x - sqrt(20*(width - 200)), circleCenter.y - radius + 20);
        [arrow3 moveToPoint:startPoint3];
        [arrow3 addLineToPoint:endPoint2];
        [[UIColor whiteColor] setStroke];
        [arrow3 stroke];
        
        
        
        // 添加文字说明
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold"size:9.0f];
        UIColor *color = [UIColor whiteColor];
        
        NSString *allInterestString = [NSString stringWithFormat:@"总手续费 %.2f 元",allInterest];
        NSString *allInterestPercentString = [NSString stringWithFormat:@"占总支出 %.2f",allInterest/allPayment];
        NSString *allDecreaseString = [NSString stringWithFormat:@"总减少债务 %.2f 元", allDecrease];
        NSString *allDecreasePercentString = [NSString stringWithFormat:@"占总支出 %.2f", allDecrease/allPayment];
        
        [allInterestString drawInRect:CGRectMake(endPoint1.x, endPoint1.y - 10, 80, 10)
                       withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
        [allInterestPercentString drawInRect:CGRectMake(endPoint1.x, endPoint1.y + 10, 80, 10)
                              withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
        [allDecreaseString drawInRect:CGRectMake(endPoint2.x - 80, endPoint2.y - 10, 100, 10)
                       withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
        [allDecreasePercentString drawInRect:CGRectMake(endPoint2.x - 80, endPoint2.y + 10, 100, 10)
                              withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];


    }
    
    
    
    

}
/*-----------------------触摸-----------------------*/
#pragma mark - 触摸
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 得到一个数组
    CGRect rects[12];//12个点的CGPoint数组
    float width = self.bounds.size.width;
    float add = width/13; //12个点，11个线段
    float x = add;//每次循环不论有没有y，都要增加一个seperate
    for (int i = 0; i< 12; i++,x+=add) {
        rects[i] = CGRectMake(x-add/2.0, 0, add, width);
    }
    
    // 开始触摸，识别触摸坐标，根据x坐标来判断显示内容
    
    // 判断触摸坐标
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    // 对x坐标进行处理，划分成几个区域
    int touchingMonth = 0;
    
    // 遍历rects数组，判断包含关系
    for(int i = 0; i < 12; i++) {
        CGRect currentRect = rects[i];
        BOOL contains = CGRectContainsPoint(currentRect, touchPoint);
        if (contains) {
            touchingMonth = i+1;
        }
    }
    
    // 更新touchingMonth之后，得到对应的负债金额
    // 将它作为参数传入QuickLookView
    float debtOfTheMonth = 0;
    
    // 查看dicts的内容
    NSLog(@"ChartView得知Dicts中一共有%lu个数据", [self.cvc.dicts count]);
    for (NSDictionary *d in self.cvc.dicts) {
        NSLog(@"%@", d);
    }
    
    // 遍历dicts，找到month对应的dict
    for (NSDictionary *d in self.cvc.dicts) {
        // 选择出所有本年度的dict
        int dyear = [[d valueForKey:@"year"] intValue];
        // 输出本年的年份
        NSLog(@"cvc.year = %@", self.cvc.year);
        if (dyear == [self.cvc.year intValue]) {
            //如果是本年的，那么检测他的月份
            int dmonth = [[d valueForKey:@"month"] intValue];
            //判断是否是同一月份
            if (dmonth == touchingMonth) {
                debtOfTheMonth =  [[d valueForKey:@"debtnow"] floatValue];
                NSLog(@"debtOf %d month is %.2f", dmonth, [[d valueForKey:@"debtnow"] floatValue]);
            }
        }
    }
    
    // 显示内容
    NSLog(@"ChartView Touches began.");
    self.qlv = [[QuickLookView alloc] initWithFrame:CGRectMake((width - 140)/2.0, width +100 , 140, 100)];
    // 配置qlv的两个参数：月份、当前负债金额
    self.qlv.month = [NSString stringWithFormat:@"%d", touchingMonth];
    self.qlv.debt = [NSString stringWithFormat:@"%.2f", debtOfTheMonth];
    self.qlv.backgroundColor = [UIColor whiteColor];
    [self.superview addSubview:self.qlv];
    
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 结束触摸，不再显示内容
    NSLog(@"ChartView Touches ended.");
    [self.qlv removeFromSuperview];
}

@end
