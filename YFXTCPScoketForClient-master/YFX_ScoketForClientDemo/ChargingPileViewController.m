//
//  ChargingPileViewController.m
//  YFX_ScoketForClientDemo
//
//  Created by KlayThompson on 2019/10/7.
//  Copyright © 2019 fangxue. All rights reserved.
//

#import "ChargingPileViewController.h"
#import "PileLoginViewController.h"
#import "PileHearbeatViewController.h"
#import "PileHeartbeatModel.h"
#import "PileLoginModel.h"
#import "GCDAsyncSocket.h"
#import "Tools.h"
#import "PileOrderViewController.h"

@interface ChargingPileViewController ()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *clientSocket;
@property (nonatomic, strong) NSMutableString *logStr;

@property (nonatomic, strong) PileHeartbeatModel *heartbeatModel;
@property (nonatomic, strong) PileLoginModel *loginModel;
@property (weak, nonatomic) IBOutlet UIButton *heartbeatButton;
@property (nonatomic, strong) PileOrderModel *chargingModel;
@property (nonatomic, strong) PileOrderModel *orderModel;

@property (nonatomic, assign) BOOL isHeartbeating;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int duration;

@property (nonatomic, assign) BOOL isSendChargingData;
@property (nonatomic, strong) NSTimer *chargingTimer;
@end

@implementation ChargingPileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.heartbeatModel = [PileHeartbeatModel new];
    self.loginModel = [PileLoginModel new];
    self.duration = self.heartbeatModel.sendTime.intValue;
    
    self.tipLabel.text = @"...";
    self.logStr = [[NSMutableString alloc] initWithString:@""];
    self.isHeartbeating = false;
    
    self.chargingModel = [PileOrderModel new];
    self.orderModel = [PileOrderModel new];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.timer  setFireDate:[NSDate distantFuture]];
    [self.chargingTimer setFireDate:[NSDate distantFuture]];
    [self.clientSocket disconnect];
}

#pragma mark - SOCKET Delegate
//客户端链接服务器成功
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    
    [self showLogWithStr:[NSString stringWithFormat:@"链接成功，服务器：%@",host]];
    
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err {
    [self showLogWithStr:@"与服务器断开连接成功"];
}

//成功读取服务端发过来的消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    NSString *str = [Tools convertDataToHexStrWithData:data];
    if ([str hasPrefix:@"aa50"]) {// 登录签到
        [self analyseReciveLoginDataWithStr:str];
    } else if ([str hasPrefix:@"aa51"]) {// 上报心跳
        [self showLogWithStr:[NSString stringWithFormat:@"充电桩上报心跳状态成功，服务端发过来的消息 = \n%@",data]];
    } else if ([str hasPrefix:@"aa54"]) {// 刷卡信息上报
        [self analyseSwipeCardDataWithStr:str];
    } else if ([str hasPrefix:@"aa56"]) {// 上报充电订单
        [self analyseChargeOrderWithString:str];
    } else if ([str isEqualToString:@"aa66"]) {// 收到开启指定开关
        [self analyseOpenSwitchInstruct:str];
    } else if ([str isEqualToString:@"aa68"]) {// 收到远程停止充电
        [self analyseStopChargingInstruct:str];
    }
    else {
        [self showLogWithStr:[NSString stringWithFormat:@"读取服务端发过来的消息 = %@",data]];
    }
    [self.clientSocket readDataWithTimeout:-1 tag:0];
    
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    [self showLogWithStr:@"数据写入成功"];
}

#pragma mark - Action&SendData
- (IBAction)connectButtonClick:(id)sender {
    //1.创建客户端scoket
    self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //2.链接服务器socket 192.168.0.113为服务端IP
    BOOL result = [self.clientSocket connectToHost:@"172.16.1.2" onPort:8009 error:nil];
    //判断链接
    if (result) {
        //成功
        NSLog(@"链接成功");
    }else{
        //失败
        NSLog(@"链接失败");
    }
}
- (IBAction)disconnectButtonClick:(id)sender {
    [self.timer  setFireDate:[NSDate distantFuture]];
    [self.chargingTimer setFireDate:[NSDate distantFuture]];
    [self.clientSocket disconnect];
}

