//
//  Tools.h
//  YFX_ScoketForClientDemo
//
//  Created by KlayThompson on 2019/10/1.
//  Copyright © 2019 fangxue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BatteryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tools : NSObject

/// 将数字转换为十六进制字符串
/// @param decimal NSInteger值
+ (NSString *)getHexByDecimal:(NSInteger)decimal;

/// 将字符串转换为data
/// @param dataStr <#dataStr description#>
+ (NSData*)hexToBytes:(NSString *)dataStr length:(NSInteger)length;

/// 将十六进制的字符串转换为data
/// @param str 需要转换的字符串
+ (NSData *)convertHexStrToData:(NSString *)str length:(NSInteger)length;

/// 将字符串转换为十六进制字符串
/// @param string 需要转换的字符串
+ (NSString *)hexStringFromString:(NSString *)string;


/// 将字符串转换为指定长度的十六进制s字符串
/// @param length 长度
/// @param string 字符串
+ (NSString *)decimalToHexWithLength:(NSUInteger)length string:(NSString *)string;

/// 将字符串翻转，两个字节为一个单位
/// @param string 需要转换的字符串
+ (NSString *)reverseWithString:(NSString *)string;



/// 创建测试数据
/// @param boxID 电池仓编号
+ (BatteryModel *)creatBatteryModelWithBoxNumber:(NSString *)boxID;

/// 获取当前时间戳
+(NSString *)currentdateInterval;

/// 移除开头的0x
+ (NSString *)remove0xStringWithString:(NSString *)string;

/**
 NSData 转  十六进制string
 
 @return NSString类型的十六进制string
 */
+ (NSString *)convertDataToHexStrWithData:(NSData *)datal;

/**
 十六进制转十进制
 
 @return 十进制字符串
 */
+ (NSString *)hexToDecimalWithString:(NSString *)string;
/* 时间戳转时间  */
+(NSString *)timeStrWithEnglish:(NSTimeInterval)timeValue;
@end

NS_ASSUME_NONNULL_END
