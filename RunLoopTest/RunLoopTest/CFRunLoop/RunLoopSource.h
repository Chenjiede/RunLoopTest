//
//  RunLoopSource.h
//  加载大图
//
//  Created by chen on 2017/4/18.
//  Copyright © 2017年 H. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunLoopSource : NSObject

{
    CFRunLoopSourceRef runLoopSource;
    
    NSMutableArray *commands;
}

@property (readonly) CFRunLoopRef runLoop;

/// 添加输入源到当前RunLoop
- (void)addToCurrentRunLoop;
/// 移除输入源
- (void)invalidate;
/// 当输入源唤醒RunLoop执行的任务
- (void)sourceFired;

- (void)addCommand:(NSUInteger)command withData:(id)data;

- (void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runloop;
/// 唤醒RunLoop
- (void)fireAllCommands;
@end