- (IBAction)swipeCardButtonClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Title" message:nil preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
        UITextField *switchNumTf = alert.textFields.firstObject;
        UITextField *cardNumTf = alert.textFields.lastObject;

        [self swipeCardWithSwitchNum:switchNumTf.text cardNum:cardNumTf.text];
        NSLog(@"OK pushed");
    }]];

    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入开关号";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入卡号";
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];

    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)uploadErrorButtonClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Title" message:nil preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
        UITextField *code = alert.textFields.firstObject;

        [self uploadSwitchErrorWithErrorCode:code.text];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];

    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入故障信息代码";
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)loginWithModel:(PileLoginModel *)model {

    unsigned char send[8] = {0x68, 0x50, 0x00, 0x00, 51, 0x00, 0x00};
    NSData *sendData = [NSData dataWithBytes:send length:8];
    
    NSMutableData *bodyData = [NSMutableData new];

    
    NSString *pileNum = [Tools hexStringFromString:model.pileNum];
    NSData *pileNumData = [Tools hexToBytes:pileNum length:20];
    [bodyData appendData:pileNumData];

    NSString *pileVersion = [Tools hexStringFromString:model.pileVersion];
    NSData *pileVersionData = [Tools hexToBytes:pileVersion length:10];
    [bodyData appendData:pileVersionData];
    
    unsigned char body[4] = {[Tools remove0xStringWithString:model.pileType].intValue,0x01,0x02,0x03};
    NSData *data = [NSData dataWithBytes:body length:4];
    [bodyData appendData:data];
    
    double chargeKw = model.totalKw.doubleValue * 100;
    NSString *chargeKwStr = [Tools reverseWithString:[Tools getHexByDecimal:(int)chargeKw]];
    [bodyData appendData:[Tools convertHexStrToData:chargeKwStr length:2]];
    
    double lonD = model.lon.doubleValue * 100000;
    NSString *lonByteStr = [Tools reverseWithString:[Tools getHexByDecimal:(int)lonD]];
    NSData *lonData = [Tools convertHexStrToData:lonByteStr length:4];
    [bodyData appendData:[NSData dataWithBytes:[lonData bytes] length:4]];

    double latD = model.lat.doubleValue * 100000;
    NSString *str = [Tools getHexByDecimal:latD];
    NSString *latByteStr = [Tools reverseWithString:str];
    NSData *latData =[Tools convertHexStrToData:latByteStr length:4];
    [bodyData appendData:[NSData dataWithBytes:[latData bytes] length:4]];
    
    unsigned char provider[1] = {model.providerID.intValue};
    [bodyData appendData:[NSData dataWithBytes:provider length:1]];
    
    NSString *magicByteStr = [Tools reverseWithString:[Tools getHexByDecimal:model.magicNum.intValue]];
    NSData *magicData = [Tools convertHexStrToData:magicByteStr length:4];
    [bodyData appendData:[NSData dataWithBytes:[magicData bytes] length:4]];
    
    unsigned char other[2] = {model.count.intValue,model.sign.intValue};
    [bodyData appendData:[NSData dataWithBytes:other length:2]];
    NSMutableData *finalData = [NSMutableData dataWithData:sendData];
    [finalData appendData:bodyData];
    
    [self.clientSocket writeData:finalData withTimeout:-1 tag:0];
}

