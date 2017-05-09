//
//  RunLoopContext.m
//  加载大图
//
//  Created by chen on 2017/4/18.
//  Copyright © 2017年 H. All rights reserved.
//

#import "RunLoopContext.h"

#import "RunLoopSource.h"

@implementation RunLoopContext

- (id)initWithSource:(RunLoopSource *)source andLoop:(CFRunLoopRef)loop {
    if (self = [super init]) {
        _runloop = loop;
        _source = source;
    }
    
    return self;
}
@end
