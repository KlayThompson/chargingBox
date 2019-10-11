//
//  PileOrderViewController.m
//  YFX_ScoketForClientDemo
//
//  Created by KlayThompson on 2019/10/11.
//  Copyright © 2019 fangxue. All rights reserved.
//

#import "PileOrderViewController.h"

@interface PileOrderViewController ()

@end

@implementation PileOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.switchNumTF.text = self.orderModel.switchNum;
    self.userIdTF.text = self.orderModel.userId;
    self.serialNumTF.text = self.orderModel.serialNum;
    self.chargeKwhTF.text = self.orderModel.chargeKwh;
    self.chargeWTF.text = self.orderModel.chargeW;
    self.currentVTF.text = self.orderModel.currentV;
    self.currentATF.text = self.orderModel.currentA;
    self.startTimeTF.text = self.orderModel.startTime;
    self.durationTF.text = self.orderModel.duration;
    self.stopTimeTF.text = self.orderModel.stopTime;
    self.stopReasonTF.text = self.orderModel.stopReason;
    
    if (self.isSending) {
        [self.chargingButton setTitle:@"停止上报数据" forState:UIControlStateNormal];
    } else {
        [self.chargingButton setTitle:@"上报充电数据" forState:UIControlStateNormal];
    }
}

- (IBAction)uploadChargingData:(id)sender {
    PileOrderModel *model = [PileOrderModel new];
    model.switchNum = self.switchNumTF.text;
    model.userId = self.userIdTF.text;
    model.serialNum = self.serialNumTF.text;
    model.chargeKwh = self.chargeKwhTF.text;
    model.chargeW = self.chargeWTF.text;
    model.currentV = self.currentVTF.text;
    model.currentA = self.currentATF.text;
    model.startTime = self.startTimeTF.text;
    model.duration = self.durationTF.text;
    if (self.isSending) {
        self.stopBlock();
    } else {
        self.chargingBlock(model);
    }
}

- (IBAction)uploadChargeOrder:(id)sender {
    PileOrderModel *model = [PileOrderModel new];
    model.switchNum = self.switchNumTF.text;
    model.userId = self.userIdTF.text;
    model.serialNum = self.serialNumTF.text;
    model.startTime = self.startTimeTF.text;
    model.stopTime = self.stopTimeTF.text;
    model.duration = self.durationTF.text;
    model.stopReason = self.stopReasonTF.text;
    model.chargeKwh = self.chargeKwhTF.text;
    if (self.chargeOrderBlock) {
        self.chargeOrderBlock(model);
    }
}

@end
