//
//  RunLoopContext.h
//  加载大图
//
//  Created by chen on 2017/4/18.
//  Copyright © 2017年 H. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RunLoopSource;

@interface RunLoopContext : NSObject

{
    CFRunLoopRef _runloop;
    
    RunLoopSource *_source;
}

@property (readonly) CFRunLoopRef runLoop;

@property (readonly) RunLoopSource *source;

- (id)initWithSource:(RunLoopSource *)source andLoop:(CFRunLoopRef)loop;
@end