- (void)heartbeat {
    
    NSInteger len = 11 + self.loginModel.count.intValue*3;
    unsigned char send[8] = {0x68, 0x51, 0x00, 0x00, len, 0x00, 0x00};
    NSData *sendData = [NSData dataWithBytes:send length:8];
    
    NSMutableData *bodyData = [NSMutableData new];
    
    unsigned char status[1] = {[Tools remove0xStringWithString:self.heartbeatModel.pileStatus].intValue};
    [bodyData appendData:[NSData dataWithBytes:status length:1]];
    
    double outputV = self.heartbeatModel.outputV.doubleValue * 100;
    [bodyData appendData:[Tools convertHexStrToData:[Tools reverseWithString:[Tools getHexByDecimal:(int)outputV]] length:2]];
    
    double outputA = self.heartbeatModel.outputA.doubleValue * 100;
    [bodyData appendData:[Tools convertHexStrToData:[Tools reverseWithString:[Tools getHexByDecimal:(int)outputA]] length:2]];

    NSString *chargePowerByteStr = [Tools reverseWithString:[Tools getHexByDecimal:self.heartbeatModel.chargeKwh.intValue]];
    NSData *chargePowerData = [Tools convertHexStrToData:chargePowerByteStr length:4];
    [bodyData appendData:[NSData dataWithBytes:[chargePowerData bytes] length:4]];
    
    double temp = self.heartbeatModel.pileTem.doubleValue * 100;
    [bodyData appendData:[Tools convertHexStrToData:[Tools reverseWithString:[Tools getHexByDecimal:(int)temp]] length:2]];
    
    for (int i = 0; i < self.loginModel.count.intValue; i++) {
        int status;
        if (i == 2) {
            status = 3;
        } else if (i > 2) {
            status = 0;
        } else {
            status = i;
        }
        unsigned char switchStatus[1] = {status};
        [bodyData appendData:[NSData dataWithBytes:switchStatus length:1]];
        double switchKwh = self.heartbeatModel.switchKwh.doubleValue * 100;
        [bodyData appendData:[Tools convertHexStrToData:[Tools reverseWithString:[Tools getHexByDecimal:(int)switchKwh]] length:2]];
    }
    
    NSMutableData *finalData = [NSMutableData dataWithData:sendData];
    [finalData appendData:bodyData];
    [self.clientSocket writeData:finalData withTimeout:-1 tag:0];
}

- (void)swipeCardWithSwitchNum:(NSString *)switchNum cardNum:(NSString *)cardNum {
    //刷卡充电，需要第一步插上插座，需调用开关事件上报
    [self switchHaveChangedWithSwitchNum:switchNum status:@"0x00" event:@"0x01"];
    
    [NSThread sleepForTimeInterval:1];
    //调用刷卡信息上报
    unsigned char send[8] = {0x68, 0x54, 0x00, 0x00, 22, 0x00, 0x00};
    NSData *sendData = [NSData dataWithBytes:send length:8];
    
    NSMutableData *bodyData = [NSMutableData new];
    
    unsigned char some[2] = {cardNum.length,switchNum.intValue};
    [bodyData appendData:[NSData dataWithBytes:some length:2]];
    
    [bodyData appendData:[Tools hexToBytes:[Tools hexStringFromString:cardNum] length:20]];

    NSMutableData *finalData = [NSMutableData dataWithData:sendData];
    [finalData appendData:bodyData];
    
    [self.clientSocket writeData:finalData withTimeout:-1 tag:0];
    
}

