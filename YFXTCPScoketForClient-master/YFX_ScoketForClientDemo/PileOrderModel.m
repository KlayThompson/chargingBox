//
//  PileOrderModel.m
//  YFX_ScoketForClientDemo
//
//  Created by KlayThompson on 2019/10/11.
//  Copyright © 2019 fangxue. All rights reserved.
//

#import "PileOrderModel.h"

@implementation PileOrderModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _switchNum = @"1";
        _userId = @"1001";
        _serialNum = @"1570759534";
        _chargeKwh = @"101";
        _chargeW = @"35";
        _currentV = @"220";
        _currentA = @"25";
        _startTime = @"1570759534";
        _duration = @"900";
        _stopTime = @"1570760434";
        _stopReason = @"0x00";
    }
    return self;
}

@end
