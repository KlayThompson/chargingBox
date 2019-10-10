//
//  SettingViewController.h
//  YFX_ScoketForClientDemo
//
//  Created by KlayThompson on 2019/9/27.
//  Copyright © 2019 fangxue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoxModel.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^BoxSaveBlock)(BoxModel *newModel);

@interface SettingViewController : UIViewController


@property (nonatomic, strong) BoxModel *currentModel;
@property (weak, nonatomic) IBOutlet UITextField *boxIDTF;
@property (weak, nonatomic) IBOutlet UITextField *boxVTF;
@property (weak, nonatomic) IBOutlet UITextField *boxTypeTF;
@property (weak, nonatomic) IBOutlet UITextField *boxNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *boxStatusTF;
@property (weak, nonatomic) IBOutlet UITextField *inputVTF;
@property (weak, nonatomic) IBOutlet UITextField *inputATF;
@property (weak, nonatomic) IBOutlet UITextField *boxPowerTF;
@property (weak, nonatomic) IBOutlet UITextField *boxTemperture;
@property (weak, nonatomic) IBOutlet UITextField *boxHumidityTF;

@property (nonatomic, copy) BoxSaveBlock saveBlock;

@end

NS_ASSUME_NONNULL_END
