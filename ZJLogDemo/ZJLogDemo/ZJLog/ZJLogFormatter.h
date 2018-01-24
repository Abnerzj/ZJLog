//
//  ZJLogFormatter.h
//  ZJLogDemo
//
//  Created by Abnerzj on 2018/1/24.
//  Copyright © 2018年 Abnerzj. All rights reserved.
//

/*
 * 这个自定义Formatter是用于上传日志到服务器的（JSON字符串）。
 */

#import <Foundation/Foundation.h>
#import "DDLog.h"

@interface ZJLogFormatter : NSObject <DDLogFormatter>

@end
