//
//  PileHeartbeatModel.h
//  YFX_ScoketForClientDemo
//
//  Created by KlayThompson on 2019/10/7.
//  Copyright © 2019 fangxue. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PileHeartbeatModel : NSObject

@property (nonatomic, copy) NSString *pileStatus;
@property (nonatomic, copy) NSString *outputV;
@property (nonatomic, copy) NSString *outputA;
@property (nonatomic, copy) NSString *chargeKwh;
@property (nonatomic, copy) NSString *pileTem;
@property (nonatomic, copy) NSString *switchStatus;
@property (nonatomic, copy) NSString *switchKwh;

@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *sendTime;
@end

NS_ASSUME_NONNULL_END
