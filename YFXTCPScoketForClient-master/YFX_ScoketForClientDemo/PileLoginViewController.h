//
//  PileLoginViewController.h
//  YFX_ScoketForClientDemo
//
//  Created by KlayThompson on 2019/10/7.
//  Copyright © 2019 fangxue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PileLoginModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SaveBlock)(PileLoginModel *model);

@interface PileLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *pileNumTF;
@property (weak, nonatomic) IBOutlet UITextField *pileTypeTF;
@property (weak, nonatomic) IBOutlet UITextField *pileVTF;
@property (weak, nonatomic) IBOutlet UITextField *totalKwTF;
@property (weak, nonatomic) IBOutlet UITextField *lonTF;
@property (weak, nonatomic) IBOutlet UITextField *latTF;
@property (weak, nonatomic) IBOutlet UITextField *providerNumTF;
@property (weak, nonatomic) IBOutlet UITextField *magicNumTF;
@property (weak, nonatomic) IBOutlet UITextField *countTF;
@property (weak, nonatomic) IBOutlet UITextField *signTF;


@property (nonatomic, strong) PileLoginModel *currentModel;

@property (nonatomic, copy) SaveBlock saveBlock;



@end

NS_ASSUME_NONNULL_END
