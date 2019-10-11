//
//  PileHeartbeatModel.m
//  YFX_ScoketForClientDemo
//
//  Created by KlayThompson on 2019/10/7.
//  Copyright © 2019 fangxue. All rights reserved.
//

#import "PileHeartbeatModel.h"

@implementation PileHeartbeatModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pileStatus = @"0x01";
        _outputV = @"6";
        _outputA = @"5";
        _chargeKwh = @"10";
        _pileTem = @"38";
        _switchStatus = @"0x00";
        _switchKwh = @"5";
        _sendTime = @"60";
    }
    return self;
}

@end
