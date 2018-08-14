//
//  QuickLookView.m
//  BasicCalculator
//
//  Created by 宅音かがや on 2018/04/16.
//  Copyright © 2018年 宅音かがや. All rights reserved.
//

#import "QuickLookView.h"

@implementation QuickLookView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    // 画边框
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(width/2.0, 0)];
    [path addLineToPoint:CGPointMake(width/2.0 + 10, 10)];
    [path addLineToPoint:CGPointMake(width - 10, 10)];

    [path addArcWithCenter:CGPointMake(width - 10, 20) radius:10 startAngle:-M_PI_2 endAngle:0 clockwise:YES];
    [path moveToPoint:CGPointMake(width, 20)];
    [path addLineToPoint:CGPointMake(width, height -10)];

    [path addArcWithCenter:CGPointMake(width - 10, height - 10) radius:10 startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path moveToPoint:CGPointMake(width - 10, height)];
    [path addLineToPoint:CGPointMake(10, height)];

    [path addArcWithCenter:CGPointMake(10, height - 10) radius:10 startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path moveToPoint:CGPointMake(0, height - 10)];
    [path addLineToPoint:CGPointMake(0, 20)];

    [path addArcWithCenter:CGPointMake(10, 20) radius:10 startAngle:M_PI endAngle:-M_PI_2 clockwise:YES];
    [path moveToPoint:CGPointMake(10, 10)];
    [path addLineToPoint:CGPointMake(width/2.0 - 10, 10)];
    [path addLineToPoint:CGPointMake(width/2.0, 0)];
    
    [path setLineWidth:1];
    [[UIColor colorWithRed:(21/255.0) green:(126/255.0) blue:(251/255.0) alpha:1.0] setStroke];
    [path stroke];
    
    
    // Drawing code
    UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, self.bounds.size.width - 20, 20)];
    monthLabel.text = [NSString stringWithFormat:@"%@月", self.month];
    monthLabel.textColor = [UIColor colorWithRed:(21/255.0) green:(126/255.0) blue:(251/255.0) alpha:1.0];
    [self addSubview:monthLabel];
    
    UILabel *debtLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, self.bounds.size.width - 10, 20)];
    debtLabel.text = [NSString stringWithFormat:@"负债%@元", self.debt];
    debtLabel.textColor = [UIColor colorWithRed:(21/255.0) green:(126/255.0) blue:(251/255.0) alpha:1.0];
    [self addSubview:debtLabel];
}


@end
