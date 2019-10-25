//
//  ChargingPileViewController.h
//  YFX_ScoketForClientDemo
//
//  Created by KlayThompson on 2019/10/7.
//  Copyright © 2019 fangxue. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChargingPileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (nonatomic, strong) NSData *serialNumData;
@end

NS_ASSUME_NONNULL_END
