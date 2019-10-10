//
//  SettingViewController.m
//  YFX_ScoketForClientDemo
//
//  Created by KlayThompson on 2019/9/27.
//  Copyright © 2019 fangxue. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.boxIDTF.text = self.currentModel.boxId;
    self.boxVTF.text = self.currentModel.boxV;
    self.boxTypeTF.text = self.currentModel.boxType;
    self.boxNumberTF.text = self.currentModel.boxNumber;
    self.inputVTF.text = self.currentModel.inputV;
    self.inputATF.text = self.currentModel.inputA;
    self.boxPowerTF.text = self.currentModel.boxChargePower;
    self.boxTemperture.text = self.currentModel.boxTemperature;
    self.boxHumidityTF.text = self.currentModel.boxHumidity;
    
}
- (IBAction)saveButtonClick:(id)sender {
    
    BoxModel *newModel = [BoxModel new];
    newModel.boxId = self.boxIDTF.text;
    newModel.boxV = self.boxVTF.text;
    newModel.boxType = self.boxTypeTF.text;
    newModel.boxNumber = self.boxNumberTF.text;
    newModel.boxStatus = self.boxStatusTF.text;
    newModel.inputV = self.inputVTF.text;
    newModel.inputA = self.inputATF.text;
    newModel.boxChargePower = self.boxPowerTF.text;
    newModel.boxTemperature = self.boxTemperture.text;
    newModel.boxHumidity = self.boxHumidityTF.text;
    self.saveBlock(newModel);
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
