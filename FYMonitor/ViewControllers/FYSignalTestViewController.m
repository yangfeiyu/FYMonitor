//
//  FYSignalTestViewController.m
//  FYMonitor
//
//  Created by 杨飞宇 on 2017/7/6.
//  Copyright © 2017年 FY. All rights reserved.
//

#import "FYSignalTestViewController.h"
#import "FYSignalHandler.h"
#import <pthread/pthread.h>
#import "FYMainThreadMonitor.h"

@interface FYSignalTestViewController ()

@end

@implementation FYSignalTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [FYSignalHandler registerSignalHandler];
//    [[FYMainThreadMonitor sharedInstance] startWatch];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    pthread_t thread = pthread_self();
    pthread_kill(thread, CALLSTACK_SIG2);
}

@end
