//
//  ViewController.m
//  FYMonitor
//
//  Created by 杨飞宇 on 2017/4/19.
//  Copyright © 2017年 FY. All rights reserved.
//

#import "ViewController.h"
#import "FYRunloopObserverHelper.h"

@interface ViewController () <NSMachPortDelegate>
@property (nonatomic, strong) NSThread *thread;
@property (nonatomic, strong) NSPort *macPort;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadStart) object:nil];
    self.thread = thread;
    [thread start];
    
}
- (void)threadStart {
    while (![self.thread isCancelled]) {
        
        [FYRunloopObserverHelper setupRunloopObserver];
        
        NSPort *macPort = [NSPort port];
        self.macPort = macPort;
        self.macPort.delegate = self;
        NSRunLoop *subRunLoop = [NSRunLoop currentRunLoop];
        [subRunLoop addPort:macPort forMode:NSDefaultRunLoopMode];
        [subRunLoop run];
        
        NSLog(@"---------");
    }
    
    //    while (1) {
    //        NSLog(@"while begin");
    //        NSRunLoop *subRunLoop = [NSRunLoop currentRunLoop];
    //        [FYRunloopObserverHelper setupRunloopObserver];
    //        [subRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    //        NSLog(@"while end");
    //    }
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
        [self.macPort sendBeforeDate:[NSDate date] msgid:12 components:nil from:self.macPort reserved:123];
}

// port 处理消息
- (void)handleMachMessage:(void *)msg {
    NSLog(@"message:%d", *(int *)msg);
}


@end
