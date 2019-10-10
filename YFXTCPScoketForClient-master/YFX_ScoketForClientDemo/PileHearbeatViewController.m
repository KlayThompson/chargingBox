//
//  PileHearbeatViewController.m
//  YFX_ScoketForClientDemo
//
//  Created by KlayThompson on 2019/10/7.
//  Copyright © 2019 fangxue. All rights reserved.
//

#import "PileHearbeatViewController.h"

@interface PileHearbeatViewController ()

@end

@implementation PileHearbeatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pileStatusTF.text = self.currentModel.pileStatus;
    self.outputVTF.text = self.currentModel.outputV;
    self.outputATF.text = self.currentModel.outputA;
    self.totalKwhTF.text = self.currentModel.chargeKwh;
    self.pileTTF.text = self.currentModel.pileTem;
    self.switchStatusTF.text = self.currentModel.switchStatus;
    self.switchPowerTF.text = self.currentModel.switchKwh;
    self.sendTimeTF.text = self.currentModel.sendTime;
}

- (IBAction)saveButtonClick:(id)sender {
    PileHeartbeatModel *heartbeat = [PileHeartbeatModel new];
    heartbeat.pileStatus = self.pileStatusTF.text;
    heartbeat.outputV = self.outputVTF.text;
    heartbeat.outputA = self.outputATF.text;
    heartbeat.chargeKwh = self.totalKwhTF.text;
    heartbeat.pileTem = self.pileTTF.text;
    heartbeat.switchStatus = self.switchStatusTF.text;
    heartbeat.switchKwh = self.switchPowerTF.text;
    heartbeat.sendTime = self.sendTimeTF.text;
    self.saveBlock(heartbeat);
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
