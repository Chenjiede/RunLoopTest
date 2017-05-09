//
//  AppDelegate.m
//  RunLoopTest
//
//  Created by chen on 2017/5/7.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "CustomRunLoopSourceController.h"

#import "RunLoopContext.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSMutableArray *sourcesToPing;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    /****** 设置不同的根控制器 ******/
    window.rootViewController = [[ViewController alloc] init];
//    window.rootViewController = [[CustomRunLoopSourceController alloc] init];
    
    self.window = window;
    
    [window makeKeyAndVisible];
    
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

#pragma mark - 输入源的注册和移除
- (NSMutableArray *)sourcesToPing {
    if (_sourcesToPing == nil) {
        _sourcesToPing = [NSMutableArray array];
    }
    
    return _sourcesToPing;
}

- (void)registerSource:(RunLoopContext *)sourceInfo {
    
    [self.sourcesToPing addObject:sourceInfo];
}

- (void)removeSource:(RunLoopContext *)sourceInfo {
    id objToRemove = nil;
    
    for (RunLoopContext *context in _sourcesToPing) {
        if ([context isEqual:sourceInfo]) {
            objToRemove = context;
            break;
        }
    }
    
    if (objToRemove) {
        [_sourcesToPing removeObject:objToRemove];
    }
}

@end
