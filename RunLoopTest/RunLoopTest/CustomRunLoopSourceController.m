//
//  CustomRunLoopSourceController.m
//  RunLoopTest
//
//  Created by chen on 2017/5/8.
//  Copyright © 2017年 chen. All rights reserved.
//

/** 自定义输入源 **/
#import "CustomRunLoopSourceController.h"

#import "RunLoopSource.h"

@interface CustomRunLoopSourceController ()
{
    @private
    NSThread *_thread;
    RunLoopSource *_source;
}
@end

@implementation CustomRunLoopSourceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    /**** 布局视图 ****/
    UIButton *wakeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wakeBtn.frame = CGRectMake(100, 100, 100, 100);
    wakeBtn.backgroundColor = [UIColor blueColor];
    [wakeBtn setTitle:@"唤醒线程" forState:UIControlStateNormal];
    [wakeBtn addTarget:self action:@selector(wakeThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wakeBtn];
    
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    removeBtn.frame = CGRectMake(100, 250, 100, 100);
    removeBtn.backgroundColor = [UIColor blueColor];
    [removeBtn setTitle:@"移除输入源" forState:UIControlStateNormal];
    [removeBtn addTarget:self action:@selector(removeThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:removeBtn];
    
    UIButton *stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stopBtn.frame = CGRectMake(100, 400, 100, 100);
    stopBtn.backgroundColor = [UIColor blueColor];
    [stopBtn setTitle:@"结束线程" forState:UIControlStateNormal];
    [stopBtn addTarget:self action:@selector(stopThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];
    
    _thread = [[NSThread alloc] initWithTarget:self selector:@selector(otherThread) object:nil];
    _thread.name = @"ba.chen.customThread";
    [_thread start];
}

- (void)wakeThread {
    
    // 唤醒子线程
    [_source fireAllCommands];
}

- (void)removeThread {
    [_source invalidate];
}

- (void)stopThread {
    [_thread cancel];
    
    [self performSelector:@selector(stopRunLoop) onThread:_thread withObject:nil waitUntilDone:NO];
}

#pragma mark - 线程操作
- (void)otherThread {
    NSLog(@"%@", [NSThread currentThread]);
    RunLoopSource *source = [[RunLoopSource alloc] init];
    _source = source;
    
    // 添加观察者
    [self addRunloopObserver];
    
    [source addToCurrentRunLoop];
    
}

- (void)test {
    NSLog(@"test -- %@", [NSThread currentThread]);
//    CFRunLoopRef runloop = CFRunLoopGetCurrent();
//    [_source fireAllCommandsOnRunLoop:runloop];
}

- (void)stopRunLoop {
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    
    CFRunLoopStop(runLoop);
}

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
    CustomRunLoopSourceController * vc = (__bridge CustomRunLoopSourceController *)(info);
    
    [vc observerDoSomeThing];
}

- (void)observerDoSomeThing {
    
}

@end
