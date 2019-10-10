//
//  PileLoginModel.h
//  YFX_ScoketForClientDemo
//
//  Created by KlayThompson on 2019/10/7.
//  Copyright © 2019 fangxue. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PileLoginModel : NSObject

@property (nonatomic, copy) NSString *pileNum;
@property (nonatomic, copy) NSString *pileVersion;
@property (nonatomic, copy) NSString *pileType;
@property (nonatomic, copy) NSString *totalKw;
@property (nonatomic, copy) NSString *lon;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *providerID;
@property (nonatomic, copy) NSString *magicNum;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *sign;

@end

NS_ASSUME_NONNULL_END
