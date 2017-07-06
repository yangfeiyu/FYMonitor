//
//  FYMainThreadMonitor.h
//  FYMonitor
//
//  Created by 杨飞宇 on 2017/7/6.
//  Copyright © 2017年 FY. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FYMainThreadMonitorDelegate <NSObject>

- (void)onMainThreadSlowStackDetected:(NSArray*)slowStack;

@end

@interface FYMainThreadMonitor : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, weak) id<FYMainThreadMonitorDelegate> watchDelegate;


//must be called from main thread
- (void)startWatch;

@end

