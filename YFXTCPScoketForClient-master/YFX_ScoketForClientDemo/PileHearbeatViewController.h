//
//  PileHearbeatViewController.h
//  YFX_ScoketForClientDemo
//
//  Created by KlayThompson on 2019/10/7.
//  Copyright © 2019 fangxue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PileHeartbeatModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HeartbeatBlock)(PileHeartbeatModel *model);


@interface PileHearbeatViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *pileStatusTF;
@property (weak, nonatomic) IBOutlet UITextField *outputVTF;
@property (weak, nonatomic) IBOutlet UITextField *outputATF;
@property (weak, nonatomic) IBOutlet UITextField *totalKwhTF;
@property (weak, nonatomic) IBOutlet UITextField *pileTTF;
@property (weak, nonatomic) IBOutlet UITextField *switchStatusTF;
@property (weak, nonatomic) IBOutlet UITextField *switchPowerTF;

@property (weak, nonatomic) IBOutlet UITextField *sendTimeTF;

@property (nonatomic, strong) PileHeartbeatModel *currentModel;

@property (nonatomic, copy) HeartbeatBlock saveBlock;


@end

NS_ASSUME_NONNULL_END
