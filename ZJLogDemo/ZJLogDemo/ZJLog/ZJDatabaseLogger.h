//
//  ZJDatabaseLogger.h
//  ZJLogDemo
//
//  Created by Abnerzj on 2018/1/24.
//  Copyright © 2018年 Abnerzj. All rights reserved.
//

/*
 * 这个自定义Logger是用于将数据库日志上传到服务器的。
 * PS：还有一种需求，就是把日志先保存到本地，不主动上传，当用户反馈时，才将本地存储的日志上传，这个就需要用到DDFileLogger了。
 */

#import <CocoaLumberjack/DDAbstractDatabaseLogger.h>

@interface ZJDatabaseLogger : DDAbstractDatabaseLogger

@end
