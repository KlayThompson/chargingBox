//
//  OrderModel.m
//  YFX_ScoketForClientDemo
//
//  Created by KlayThompson on 2019/10/6.
//  Copyright © 2019 fangxue. All rights reserved.
//

#import "OrderModel.h"
#import "Tools.h"

@implementation OrderModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _batteryId = @"123456789";
        NSString *currentTime = [Tools currentdateInterval];
        _endTime = currentTime;
        NSInteger start = currentTime.intValue - 30*60;
        _beginTime = [NSString stringWithFormat:@"%ld", start];
        _chargeKwh = @"10";
        _endReason = @"0x00";
        _leftCapcity = @"10";
    }
    return self;
}


@end
