//
//  ZJLogFormatter.m
//  ZJLogDemo
//
//  Created by Abnerzj on 2018/1/24.
//  Copyright © 2018年 Abnerzj. All rights reserved.
//

#import "ZJLogFormatter.h"

@implementation ZJLogFormatter

#pragma mark 普通打印的日志格式
//- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
//{
//    NSString *logLevel;
//    switch (logMessage->_flag) {
//        case DDLogFlagError    : logLevel = @"E"; break;
//        case DDLogFlagWarning  : logLevel = @"W"; break;
//        case DDLogFlagInfo     : logLevel = @"I"; break;
//        case DDLogFlagDebug    : logLevel = @"D"; break;
//        default                : logLevel = @"V"; break;
//    }
//
//    return [NSString stringWithFormat:@"%@ | %@", logLevel, logMessage->_message];
//}

#pragma mark 上传到服务器的日志格式（JSON字符串）
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    NSMutableDictionary *logDict = [NSMutableDictionary dictionary];
    
    // 取得文件名
    NSString *fileName = logMessage->_fileName;
    
    // 格式: {"location":"myfile.m:120(void a::sub(int)"}， 文件名，行数和函数名是用的编译器宏 __FILE__, __LINE__, __PRETTY_FUNCTION__
    logDict[@"fileName"] = [NSString stringWithFormat:@"%@:%lu(%@)", fileName, (unsigned long)logMessage->_line, logMessage->_function];
    
    // 尝试将logDict内容转为字符串，其实这里可以直接构造字符串，但真实项目中，肯定需要很多其他的信息，不可能仅仅文件名、行数和函数名就够了的。
    NSError *error;
    NSData *outputJson = [NSJSONSerialization dataWithJSONObject:logDict options:0 error:&error];
    if (error) {
        return @"{\"fileName\":\"error\"}";
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:outputJson encoding:NSUTF8StringEncoding];
        return jsonString ? jsonString : @"{\"fileName\":\"error\"}";
    }
}

@end
