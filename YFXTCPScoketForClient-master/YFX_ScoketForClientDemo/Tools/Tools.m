//
//  Tools.m
//  YFX_ScoketForClientDemo
//
//  Created by KlayThompson on 2019/10/1.
//  Copyright © 2019 fangxue. All rights reserved.
//

#import "Tools.h"

@implementation Tools


+ (NSString *)getHexByDecimal:(NSInteger)decimal {
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            
            break;
        }
    }
    return hex;
}


+ (NSData*)hexToBytes:(NSString *)dataStr length:(NSInteger)length {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= dataStr.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [dataStr substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
        
    }
    if (length == 0) {
        return data;
    } else {
        NSInteger len = length - data.length;
        if (len > 0) {
            for (int i = 0; i < len; i++) {
                unsigned char d[1] = {0x00};
                NSData *addData = [NSData dataWithBytes:d length:1];
                [data appendData:addData];
            }
            return data;
        } else {
            return data;
        }
    }
}

+ (NSData *)stringToAsciiData:(NSString *)string {
    NSMutableArray *arr = [NSMutableArray new];

    for(int i =0; i < [string length]; i++) {
        [arr addObject:@([string characterAtIndex:i])];
    }
    NSString *newStr = [arr componentsJoinedByString:@""];
    return [self hexToBytes:newStr length:0];
}



