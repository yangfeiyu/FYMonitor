//
//  PerformanceMonitor.m
//  SuperApp
//
//  Created by qianjianeng on 15/11/12.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import "PerformanceMonitor.h"
#import <CrashReporter/CrashReporter.h>

@interface PerformanceMonitor ()
{
    int timeoutCount;
    CFRunLoopObserverRef observer;
    
    @public
    dispatch_semaphore_t semaphore;
    CFRunLoopActivity activity;
}
@end

@implementation PerformanceMonitor

+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

// runloop observer 回调
static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    PerformanceMonitor *moniotr = (__bridge PerformanceMonitor*)info;
    
    moniotr->activity = activity;
    
    dispatch_semaphore_t semaphore = moniotr->semaphore;
    dispatch_semaphore_signal(semaphore);
    
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

- (void)stopMonitor
{
    if (!observer)
        return;
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    CFRelease(observer);
    observer = NULL;
}

- (void)startMonitor
{
    if (observer)
        return;
    
    // 信号,Dispatch Semaphore保证同步
    semaphore = dispatch_semaphore_create(0);
    
    // 注册RunLoop状态观察
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                       kCFRunLoopAllActivities,
                                       YES,
                                       0,
                                       &runLoopObserverCallBack,
                                       &context);
    // 将观察者添加到主线程runloop的common模式下的观察中
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    
    // 在子线程监控时长 开启一个持续的loop用来进行监控
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES)
        {
            // semaphore 的超时时间为 50 ms，如果超时，则 st 等于一个较大的值
            long st = dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 50*NSEC_PER_MSEC));
            
            NSLog(@"----------");
            // st != 0 表示信号量超时
            if (st != 0)
            {
                if (!observer)
                {
                    timeoutCount = 0;
                    semaphore = 0;
                    activity = 0;
                    return;
                }
                // 两个runloop的状态，BeforeSources和AfterWaiting这两个状态区间时间能够检测到是否卡顿
                if (activity == kCFRunLoopBeforeSources || activity == kCFRunLoopAfterWaiting)
                {
                    if (++timeoutCount < 5)
                        continue;
                    
                    // 5次超时，就上报卡顿
                    
                    PLCrashReporterConfig *config = [[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeBSD
                                                                                       symbolicationStrategy:PLCrashReporterSymbolicationStrategyAll];
                    PLCrashReporter *crashReporter = [[PLCrashReporter alloc] initWithConfiguration:config];
                    NSData *data = [crashReporter generateLiveReport];
                    PLCrashReport *reporter = [[PLCrashReport alloc] initWithData:data error:NULL];
                    NSString *report = [PLCrashReportTextFormatter stringValueForCrashReport:reporter
                                                                              withTextFormat:PLCrashReportTextFormatiOS];
                    // 上传服务器
                    NSLog(@"此处发生卡顿:---%@", report);
                }//end activity
            }// end semaphore wait
            timeoutCount = 0;
        }// end while
    });
}

@end
