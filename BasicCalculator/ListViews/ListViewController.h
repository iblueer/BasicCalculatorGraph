//
//  ListViewController.h
//  BasicCalculator
//
//  Created by 宅音かがや on 2018/04/16.
//  Copyright © 2018年 宅音かがや. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController <UITableViewDataSource>

// View
@property (nonatomic) UITableView *dictTable;

// Model
@property (nonatomic) NSMutableArray *dicts;

@end
