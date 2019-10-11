//
//  PileOrderModel.h
//  YFX_ScoketForClientDemo
//
//  Created by KlayThompson on 2019/10/11.
//  Copyright © 2019 fangxue. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PileOrderModel : NSObject


@property (nonatomic, copy) NSString *switchNum;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *serialNum;
@property (nonatomic, copy) NSString *chargeKwh;
@property (nonatomic, copy) NSString *chargeW;
@property (nonatomic, copy) NSString *currentV;
@property (nonatomic, copy) NSString *currentA;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *duration;


@property (nonatomic, copy) NSString *stopTime;
@property (nonatomic, copy) NSString *stopReason;



@end

NS_ASSUME_NONNULL_END
