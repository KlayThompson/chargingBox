//
//  PileOrderViewController.h
//  YFX_ScoketForClientDemo
//
//  Created by KlayThompson on 2019/10/11.
//  Copyright © 2019 fangxue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PileOrderModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^ChargeOrderBlock)(PileOrderModel *model);
typedef void(^ChargingBlock)(PileOrderModel *model);


@interface PileOrderViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *switchNumTF;
@property (weak, nonatomic) IBOutlet UITextField *userIdTF;

@property (weak, nonatomic) IBOutlet UITextField *serialNumTF;
@property (weak, nonatomic) IBOutlet UITextField *chargeKwhTF;
@property (weak, nonatomic) IBOutlet UITextField *chargeWTF;
@property (weak, nonatomic) IBOutlet UITextField *currentVTF;
@property (weak, nonatomic) IBOutlet UITextField *currentATF;
@property (weak, nonatomic) IBOutlet UITextField *startTimeTF;
@property (weak, nonatomic) IBOutlet UITextField *durationTF;
@property (weak, nonatomic) IBOutlet UITextField *stopTimeTF;
@property (weak, nonatomic) IBOutlet UITextField *stopReasonTF;

@property (nonatomic, strong) PileOrderModel *orderModel;

@property (nonatomic, copy) ChargingBlock chargingBlock;
@property (nonatomic, copy) ChargeOrderBlock chargeOrderBlock;

@end

NS_ASSUME_NONNULL_END
