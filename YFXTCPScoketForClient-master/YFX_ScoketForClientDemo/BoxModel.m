//
//  BoxModel.m
//  YFX_ScoketForClientDemo
//
//  Created by KlayThompson on 2019/10/4.
//  Copyright © 2019 fangxue. All rights reserved.
//

#import "BoxModel.h"

@implementation BoxModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _boxId = @"AY0123456";
        _boxV = @"100101";
        _boxType = @"0x01";
        _boxNumber = @"8";
        _boxStatus = @"0x01";
        _inputV = @"220";
        _inputA = @"32";
        _boxChargePower = @"2000";
        _boxTemperature = @"38";
        _boxHumidity = @"70";
    }
    return self;
}

@end
