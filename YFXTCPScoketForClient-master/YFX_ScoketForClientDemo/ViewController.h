//
//  ViewController.h
//  YFX_ScoketForClientDemo
//
//  Created by fangxue on 2017/1/9.
//  Copyright © 2017年 fangxue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoxModel.h"
#import "OrderModel.h"
#import "OrderSettingViewController.h"

@class BatteryModel;

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *box1;
@property (weak, nonatomic) IBOutlet UIButton *box2;
@property (weak, nonatomic) IBOutlet UIButton *box3;
@property (weak, nonatomic) IBOutlet UIButton *box4;
@property (weak, nonatomic) IBOutlet UIButton *box5;
@property (weak, nonatomic) IBOutlet UIButton *box6;
@property (weak, nonatomic) IBOutlet UIButton *box7;
@property (weak, nonatomic) IBOutlet UIButton *box8;
@property (weak, nonatomic) IBOutlet UIButton *box9;
@property (weak, nonatomic) IBOutlet UIButton *box10;
@property (weak, nonatomic) IBOutlet UIButton *box11;


@property (nonatomic, strong) BatteryModel *box1Model;
@property (nonatomic, strong) BatteryModel *box2Model;
@property (nonatomic, strong) BatteryModel *box3Model;
@property (nonatomic, strong) BatteryModel *box4Model;
@property (nonatomic, strong) BatteryModel *box5Model;
@property (nonatomic, strong) BatteryModel *box6Model;
@property (nonatomic, strong) BatteryModel *box7Model;
@property (nonatomic, strong) BatteryModel *box8Model;
@property (nonatomic, strong) BoxModel *boxModel;
@property (nonatomic, strong) OrderModel *orderModel;

@end

