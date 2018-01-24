//
//  ZJDatabaseLogger.m
//  ZJLogDemo
//
//  Created by Abnerzj on 2018/1/24.
//  Copyright © 2018年 Abnerzj. All rights reserved.
//

#import "ZJDatabaseLogger.h"

@interface ZJDatabaseLogger ()

@property (nonatomic, strong) NSMutableArray *logMessagesArray;

@end

@implementation ZJDatabaseLogger

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.deleteInterval = 0; // 多久清除一次数据库日志缓存
        self.maxAge = 0;  // 日志最多缓存时间，默认七天
        self.deleteOnEverySave = NO; // 每次保存的时候是否删除旧的日志
        self.saveInterval = 60; // 每隔多久保存一次
        self.saveThreshold = 500; // 最多保存多少日志数量
        self.logMessagesArray = [NSMutableArray arrayWithCapacity:self.saveThreshold]; // 当前日志数量
        
        // 进入后台时上报一次日志
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(saveOnSuspend)
                                                     name:@"UIApplicationWillResignActiveNotification"
                                                   object:nil];
    }
    return self;
}

- (BOOL)db_log:(DDLogMessage *)logMessage
{
    // 没有指定 formatter
    if (!_logFormatter) {
        return NO;
    }
    
    // 如果段时间内进入大量log，并且迟迟发不到服务器上，我们可以判断哪里出了问题，在这之后的 log 暂时不处理了。
    // 但我们依然要告诉 DDLog 这个存进去了。
    if (_logMessagesArray.count > 2000) {
        return YES;
    }
    
    // 利用 formatter 得到消息字符串，添加到缓存
    [_logMessagesArray addObject:[_logFormatter formatLogMessage:logMessage]];
    
    return YES;
}

- (void)saveOnSuspend
{
    dispatch_async(_loggerQueue, ^{
        [self db_save];
    });
}

- (void)db_save
{
    // 判断是否在 logger 自己的GCD队列中
    if (![self isOnInternalLoggerQueue]) {
        NSAssert(NO, @"db_saveAndDelete should only be executed on the internalLoggerQueue thread, if you're seeing this, your doing it wrong.");
    }
    
    // 如果缓存内没数据，啥也不做
    if (_logMessagesArray.count) {
        return;
    }
    
    // 获取缓存中所有数据，之后将缓存清空
    NSArray *oldLogMessagesArray = [_logMessagesArray copy];
    [_logMessagesArray removeAllObjects];
    
    // 用换行符，把所有的数据拼成一个大字符串
    NSString *logMessagesString = [oldLogMessagesArray componentsJoinedByString:@"\n"];
    
    // 发送到自己服务器(自己实现了)
    NSLog(@"logMessagesString:%@", logMessagesString);
//    [self post:logMessagesString];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIApplicationWillResignActiveNotification" object:nil];
}

@end
