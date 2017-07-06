//
//  FYFPSMonitor.m
//  FYMonitor
//
//  Created by 杨飞宇 on 2017/4/19.
//  Copyright © 2017年 FY. All rights reserved.
//

#import "FYFPSMonitor.h"
#import <UIKit/UIKit.h>

@interface FYFPSMonitor ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign, getter=isPause) BOOL pause;
@end

@implementation FYFPSMonitor

- (void)dealloc {
    [_displayLink setPaused:YES];
    [_displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

+ (instancetype)sharedInstance {
    static FYFPSMonitor *sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initPrivate];
    });
    
    return sharedInstance;
}

- (instancetype)init{
    return nil;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        _pause = YES;
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick)];
        [_displayLink setPreferredFramesPerSecond:30];
        [_displayLink setPaused:YES];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)start {
    
}

- (void)displayLinkTick {
    
}

@end