- (void)switchHaveChangedWithSwitchNum:(NSString *)switchNum status:(NSString *)status event:(NSString *)event {
    unsigned char send[8] = {0x68, 0x57, 0x00, 0x00, 7, 0x00, 0x00};
    NSData *sendData = [NSData dataWithBytes:send length:8];
    
    NSMutableData *bodyData = [NSMutableData new];
    
    unsigned char some[3] = {switchNum.intValue,[Tools remove0xStringWithString:status].intValue,[Tools remove0xStringWithString:event].intValue};
    [bodyData appendData:[NSData dataWithBytes:some length:3]];
    
    NSString *timeStr = [Tools currentdateInterval];
    NSString *time = [Tools reverseWithString:[Tools getHexByDecimal:timeStr.intValue]];
    [bodyData appendData:[Tools convertHexStrToData:time length:4]];
    NSMutableData *finalData = [NSMutableData dataWithData:sendData];
    [finalData appendData:bodyData];
    
    [self.clientSocket writeData:finalData withTimeout:-1 tag:0];
}
//上报充电中数据
- (void)uploadChargingData {
    unsigned char send[8] = {0x68, 0x55, 0x00, 0x00, 53, 0x00, 0x00};
    NSData *sendData = [NSData dataWithBytes:send length:8];
    
    NSMutableData *bodyData = [NSMutableData new];

    unsigned char switchNum[1] = {self.chargingModel.switchNum.intValue};
    [bodyData appendData:[NSData dataWithBytes:switchNum length:1]];
    
//    NSString *userId = [Tools reverseWithString:[Tools getHexByDecimal:self.chargingModel.userId.intValue]];
//    [bodyData appendData:[Tools convertHexStrToData:userId length:4]];
    
    NSString *serialNumStr = [Tools reverseWithString:[Tools getHexByDecimal:self.chargingModel.serialNum.intValue]];
    [bodyData appendData:[Tools convertHexStrToData:serialNumStr length:36]];
    
    double chargeKwh = self.chargingModel.chargeKwh.doubleValue * 100;
    NSString *chargeKwhStr = [Tools reverseWithString:[Tools getHexByDecimal:(int)chargeKwh]];
    [bodyData appendData:[Tools convertHexStrToData:chargeKwhStr length:2]];
    
    double chargeW = self.chargingModel.chargeW.doubleValue * 100;
    NSString *chargeWStr = [Tools reverseWithString:[Tools getHexByDecimal:(int)chargeW]];
    [bodyData appendData:[Tools convertHexStrToData:chargeWStr length:2]];
    
    double currentV = self.chargingModel.currentV.doubleValue * 100;
    [bodyData appendData:[Tools convertHexStrToData:[Tools reverseWithString:[Tools getHexByDecimal:(int)currentV]] length:2]];
    
    double currentA = self.chargingModel.currentV.doubleValue * 100;
    [bodyData appendData:[Tools convertHexStrToData:[Tools reverseWithString:[Tools getHexByDecimal:(int)currentA]] length:2]];
    
    NSString *startTime = [Tools reverseWithString:[Tools getHexByDecimal:self.chargingModel.startTime.intValue]];
    [bodyData appendData:[Tools convertHexStrToData:startTime length:4]];
    
    NSString *duration = [Tools reverseWithString:[Tools getHexByDecimal:self.chargingModel.duration.intValue]];
    [bodyData appendData:[Tools convertHexStrToData:duration length:4]];
    
    NSMutableData *finalData = [NSMutableData dataWithData:sendData];
    [finalData appendData:bodyData];
    
    [self.clientSocket writeData:finalData withTimeout:-1 tag:0];
}

