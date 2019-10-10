//
//  OrderModel.h
//  YFX_ScoketForClientDemo
//
//  Created by KlayThompson on 2019/10/6.
//  Copyright © 2019 fangxue. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderModel : NSObject

@property (nonatomic, copy) NSString *batteryId;
@property (nonatomic, copy) NSString *chargeKwh;
@property (nonatomic, copy) NSString *beginTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *endReason;
@property (nonatomic, copy) NSString *leftCapcity;

@end

NS_ASSUME_NONNULL_END
