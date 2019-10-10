//
//  BoxModel.h
//  YFX_ScoketForClientDemo
//
//  Created by KlayThompson on 2019/10/4.
//  Copyright © 2019 fangxue. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BoxModel : NSObject

@property (nonatomic, copy) NSString *boxId;
@property (nonatomic, copy) NSString *boxV;
@property (nonatomic, copy) NSString *boxType;
@property (nonatomic, copy) NSString *boxNumber;
@property (nonatomic, copy) NSString *boxStatus;
@property (nonatomic, copy) NSString *inputV;
@property (nonatomic, copy) NSString *inputA;
@property (nonatomic, copy) NSString *boxChargePower;
@property (nonatomic, copy) NSString *boxTemperature;
@property (nonatomic, copy) NSString *boxHumidity;

@end

NS_ASSUME_NONNULL_END