//上报充电订单
- (void)uploadChargeOrder:(PileOrderModel *)model {
    unsigned char send[8] = {0x68, 0x56, 0x00, 0x00, 52, 0x00, 0x00};
    NSData *sendData = [NSData dataWithBytes:send length:8];
    
    NSMutableData *bodyData = [NSMutableData new];

    unsigned char switchNum[1] = {model.switchNum.intValue};
    [bodyData appendData:[NSData dataWithBytes:switchNum length:1]];
    
//    NSString *userId = [Tools reverseWithString:[Tools getHexByDecimal:model.userId.intValue]];
//    [bodyData appendData:[Tools convertHexStrToData:userId length:4]];
    
    NSString *serialNumStr = [Tools reverseWithString:[Tools getHexByDecimal:model.serialNum.intValue]];
    [bodyData appendData:[Tools convertHexStrToData:serialNumStr length:36]];
    
    double chargeKwh = model.chargeKwh.doubleValue * 100;
    NSString *chargeKwhStr = [Tools reverseWithString:[Tools getHexByDecimal:(int)chargeKwh]];
    [bodyData appendData:[Tools convertHexStrToData:chargeKwhStr length:2]];
    
    NSString *startTime = [Tools reverseWithString:[Tools getHexByDecimal:model.startTime.intValue]];
    [bodyData appendData:[Tools convertHexStrToData:startTime length:4]];
    
    NSString *stopTime = [Tools reverseWithString:[Tools getHexByDecimal:model.stopTime.intValue]];
    [bodyData appendData:[Tools convertHexStrToData:stopTime length:4]];
    
    NSString *duration = [Tools reverseWithString:[Tools getHexByDecimal:model.duration.intValue]];
    [bodyData appendData:[Tools convertHexStrToData:duration length:4]];
    
    [bodyData appendData:[Tools convertHexStrToData:[Tools remove0xStringWithString:model.stopReason] length:1]];
    NSMutableData *finalData = [NSMutableData dataWithData:sendData];
    [finalData appendData:bodyData];
    
    [self.clientSocket writeData:finalData withTimeout:-1 tag:0];
}

- (void)uploadSwitchErrorWithErrorCode:(NSString *)errorCode {
    unsigned char send[8] = {0x68, 0x53, 0x00, 0x00, 10, 0x00, 0x00};
    NSData *sendData = [NSData dataWithBytes:send length:8];
    
    NSMutableData *bodyData = [NSMutableData new];

    unsigned char some[2] = {0x02,0x01};
    [bodyData appendData:[NSData dataWithBytes:some length:2]];
    
    NSString *error = [Tools hexStringFromString:errorCode];
    [bodyData appendData:[Tools hexToBytes:error length:4]];
    
    NSString *startTime = [Tools reverseWithString:[Tools getHexByDecimal:[Tools currentdateInterval].intValue]];
    [bodyData appendData:[Tools convertHexStrToData:startTime length:4]];
    
    NSMutableData *finalData = [NSMutableData dataWithData:sendData];
    [finalData appendData:bodyData];
    
    [self.clientSocket writeData:finalData withTimeout:-1 tag:0];
}

#pragma mark - 解析返回数据
//登录签到信息解析
- (void)analyseReciveLoginDataWithStr:(NSString *)str {
    NSString *sign16 = [str substringWithRange:NSMakeRange(str.length - 12, 2)];
    NSString *sign10 = [Tools hexToDecimalWithString:[Tools reverseWithString:sign16]];

    //验证结果
    NSString *result16 = [str substringWithRange:NSMakeRange(str.length - 10, 2)];
    NSString *result10 = [Tools hexToDecimalWithString:[Tools reverseWithString:result16]];
    NSString *status = @"";
    if (result10.intValue == 1) {
        status = @"该充电桩未注册";
    } else if (result10.intValue == 0) {
        status = @"该充电桩已注册";
    } else {
        status = @"Undefined";
    }

    NSString *time16 = [str substringWithRange:NSMakeRange(str.length - 8, 8)];
    NSString *time10 = [Tools hexToDecimalWithString:[Tools reverseWithString:time16]];
    NSString *time = [Tools timeStrWithEnglish:time10.intValue];
    [self showLogWithStr:[NSString stringWithFormat:@"登录签到成功：\n签名为：%@\n%@\n服务器下发的时间戳为%@", sign10,status, time]];
}
//刷卡信息解析
- (void)analyseSwipeCardDataWithStr:(NSString *)str {
    NSString *result16 = [str substringWithRange:NSMakeRange(str.length - 2, 2)];
    NSString *result10 = [Tools hexToDecimalWithString:[Tools reverseWithString:result16]];
    NSString *status = @"";
    if (result10.intValue == 0) {
        status = @"验证通过";
    } else if (result10.intValue == 1) {
        status = @"未注册IC卡";
    } else if (result10.intValue == 2) {
        status = @"套餐过期";
    } else if (result10.intValue == 3) {
        status = @"账户欠费";
    } else if (result10.intValue == 4) {
        status = @"有待支付订单";
    } else if (result10.intValue == 5) {
        status = @"没有使用权限";
    } else {
        status = @"其他原因";
    }
    [self showLogWithStr:[NSString stringWithFormat:@"刷卡返回结果为：%@", status]];
}

