//
//  BoxDetailViewController.h
//  YFX_ScoketForClientDemo
//
//  Created by KlayThompson on 2019/10/3.
//  Copyright © 2019 fangxue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BatteryModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SaveBlock)(BatteryModel *newModel);
typedef void(^HeartbeatBlock)(BatteryModel *model);


@interface BoxDetailViewController : UIViewController

@property (nonatomic, copy) SaveBlock saveBlock;
@property (nonatomic, copy) HeartbeatBlock heartbeatBlock;

@property (nonatomic, strong) BatteryModel *currentModel;
@property (weak, nonatomic) IBOutlet UISwitch *isOpen;
@property (weak, nonatomic) IBOutlet UISwitch *haveBattery;
@property (weak, nonatomic) IBOutlet UITextField *statusWithDoorOpen;
@property (weak, nonatomic) IBOutlet UITextField *statusWithDoorClose;
@property (weak, nonatomic) IBOutlet UITextField *batteryStatus;
@property (weak, nonatomic) IBOutlet UITextField *declareV;
@property (weak, nonatomic) IBOutlet UITextField *totalAh;
@property (weak, nonatomic) IBOutlet UITextField *leftAh;
@property (weak, nonatomic) IBOutlet UITextField *soc;
@property (weak, nonatomic) IBOutlet UITextField *count;
@property (weak, nonatomic) IBOutlet UITextField *batteryIdTF;

@end

NS_ASSUME_NONNULL_END