+ (NSData *)convertHexStrToData:(NSString *)str length:(NSInteger)length
{
    if (!str || [str length] == 0) {
        return nil;
    }
    if ([str hasPrefix:@"0x"]) {
        str = [str stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    if (length == 0) {
        return hexData;
    } else {
        NSInteger len = length - hexData.length;
        if (len > 0) {
            for (int i = 0; i < len; i++) {
                unsigned char d[1] = {0x00};
                NSData *addData = [NSData dataWithBytes:d length:1];
                [hexData appendData:addData];
            }
            return hexData;
        } else {
            return hexData;
        }
    }
}



+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

+ (NSString *)decimalToHexWithLength:(NSUInteger)length string:(NSString *)string;{
//    NSString* subString = [string decimalToHex];
//    NSUInteger moreL = length - subString.length;
//    if (moreL>0) {
//        for (int i = 0; i<moreL; i++) {
//            subString = [NSString stringWithFormat:@"0%@",subString];
//        }
//    }
//    return subString;
    
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

+ (NSString *)reverseWithString:(NSString *)string {
    string = [string stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSMutableString *mStr = [[NSMutableString alloc] initWithString:string];
    if (string.length%2!=0) {
        [mStr insertString:@"0" atIndex:0];
    }
    
    
    NSMutableArray *arr = [NSMutableArray new];
    
    for(int i =0; i < [mStr length]; i++) {
//        if (mStr.length == 8) {
//            if (i == string.length/2) {
//                break;
//            }
//        }
        if (i == mStr.length/2) {
            break;
        }
        [arr addObject:[mStr substringWithRange:NSMakeRange(i*2,2)]];
    }
    NSArray *array = [arr mutableCopy];
    NSArray *newArray = [[array reverseObjectEnumerator] allObjects];
    NSString *newStr = [newArray componentsJoinedByString:@""];
    return newStr;
}


+ (BatteryModel *)creatBatteryModelWithBoxNumber:(NSString *)boxID {
    BatteryModel *model = [[BatteryModel alloc] init];

    if ([boxID isEqualToString:@"box1"]) {
        
        model.boxId = @"1";
        model.parentNumber = @"AY01A00YX18110009";
        model.batteryId = @"20191001";
        model.boxStatus = @"03";//充电中
        model.batteryStatus = @"0C";
        model.declareV = @"60";
        model.totalAh = @"8";
        model.leftAh = @"2";
        model.SOC = @"40";
        model.batteriesCount = @"10";
        model.isOpen = false;
        model.haveBattery = true;
        
    } else if ([boxID isEqualToString:@"box2"]) {
        model.boxId = @"2";
        model.parentNumber = @"AY01A00YX18110009";
        model.batteryId = @"20191002";
        model.boxStatus = @"0x04"; //充满待用
        model.batteryStatus = @"0x0D";
        model.declareV = @"60";
        model.totalAh = @"8";
        model.leftAh = @"8";
        model.SOC = @"40";
        model.batteriesCount = @"10";
        model.isOpen = false;
        model.haveBattery = true;
        
    } else if ([boxID isEqualToString:@"box3"]) {
        model.boxId = @"3";
        model.parentNumber = @"AY01A00YX18110009";
        model.batteryId = @"20191004";
        model.boxStatus = @"0x00"; //无电池
        model.batteryStatus = @"0";
        model.declareV = @"0";
        model.totalAh = @"0";
        model.leftAh = @"0";
        model.SOC = @"0";
        model.batteriesCount = @"0";
        model.isOpen = false;
        model.haveBattery = false;
        
    } else if ([boxID isEqualToString:@"box4"]) {
        model.boxId = @"4";
        model.parentNumber = @"AY01A00YX18110009";
        model.batteryId = @"2019001";
        model.boxStatus = @"0x04";//充电中
        model.batteryStatus = @"0x0D";
        model.declareV = @"60";
        model.totalAh = @"8";
        model.leftAh = @"6";
        model.SOC = @"40";
        model.batteriesCount = @"7";
        model.isOpen = false;
        model.haveBattery = true;
        
    } else if ([boxID isEqualToString:@"box5"]) {
        model.boxId = @"5";
        model.parentNumber = @"AY01A00YX18110009";
        model.batteryId = @"20191005";
        model.boxStatus = @"0x05";//待取电池中
        model.batteryStatus = @"0x0D";
        model.declareV = @"60";
        model.totalAh = @"8";
        model.leftAh = @"8";
        model.SOC = @"40";
        model.batteriesCount = @"10";
        model.isOpen = true;
        model.haveBattery = true;
        
    } else if ([boxID isEqualToString:@"box6"]) {
        model.boxId = @"6";
        model.parentNumber = @"AY01A00YX18110009";
        model.batteryId = @"0";
        model.boxStatus = @"0x06";//待还电池中
        model.batteryStatus = @"0";
        model.declareV = @"0";
        model.totalAh = @"00";
        model.leftAh = @"0";
        model.SOC = @"0";
        model.batteriesCount = @"0";
        model.isOpen = true;
        model.haveBattery = false;
        
    } else if ([boxID isEqualToString:@"box7"]) {
        model.boxId = @"7";
        model.parentNumber = @"AY01A00YX18110009";
        model.batteryId = @"20191007";
        model.boxStatus = @"0x01";//故障
        model.batteryStatus = @"0x0E";//电池故障
        model.declareV = @"60";
        model.totalAh = @"8";
        model.leftAh = @"3";
        model.SOC = @"40";
        model.batteriesCount = @"10";
        model.isOpen = false;
        model.haveBattery = true;
        
    } else if ([boxID isEqualToString:@"box8"]) {
        model.boxId = @"8";
        model.parentNumber = @"AY01A00YX18110009";
        model.batteryId = @"0";
        model.boxStatus = @"0x09";//仓门已开，出现故障
        model.batteryStatus = @"0";//
        model.declareV = @"0";
        model.totalAh = @"0";
        model.leftAh = @"0";
        model.SOC = @"0";
        model.batteriesCount = @"0";
        model.isOpen = true;
        model.haveBattery = false;
        
    }
    return model;
}


+(NSString *)currentdateInterval
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}

+ (NSString *)remove0xStringWithString:(NSString *)string {
    if ([string hasPrefix:@"0x"]) {
        string = [string stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    }
    return string;
}

/**
 NSData 转  十六进制string
 
 @return NSString类型的十六进制string
 */
+ (NSString *)convertDataToHexStrWithData:(NSData *)data {
    if (!self || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

/**
 十六进制转十进制
 
 @return 十进制字符串
 */
+ (NSString *)hexToDecimalWithString:(NSString *)string {
    return [NSString stringWithFormat:@"%lu",strtoul([string UTF8String],0,16)];
}

/* 时间戳转时间  */
+(NSString *)timeStrWithEnglish:(NSTimeInterval)timeValue
{
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:timeValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [dateFormatter stringFromDate:detaildate];
}
@end
