//
//  PileLoginModel.m
//  YFX_ScoketForClientDemo
//
//  Created by KlayThompson on 2019/10/7.
//  Copyright © 2019 fangxue. All rights reserved.
//

#import "PileLoginModel.h"

@implementation PileLoginModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pileNum = @"AY123456789";
        _pileVersion = @"10101";
        _pileType = @"0x11";
        _totalKw = @"10";
        _lon = @"117.955128";
        _lat = @"28.457634";
        _providerID = @"12";
        _magicNum = @"11";
        _count = @"3";
        _sign = @"3";
    }
    return self;
}

@end
