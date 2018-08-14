//
//  AppDelegate.m
//  BasicCalculator
//
//  Created by 宅音かがや on 2018/04/08.
//  Copyright © 2018年 宅音かがや. All rights reserved.
//

#import "AppDelegate.h"
#import "CalculatorViewController.h"
#import "HomeViewController.h"
#import "SettingViewController.h"
#import "ListViewController.h"


#pragma mark -  实现辅助函数
NSString *docPathOfTotalNow(void) {
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [pathList[0] stringByAppendingPathComponent:@"totalNow.td"];
}

NSString *docPathOfDicts(void) {
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [pathList[0] stringByAppendingPathComponent:@"dicts.td"];
}


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    CalculatorViewController *cvc = [[CalculatorViewController alloc] init];
    HomeViewController *hvc = [[HomeViewController alloc] init];
    ListViewController *lvc = [[ListViewController alloc] init];
    SettingViewController *svc = [[SettingViewController alloc] init];
    
    
    UITabBarController *tabvc = [[UITabBarController alloc] init];
    tabvc.viewControllers = @[cvc,hvc,lvc,svc];
    
    self.window.rootViewController = tabvc;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
