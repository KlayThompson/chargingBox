//
//  BoxDetailViewController.m
//  YFX_ScoketForClientDemo
//
//  Created by KlayThompson on 2019/10/3.
//  Copyright © 2019 fangxue. All rights reserved.
//

#import "BoxDetailViewController.h"

@interface BoxDetailViewController ()

@end

@implementation BoxDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isOpen.on = self.currentModel.isOpen;
    self.haveBattery.on = self.currentModel.haveBattery;
    if (self.currentModel.haveBattery && self.currentModel.isOpen) {
        self.statusWithDoorOpen.text = self.currentModel.boxStatus;
    } else {
        self.statusWithDoorClose.text = self.currentModel.boxStatus;
    }
    self.batteryStatus.text = self.currentModel.batteryStatus;
    self.declareV.text = self.currentModel.declareV;
    self.totalAh.text = self.currentModel.totalAh;
    self.leftAh.text = self.currentModel.leftAh;
    self.soc.text = self.currentModel.SOC;
    self.count.text = self.currentModel.batteriesCount;
    self.batteryIdTF.text = self.currentModel.batteryId;
    
}
- (IBAction)saveButtonClick:(id)sender {
    
    BatteryModel *newModel = [BatteryModel new];
    newModel.boxId = self.currentModel.boxId;
    newModel.batteryId = self.currentModel.batteryId;
    newModel.isOpen = self.isOpen.on;
    newModel.haveBattery = self.haveBattery.on;
    if (self.isOpen.on && self.haveBattery.on) {
        newModel.boxStatus = self.statusWithDoorOpen.text;
    } else {
        newModel.boxStatus = self.statusWithDoorClose.text;
    }
    newModel.batteryStatus = self.batteryStatus.text;
    newModel.declareV = self.declareV.text;
    newModel.totalAh = self.totalAh.text;
    newModel.leftAh = self.leftAh.text;
    newModel.SOC = self.soc.text;
    newModel.batteriesCount = self.count.text;
    newModel.batteryId = self.batteryIdTF.text;
    self.saveBlock(newModel);
}

- (IBAction)heartbeatButtonClick:(id)sender {
    BatteryModel *newModel = [BatteryModel new];
    newModel.boxId = self.currentModel.boxId;
    newModel.batteryId = self.currentModel.batteryId;
    newModel.isOpen = self.isOpen.on;
    newModel.haveBattery = self.haveBattery.on;
    if (self.isOpen.on && self.haveBattery.on) {
        newModel.boxStatus = self.statusWithDoorOpen.text;
    } else {
        newModel.boxStatus = self.statusWithDoorClose.text;
    }
    newModel.batteryStatus = self.batteryStatus.text;
    newModel.declareV = self.declareV.text;
    newModel.totalAh = self.totalAh.text;
    newModel.leftAh = self.leftAh.text;
    newModel.SOC = self.soc.text;
    newModel.batteriesCount = self.count.text;
    
    if (self.heartbeatBlock) {
        self.heartbeatBlock(newModel);
    }
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
