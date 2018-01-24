//
//  ZJLog.h
//  ZJLogDemo
//
//  Created by Abnerzj on 2018/1/24.
//  Copyright © 2018年 Abnerzj. All rights reserved.
//

#ifndef ZJLog_h
#define ZJLog_h

#ifdef __OBJC__

// 引入CocoaLumberjack
#import <CocoaLumberjack/CocoaLumberjack.h>
#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelOff;
#endif

// 自定义日志对象
#import "ZJLogger.h"
// 自定义日志格式
#import "ZJLogFormatter.h"
// 自定义数据库日志对象
#import "ZJDatabaseLogger.h"

// 日志宏重命名，有些如果不需要可以注释。
#ifndef ZJLog
#define ZJLog           DDLogVerbose
#define ZJLogError      DDLogError
#define ZJLogWarn       DDLogWarn
#define ZJLogInfo       DDLogInfo
#define ZJLogDebug      DDLogDebug
#define ZJLogVerbose    DDLogVerbose
#endif

// 根据业务定义日志类型，如果不需要可以关闭。
// 直播
#define ZJLiveSwitch 1
#ifndef ZJLogLive
#if ZJLiveSwitch && DEBUG
#define ZJLogLive           DDLogVerbose
#else
#define ZJLogLive
#endif
#endif

#endif /* __OBJC__ */

#endif /* ZJLog_h */
