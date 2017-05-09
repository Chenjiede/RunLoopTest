//
//  AppDelegate.h
//  RunLoopTest
//
//  Created by chen on 2017/5/7.
//  Copyright © 2017年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RunLoopContext;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)registerSource:(RunLoopContext *)sourceInfo;

- (void)removeSource:(RunLoopContext *)sourceInfo;
@end