//上报充电订单解析
- (void)analyseChargeOrderWithString:(NSString *)str {
    NSString *serialNum = [Tools hexToDecimalWithString:[Tools reverseWithString:[str substringWithRange:NSMakeRange(str.length - 36, 36)]]];
//    NSString *userId = [Tools hexToDecimalWithString:[Tools reverseWithString:[str substringWithRange:NSMakeRange(str.length - 16, 8)]]];
    NSString *switchNum = [Tools hexToDecimalWithString:[str substringWithRange:NSMakeRange(str.length - 37, 1)]];
    [self showLogWithStr:[NSString stringWithFormat:@"订单上报成功，开关编号：%@，流水号：%@", switchNum, serialNum]];
}

//开启指定开关
- (void)analyseOpenSwitchInstruct:(NSString *)str {
//    NSString *userId = [Tools hexToDecimalWithString:[Tools reverseWithString:[str substringWithRange:NSMakeRange(str.length - 20, 8)]]];
    NSString *serialNum = [Tools hexToDecimalWithString:[Tools reverseWithString:[str substringWithRange:NSMakeRange(str.length - 38, 36)]]];
    NSString *switchNum = [Tools hexToDecimalWithString:[str substringWithRange:NSMakeRange(str.length - 1, 1)]];
    
    //响应指令
    unsigned char send[8] = {0xaa, 0x66, 0x00, 0x00, 37, 0x00, 0x00};
    NSData *sendData = [NSData dataWithBytes:send length:8];
    NSMutableData *bodyData = [NSMutableData new];
//    NSString *userIdRes = [Tools reverseWithString:[Tools getHexByDecimal:userId.intValue]];
//    [bodyData appendData:[Tools convertHexStrToData:userIdRes length:4]];
    unsigned char some[1] = {switchNum.intValue};
    [bodyData appendData:[NSData dataWithBytes:some length:1]];
    NSString *serialNumStr = [Tools reverseWithString:[Tools getHexByDecimal:serialNum.intValue]];
    [bodyData appendData:[Tools convertHexStrToData:serialNumStr length:36]];
    NSMutableData *finalData = [NSMutableData dataWithData:sendData];
    [finalData appendData:bodyData];
    [self.clientSocket writeData:finalData withTimeout:-1 tag:0];
    
    //需要上报开关状态
    [self switchHaveChangedWithSwitchNum:switchNum status:@"0x03" event:@"0x03"];
    
    //定时上报充电订单
    [self uploadChargingData]; // 不做定时处理了，简化处理，上传一次
    
    [self showLogWithStr:[NSString stringWithFormat:@"收到平台下发开启指定开关指令，开关编号：%@，流水号：%@", switchNum, serialNum]];
}

