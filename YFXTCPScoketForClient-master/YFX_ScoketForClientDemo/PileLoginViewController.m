//
//  PileLoginViewController.m
//  YFX_ScoketForClientDemo
//
//  Created by KlayThompson on 2019/10/7.
//  Copyright © 2019 fangxue. All rights reserved.
//

#import "PileLoginViewController.h"

@interface PileLoginViewController ()

@end

@implementation PileLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pileNumTF.text = self.currentModel.pileNum;
    self.pileVTF.text = self.currentModel.pileVersion;
    self.pileTypeTF.text = self.currentModel.pileType;
    self.totalKwTF.text = self.currentModel.totalKw;
    self.lonTF.text = self.currentModel.lon;
    self.latTF.text = self.currentModel.lat;
    self.providerNumTF.text = self.currentModel.providerID;
    self.magicNumTF.text = self.currentModel.magicNum;
    self.countTF.text = self.currentModel.count;
    self.signTF.text = self.currentModel.sign;
}
- (IBAction)saveButtonClick:(id)sender {
    PileLoginModel *newModel = [PileLoginModel new];
    
    newModel.pileNum = self.pileNumTF.text;
    newModel.pileVersion = self.pileVTF.text;
    newModel.pileType = self.pileTypeTF.text;
    newModel.totalKw = self.totalKwTF.text;
    newModel.lon = self.lonTF.text;
    newModel.lat = self.latTF.text;
    newModel.providerID = self.providerNumTF.text;
    newModel.magicNum = self.magicNumTF.text;
    newModel.count = self.countTF.text;
    newModel.sign = self.signTF.text;
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
