//
//  ViewController.m
//  RunLoopTest
//
//  Created by chen on 2017/5/7.
//  Copyright © 2017年 chen. All rights reserved.
//

/**
 *  开启子线程的RunLoop
 *  注册观察者
 */
#import "ViewController.h"

@interface ViewController ()
{
    @private
    NSThread *_thread;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    /**** 布局视图 ****/
    UIButton *wakeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wakeBtn.frame = CGRectMake(100, 200, 100, 100);
    wakeBtn.backgroundColor = [UIColor blueColor];
    [wakeBtn setTitle:@"唤醒线程" forState:UIControlStateNormal];
    [wakeBtn addTarget:self action:@selector(wakeThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wakeBtn];
    
    UIButton *stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stopBtn.frame = CGRectMake(250, 200, 100, 100);
    stopBtn.backgroundColor = [UIColor blueColor];
    [stopBtn setTitle:@"结束线程" forState:UIControlStateNormal];
    [stopBtn addTarget:self action:@selector(stopThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];
    
    _thread = [[NSThread alloc] initWithTarget:self selector:@selector(startThread) object:nil];
    _thread.name = @"ba.chen.thread";
    [_thread start];
}

- (void)wakeThread {
    [self performSelector:@selector(threadDoTask) onThread:_thread withObject:nil waitUntilDone:NO];
}

- (void)stopThread {
    [_thread cancel];
    
    [self performSelector:@selector(stop) onThread:_thread withObject:nil waitUntilDone:NO];
}

#pragma mark - 开启子线程RunLoop
- (void)startThread { @autoreleasepool {
    NSThread *currentThread = [NSThread currentThread];
    BOOL isCancelled = [currentThread isCancelled];
    
    NSLog(@"start - %@", currentThread);
    
    NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
    
    // 添加观察者
    [self addRunloopObserver];
    
    /**** 以时钟开启RunLoop ****/
    [NSTimer scheduledTimerWithTimeInterval:[[NSDate distantFuture] timeIntervalSinceNow] repeats:YES block:^(NSTimer * _Nonnull timer) {
       // 空任务
    }];
/*
    [NSTimer scheduledTimerWithTimeInterval:5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        // 空任务
        NSLog(@"abc");
    }];
*/
    // 开启RunLoop
    while (!isCancelled && [currentRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]) {
        isCancelled = [currentThread isCancelled];
        NSLog(@"run ----------- run");
    }
    
    NSLog(@"end -- %@", currentThread);
}}

- (void)threadDoTask {
    NSLog(@"do task -- %@", [NSThread currentThread]);
}

/// 空任务唤醒线程
- (void)stop {}

#pragma mark - 添加观察者
/// 这里面都是C语言 -- 添加一个监听者
-(void)addRunloopObserver{
    //获取当前的RunLoop
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    //定义一个centext
    CFRunLoopObserverContext context = {
        0,
        ( __bridge void *)(self),
        &CFRetain,
        &CFRelease,
        NULL
    };
    //定义一个观察者
    static CFRunLoopObserverRef defaultModeObsever;
    //创建观察者
    defaultModeObsever = CFRunLoopObserverCreate(NULL,
                                                 kCFRunLoopAllActivities,
                                                 YES,
                                                 NSIntegerMax - 999,
                                                 &ObserverCallback,
                                                 &context
                                                 );
    
    //添加当前RunLoop的观察者
    CFRunLoopAddObserver(runloop, defaultModeObsever, kCFRunLoopDefaultMode);
    //c语言有creat 就需要release
    CFRelease(defaultModeObsever);
    
}

/// 定义一个回调函数  RunLoop行为监听
static void ObserverCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    
    // 判断RunLoop的行为
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"kCFRunLoopEntry");
            break;
            
        case kCFRunLoopBeforeTimers:
            NSLog(@"kCFRunLoopBeforeTimers");
            break;
        
        case kCFRunLoopBeforeSources:
            NSLog(@"kCFRunLoopBeforeSources");
            break;
            
        case kCFRunLoopBeforeWaiting:
            NSLog(@"kCFRunLoopBeforeWaiting");
            break;
            
        case kCFRunLoopAfterWaiting:
            NSLog(@"kCFRunLoopAfterWaiting");
            break;
            
        case kCFRunLoopExit:
            NSLog(@"kCFRunLoopExit");
            break;
            
        default:
            break;
    }
    
    // 获取OC的对象
    ViewController * vc = (__bridge ViewController *)(info);
    
    [vc observerDoSomeThing];
}

- (void)observerDoSomeThing {
    
}
@end