//远程停止充电
- (void)analyseStopChargingInstruct:(NSString *)str {
    NSString *switchNum = [Tools hexToDecimalWithString:[str substringWithRange:NSMakeRange(str.length - 2, 2)]];

    //响应指令
    unsigned char send[8] = {0xaa, 0x68, 0x00, 0x00, 0x00, 0x00, 0x00};
    NSData *sendData = [NSData dataWithBytes:send length:8];
    [self.clientSocket writeData:sendData withTimeout:-1 tag:0];
    //上报充电订单
    [self uploadChargeOrder:self.orderModel];
    //上报开关状态
    [self switchHaveChangedWithSwitchNum:switchNum status:@"0x00" event:@"0x04"];
    
    [self showLogWithStr:[NSString stringWithFormat:@"收到平台下发远程停止充电指令，内容为：%@", str]];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    __weak typeof (self) weakSelf = self;
    if ([segue.identifier isEqualToString:@"pile_login"]) {
        PileLoginViewController *login = (PileLoginViewController *)segue.destinationViewController;
        login.currentModel = self.loginModel;
        login.saveBlock = ^(PileLoginModel * _Nonnull model) {
            [weakSelf loginWithModel:model];
        };
    } else if ([segue.identifier isEqualToString:@"pile_heartbeat"]) {
        PileHearbeatViewController *heartbeat = (PileHearbeatViewController *)segue.destinationViewController;
        heartbeat.currentModel = self.heartbeatModel;
        heartbeat.saveBlock = ^(PileHeartbeatModel * _Nonnull model) {
            weakSelf.heartbeatModel = model;
            weakSelf.duration = model.sendTime.intValue;
            if (_timer) {
                self.timer = nil;
            }
            [weakSelf.timer setFireDate:[NSDate distantPast]];
            weakSelf.isHeartbeating = YES;
            [weakSelf.heartbeatButton setTitle:@"停止心跳" forState:UIControlStateNormal];
        };
    } else if ([segue.identifier isEqualToString:@"charging_status"]) {
        PileOrderViewController *order = (PileOrderViewController *)segue.destinationViewController;
        __weak typeof (self) weakSelf = self;
        order.orderModel = self.orderModel;
        order.isSending = self.isSendChargingData;
        order.chargeOrderBlock = ^(PileOrderModel * _Nonnull model) {
            weakSelf.orderModel = model;
            //上报充电订单
            [weakSelf uploadChargeOrder:model];
            //上报开关状态
            [weakSelf switchHaveChangedWithSwitchNum:model.switchNum status:@"0x00" event:@"0x02"];
        };
        order.chargingBlock = ^(PileOrderModel * _Nonnull model) {
            //上报充电中数据，一分钟一次
            weakSelf.chargingModel = model;
            NSLog(@"");
//            [weakSelf uploadChargingData];
            [weakSelf.chargingTimer setFireDate:[NSDate distantPast]];
            weakSelf.isSendChargingData = YES;
        };
        order.stopBlock = ^{
            //停止上报充电中数据
            [weakSelf.chargingTimer setFireDate:[NSDate distantFuture]];
            weakSelf.isSendChargingData = NO;
        };
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([identifier isEqualToString:@"pile_heartbeat"]) {
        if (self.isHeartbeating) {
            //停止
            self.isHeartbeating = NO;
            [self.timer  setFireDate:[NSDate distantFuture]];
            if (_timer) {
                self.timer = nil;
            }
            [self.heartbeatButton setTitle:@"心跳" forState:UIControlStateNormal];
            return NO;
        } else {
            return YES;
        }
    }
    
    return YES;//执行跳转方法
}
- (IBAction)exitToHere:(UIStoryboardSegue *)sender {
    
}

- (void)showLogWithStr:(NSString *)str {
    NSLog(@"%@", str);
    [self.logStr appendString:[NSString stringWithFormat:@"%@\n", str]];
    self.tipLabel.text = self.logStr;
}

//- (NSTimer *)checkChargingTimer {
//    if (_checkChargingTimer == nil) {
//        _checkChargingTimer = [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(checkChargingState) userInfo:nil repeats:YES];
//    }
//    return _checkChargingTimer;
//}
- (IBAction)clearLogButtonClick:(id)sender {
    self.logStr = [[NSMutableString alloc] initWithString:@""];
    self.tipLabel.text = self.logStr;
}

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.duration target:self selector:@selector(heartbeat) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (NSTimer *)chargingTimer {
    if (_chargingTimer == nil) {
        _chargingTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(uploadChargingData) userInfo:nil repeats:YES];
    }
    return _chargingTimer;
}
@end
