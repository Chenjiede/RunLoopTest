//
//  RunLoopSource.m
//  加载大图
//
//  Created by chen on 2017/4/18.
//  Copyright © 2017年 H. All rights reserved.
//

#import "RunLoopSource.h"

#import "AppDelegate.h"
#import "RunLoopContext.h"

@implementation RunLoopSource

- (instancetype)init {
    if (self = [super init]) {
        
        CFRunLoopSourceContext context = {0, (__bridge void *)(self), NULL, NULL, NULL, NULL,
                                        NULL, &RunLoopSourceScheduleRoutine, RunLoopSourceCancleRoutine, RunLoopSourcePerformRooutine };
        
        // 初始化输入源
        runLoopSource = CFRunLoopSourceCreate(NULL, 0, &context);
        
        commands = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)invalidate {
    NSLog(@"invalidate");
    
    CFRunLoopRemoveSource(_runLoop, runLoopSource, kCFRunLoopDefaultMode);
}

- (void)addCommand:(NSUInteger)command withData:(id)data {
    
}

/// 添加输入源到runloop
- (void)addToCurrentRunLoop {
    
    NSLog(@"addToCurrentRunLoop -- %@", [NSThread currentThread]);
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    
    CFRunLoopAddSource(runLoop, runLoopSource, kCFRunLoopDefaultMode);
    _runLoop = runLoop;
    CFRunLoopRun();
    
    NSLog(@"stop -------- ");
}

- (void)sourceFired {
    NSLog(@"sourceFired -- %@", [NSThread currentThread]);
}

/// 显式唤醒runloop，当客户端准备好处理加入缓冲区的命令后会调用此方法
- (void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runloop {
    NSLog(@"fireAllCommandsOnRunLoop");
    CFRunLoopSourceSignal(runLoopSource);
    
    CFRunLoopWakeUp(runloop);
}

- (void)fireAllCommands {
    NSLog(@"fireAllCommands");
    CFRunLoopSourceSignal(runLoopSource);
    
    CFRunLoopWakeUp(_runLoop);
}

#pragma mark - RunLoopSource
/// 将输入源添加到runloop的回调
void RunLoopSourceScheduleRoutine(void *info, CFRunLoopRef rl, CFStringRef mode) {
    NSLog(@"RunLoopSourceScheduleRoutine");
    // 转换成OC对象
    RunLoopSource *obj = (__bridge RunLoopSource *)info;
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    RunLoopContext *context = [[RunLoopContext alloc] initWithSource:obj andLoop:rl];
    
    [delegate performSelectorOnMainThread:@selector(registerSource:) withObject:context waitUntilDone:NO];
}

/// 输入源被告知时用来处理自定义数据的回调例程
void RunLoopSourcePerformRooutine(void *info) {
    NSLog(@"RunLoopSourcePerformRooutine");
    RunLoopSource *obj = (__bridge RunLoopSource *)info;
    
    [obj sourceFired];
}

/// 将输入源从runloop移除的回调
void RunLoopSourceCancleRoutine(void *info, CFRunLoopRef rl, CFStringRef mode) {
    NSLog(@"RunLoopSourceCancleRoutine");
    // 转换成OC对象
    RunLoopSource *obj = (__bridge RunLoopSource *)info;
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    RunLoopContext *context = [[RunLoopContext alloc] initWithSource:obj andLoop:rl];
    
    [delegate performSelectorOnMainThread:@selector(removeSource:) withObject:context waitUntilDone:YES];
}
@end
