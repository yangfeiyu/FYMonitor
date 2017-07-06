//
//  FYSignalHandler.h
//  FYMonitor
//
//  Created by 杨飞宇 on 2017/7/6.
//  Copyright © 2017年 FY. All rights reserved.
//  信号处理类

#import <UIKit/UIKit.h>
#import <signal.h>

#define CALLSTACK_SIG2 SIGUSR2

@interface FYSignalHandler : NSObject

// 注册捕获信号的方法
+ (void)registerSignalHandler;

+ (instancetype)instance;

- (void)handleExceptionOnMainThread:(NSException *)exception;

@end
