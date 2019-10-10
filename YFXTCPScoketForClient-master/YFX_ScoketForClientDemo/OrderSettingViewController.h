//
//  OrderSettingViewController.h
//  YFX_ScoketForClientDemo
//
//  Created by KlayThompson on 2019/10/6.
//  Copyright © 2019 fangxue. All rights reserved.
//

#import "ViewController.h"
#import "OrderModel.h"


NS_ASSUME_NONNULL_BEGIN
typedef void(^SaveOrderBlock)(OrderModel *model);

@interface OrderSettingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *batteryIdTF;
@property (weak, nonatomic) IBOutlet UITextField *chargeKwhTF;
@property (weak, nonatomic) IBOutlet UITextField *beginTimeTF;

@property (weak, nonatomic) IBOutlet UITextField *endTimeTF;
@property (weak, nonatomic) IBOutlet UITextField *resonTF;

@property (weak, nonatomic) IBOutlet UITextField *leftCapcityTF;

@property (nonatomic, strong) OrderModel *currentModel;

@property (nonatomic, copy) SaveOrderBlock saveBlock;

@end

NS_ASSUME_NONNULL_END
