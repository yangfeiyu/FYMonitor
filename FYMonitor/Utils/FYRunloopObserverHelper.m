//
//  FYRunloopObserverHelper.m
//  FYMonitor
//
//  Created by 杨飞宇 on 2017/7/6.
//  Copyright © 2017年 FY. All rights reserved.
//

#import "FYRunloopObserverHelper.h"

@implementation FYRunloopObserverHelper


+ (void)setupRunloopObserver {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CFRunLoopRef runloop = CFRunLoopGetCurrent();
        
        CFRunLoopObserverRef enterObserver;
        enterObserver = CFRunLoopObserverCreate(CFAllocatorGetDefault(),
                                                kCFRunLoopEntry |
                                                kCFRunLoopBeforeTimers |
                                                kCFRunLoopBeforeSources |
                                                kCFRunLoopBeforeWaiting |
                                                kCFRunLoopAfterWaiting |
                                                kCFRunLoopExit |
                                                kCFRunLoopAllActivities,
                                                true,
                                                -0x7FFFFFFF,
                                                BBRunloopObserverCallBack, NULL);
        CFRunLoopAddObserver(runloop, enterObserver, kCFRunLoopCommonModes);
        CFRelease(enterObserver);
    });
}

static void BBRunloopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopEntry: {
            NSLog(@"kCFRunLoopEntry");
            break;
        }
        case kCFRunLoopBeforeTimers: {
            NSLog(@"kCFRunLoopBeforeTimers");
            break;
        }
        case kCFRunLoopBeforeSources: {
            NSLog(@"kCFRunLoopBeforeSources");
            break;
        }
        case kCFRunLoopBeforeWaiting: {
            NSLog(@"kCFRunLoopBeforeWaiting");
            break;
        }
        case kCFRunLoopAfterWaiting: {
            NSLog(@"kCFRunLoopAfterWaiting");
            break;
        }
        // 进入休眠，如果这里有输入，在这里处理
        case kCFRunLoopExit: {
            NSLog(@"kCFRunLoopExit");
            break;
        }
        default: break;
    }
}

@end
