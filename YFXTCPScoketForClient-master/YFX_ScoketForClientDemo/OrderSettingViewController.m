//
//  OrderSettingViewController.m
//  YFX_ScoketForClientDemo
//
//  Created by KlayThompson on 2019/10/6.
//  Copyright © 2019 fangxue. All rights reserved.
//

#import "OrderSettingViewController.h"

@interface OrderSettingViewController ()

@end

@implementation OrderSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.batteryIdTF.text = self.currentModel.batteryId;
    self.chargeKwhTF.text = self.currentModel.chargeKwh;
    self.beginTimeTF.text = self.currentModel.beginTime;
    self.endTimeTF.text = self.currentModel.endTime;
    self.resonTF.text = self.currentModel.endReason;
    self.leftCapcityTF.text = self.currentModel.leftCapcity;
}
- (IBAction)saveButtonClick:(id)sender {
    
    OrderModel *model = [OrderModel new];
    
    model.batteryId = self.batteryIdTF.text;
    model.chargeKwh = self.chargeKwhTF.text;
    model.beginTime = self.beginTimeTF.text;
    model.endTime = self.endTimeTF.text;
    model.endReason = self.resonTF.text;
    model.leftCapcity = self.leftCapcityTF.text;
    
    self.saveBlock(model);
    [self dismissViewControllerAnimated:YES completion:nil];
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
