//
//  ChartView.h
//  BasicCalculator
//
//  Created by 宅音かがや on 2018/04/09.
//  Copyright © 2018年 宅音かがや. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "QuickLookView.h"
#import "CalculatorViewController.h"
#import "VerticalRulerView.h"


@interface ChartView : UIView

@property (nonatomic) CalculatorViewController *cvc;

@property (nonatomic) NSString *graphType;

@property (nonatomic) QuickLookView *qlv;

@property (nonatomic) VerticalRulerView *verticalRulerView;

@end
