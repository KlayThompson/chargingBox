//
//  BatteryModel.h
//  YFX_ScoketForClientDemo
//
//  Created by KlayThompson on 2019/10/3.
//  Copyright © 2019 fangxue. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BatteryModel : NSObject

@property (nonatomic, copy) NSString *boxId;
@property (nonatomic, copy) NSString *parentNumber;
@property (nonatomic, copy) NSString *batteryId;
@property (nonatomic, copy) NSString *boxStatus;
@property (nonatomic, copy) NSString *batteryStatus;
@property (nonatomic, copy) NSString *declareV;
@property (nonatomic, copy) NSString *totalAh;
@property (nonatomic, copy) NSString *leftAh;
@property (nonatomic, copy) NSString *SOC;
@property (nonatomic, copy) NSString *batteriesCount;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) BOOL haveBattery;


@end

NS_ASSUME_NONNULL_END
