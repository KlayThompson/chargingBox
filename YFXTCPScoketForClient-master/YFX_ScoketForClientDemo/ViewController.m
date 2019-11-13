//
//  ViewController.m
//  YFX_ScoketForClientDemo
//
//  Created by fangxue on 2017/1/9.
//  Copyright © 2017年 fangxue. All rights reserved.
//

// 两个字节的也需要翻转



#import "ViewController.h"
#import "GCDAsyncSocket.h"
#import "Tools.h"
#import "BoxDetailViewController.h"
#import "SettingViewController.h"


@interface ViewController ()<GCDAsyncSocketDelegate>

//客户端socket
@property (nonatomic, strong) GCDAsyncSocket *clientSocket;
@property (weak, nonatomic) IBOutlet UILabel *logLabel;
@property (nonatomic, strong) NSMutableString *logStr;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, copy) NSMutableArray *boxArray;
@property (nonatomic, strong) NSData *serialNumData;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self initStatus];
    
}
#pragma mark ------------
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
    
    [self showLogWithStr:[NSString stringWithFormat:@"读取服务端发过来的消息 = %@",data]];
    NSString *str = [Tools convertDataToHexStrWithData:data];
    if ([str hasPrefix:@"682a"]) { //打开仓门
        [self analyseOpenDoorWithData:data];
    }
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    [self showLogWithStr:@"数据写入成功"];
}

#pragma mark - Analyse
- (void)analyseOpenDoorWithData:(NSData *)data {
    NSString *str = [Tools convertDataToHexStrWithData:data];
    NSData *serialNumD = [data subdataWithRange:NSMakeRange(8, 36)];
    self.serialNumData = serialNumD;
    NSString *boxId = [Tools hexToDecimalWithString:[str substringWithRange:NSMakeRange(str.length - 2, 2)]];
    NSString *action = [Tools hexToDecimalWithString:[str substringWithRange:NSMakeRange(str.length - 4, 2)]];
    NSString *actionStr = action.intValue == 0 ? @"还电池" : @"取电池";
    [self showLogWithStr:[NSString stringWithFormat:@"收到开电池仓门指令，流水号data：%@，状态为：%@，电池仓ID为：%@", serialNumD, actionStr, boxId]];
    
    //回复
    unsigned char send[8] = {0xaa, 0x2A, 0x00, 0x00, 37, 0x00, 0x00};
    NSData *sendData = [NSData dataWithBytes:send length:8];
    
    NSMutableData *bodyData = [NSMutableData new];

    [bodyData appendData:serialNumD];
    unsigned char boxID[1] = {boxId.intValue};
    [bodyData appendData:[NSData dataWithBytes:boxID length:1]];
    NSMutableData *finalData = [NSMutableData dataWithData:sendData];
    [finalData appendData:bodyData];
    
    [self.clientSocket writeData:finalData withTimeout:-1 tag:0];
}

#pragma mark - Action

- (IBAction)open:(id)sender {
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
- (IBAction)close:(id)sender {
    [self.clientSocket disconnect];
}
- (IBAction)initSocket:(id)sender {
    [self initStatus];
}
- (IBAction)login:(id)sender {
    
    unsigned char send[8] = {0x68, 0x10, 0x00, 0x00, 49, 0x00, 0x00};
    NSData *sendData = [NSData dataWithBytes:send length:8];
    
    NSMutableData *bodyData = [NSMutableData new];

    NSString *boxStr = self.boxModel.boxId;
    NSString *boxStr16 = [Tools hexStringFromString:boxStr];
    NSData *boxData = [Tools hexToBytes:boxStr16 length:20];
    [bodyData appendData:boxData];

    
    NSString *batteryStr = self.boxModel.boxV;
    NSString *batteryStr16 = [Tools hexStringFromString:batteryStr];
    NSData *batteryData = [Tools hexToBytes:batteryStr16 length:10];
    [bodyData appendData:batteryData];
    
    
    unsigned char body[4] = {self.boxModel.boxType.intValue,0x01,0x02,0x03};
    NSData *data = [NSData dataWithBytes:body length:4];
    [bodyData appendData:data];
    
    NSString *lonStr = @"116.397128";
    double lonD = lonStr.doubleValue * 100000;
    NSString *lonByteStr = [Tools reverseWithString:[Tools getHexByDecimal:(int)lonD]];
    NSData *lonData = [Tools convertHexStrToData:lonByteStr length:4];
    [bodyData appendData:[NSData dataWithBytes:[lonData bytes] length:4]];

    NSString *latStr = @"39.916527";
    double latD = latStr.doubleValue * 100000;
    NSString *str = [Tools getHexByDecimal:(int)latD];
    NSString *latByteStr = [Tools reverseWithString:str];
    NSData *latData =[Tools convertHexStrToData:latByteStr length:4];
    [bodyData appendData:[NSData dataWithBytes:[latData bytes] length:4]];
    
    unsigned char provider[1] = {0x09};
    [bodyData appendData:[NSData dataWithBytes:provider length:1]];
    
    NSString *magicNum = @"1234";
    NSString *magicByteStr = [Tools reverseWithString:[Tools getHexByDecimal:magicNum.intValue]];
    NSData *magicData = [Tools convertHexStrToData:magicByteStr length:4];
    [bodyData appendData:[NSData dataWithBytes:[magicData bytes] length:4]];
    
    unsigned char other[2] = {self.boxModel.boxNumber.intValue,10};
    [bodyData appendData:[NSData dataWithBytes:other length:2]];
    
    NSMutableData *finalData = [NSMutableData dataWithData:sendData];
    [finalData appendData:bodyData];
    

    [self.clientSocket writeData:finalData withTimeout:-1 tag:0];
}

- (IBAction)heartbeat:(UIButton *)sender {
//    sender.selected = !sender.selected;
//    [sender setBackgroundColor:[UIColor orangeColor]];
    //开始上报心跳
    unsigned char send[8] = {0x68, 0x11, 0x00, 0x00, 13, 0x00, 0x00};
    NSData *sendData = [NSData dataWithBytes:send length:8];
    
    NSMutableData *bodyData = [NSMutableData new];
    
    unsigned char status[1] = {[Tools remove0xStringWithString:self.boxModel.boxStatus].intValue};
    [bodyData appendData:[NSData dataWithBytes:status length:1]];
    
    double inputV = self.boxModel.inputV.doubleValue * 100;
    NSString *inputVStr = [Tools reverseWithString:[Tools getHexByDecimal:(int)inputV]];
    [bodyData appendData:[Tools convertHexStrToData:inputVStr length:2]];
    
    double inputA = self.boxModel.inputA.doubleValue * 100;
    NSString *inputAStr = [Tools reverseWithString:[Tools getHexByDecimal:(int)inputA]];
    [bodyData appendData:[Tools convertHexStrToData:inputAStr length:2]];
    
    double power = self.boxModel.boxChargePower.doubleValue * 100;
    NSString *powerStr = [Tools reverseWithString:[Tools getHexByDecimal:(int)power]];
    [bodyData appendData:[Tools hexToBytes:powerStr length:4]];
    
    double temp = self.boxModel.boxTemperature.doubleValue * 100;
    NSString *tempStr = [Tools reverseWithString:[Tools getHexByDecimal:(int)temp]];
    [bodyData appendData:[Tools convertHexStrToData:tempStr length:2]];
    
    double hum = self.boxModel.boxHumidity.doubleValue * 100;
    NSString *humStr = [Tools reverseWithString:[Tools getHexByDecimal:(int)hum]];
    [bodyData appendData:[Tools convertHexStrToData:humStr length:2]];
    
//    unsigned char count[1] = {self.boxModel.boxNumber.intValue};
//    [bodyData appendData:[NSData dataWithBytes:count length:1]];
    
    NSMutableData *finalData = [NSMutableData dataWithData:sendData];
    [finalData appendData:bodyData];
    [self.clientSocket writeData:finalData withTimeout:-1 tag:0];
}


- (IBAction)upload:(id)sender {
    //上报电池仓状态心跳
    [self showAertWithTitle:@"选择需要上报的电池仓" preferredStyle:UIAlertControllerStyleActionSheet style:UIAlertActionStyleDefault actionTitle:self.titleArr handler:^(UIAlertAction *action) {
        if ([action.title isEqualToString:@"BOX1"]) {
            [self sendBatteryHeartbeatWithBox:1];
        } else if ([action.title isEqualToString:@"BOX2"]) {
            [self sendBatteryHeartbeatWithBox:2];
        } else if ([action.title isEqualToString:@"BOX3"]) {
            [self sendBatteryHeartbeatWithBox:3];
        } else if ([action.title isEqualToString:@"BOX4"]) {
            [self sendBatteryHeartbeatWithBox:4];
        } else if ([action.title isEqualToString:@"BOX5"]) {
            [self sendBatteryHeartbeatWithBox:5];
        } else if ([action.title isEqualToString:@"BOX6"]) {
            [self sendBatteryHeartbeatWithBox:6];
        } else if ([action.title isEqualToString:@"BOX7"]) {
            [self sendBatteryHeartbeatWithBox:7];
        } else if ([action.title isEqualToString:@"BOX8"]) {
            [self sendBatteryHeartbeatWithBox:8];
        }
    }];
    
}

- (void)sendBatteryHeartbeatWithBox:(NSInteger)box {
    [self.boxArray removeAllObjects];
    [self.boxArray addObjectsFromArray:@[self.box1Model, self.box2Model, self.box3Model, self.box4Model, self.box5Model, self.box6Model, self.box7Model, self.box8Model]];
    
    BatteryModel *model = [self.boxArray objectAtIndex:box - 1];
    
//    int len = 67 + model.batteriesCount.intValue*2;
    int len = 47 + 20*2;
    
    unsigned char send[8] = {0x68, 0x13, 0x00, 0x00, len, 0x00, 0x00};
    NSData *sendData = [NSData dataWithBytes:send length:8];
    
    NSMutableData *bodyData = [NSMutableData new];
    
    unsigned char boxId[1] = {box};
    [bodyData appendData:[NSData dataWithBytes:boxId length:1]];
    
//    [bodyData appendData:[Tools hexToBytes:[Tools hexStringFromString:model.parentNumber] length:20]];
    [bodyData appendData:[Tools convertHexStrToData:model.boxStatus length:1]];

    NSString *batteryNum = [Tools hexStringFromString:model.batteryId];
    [bodyData appendData:[Tools hexToBytes:batteryNum length:26]];
    
    
    [bodyData appendData:[Tools convertHexStrToData:model.batteryStatus length:0]];
    
    [bodyData appendData:[Tools convertHexStrToData:@"00" length:1]];
    
    
    double declareV = model.declareV.doubleValue * 100;
    NSString *declareVStr = [Tools reverseWithString:[Tools getHexByDecimal:(int)declareV]];
    [bodyData appendData:[Tools convertHexStrToData:declareVStr length:2]];
    
    
    [bodyData appendData:[Tools convertHexStrToData:[Tools reverseWithString:[Tools getHexByDecimal:3800]] length:2]];
    
    [bodyData appendData:[Tools convertHexStrToData:[Tools reverseWithString:[Tools getHexByDecimal:4000]] length:2]];
    
    [bodyData appendData:[Tools convertHexStrToData:[Tools reverseWithString:[Tools getHexByDecimal:3900]] length:2]];
    
    [bodyData appendData:[Tools convertHexStrToData:[Tools reverseWithString:[Tools getHexByDecimal:3500]] length:2]];

    double cap = model.totalAh.doubleValue * 100;
    [bodyData appendData:[Tools convertHexStrToData:[Tools reverseWithString:[Tools getHexByDecimal:(int)cap]] length:2]];

    double leftCap = model.leftAh.doubleValue * 100;
    [bodyData appendData:[Tools convertHexStrToData:[Tools reverseWithString:[Tools getHexByDecimal:(int)leftCap]] length:2]];

    unsigned char some[3] = {model.SOC.intValue, 20, model.batteriesCount.intValue};
    [bodyData appendData:[NSData dataWithBytes:some length:3]];

    for (int i = 0; i < 20; i++) {
        unsigned char v[2] = {11};
        [bodyData appendData:[NSData dataWithBytes:v length:2]];
    }
    
    
    NSMutableData *finalData = [NSMutableData dataWithData:sendData];
    [finalData appendData:bodyData];
    [self.clientSocket writeData:finalData withTimeout:-1 tag:0];
}

- (IBAction)closeDoor:(id)sender {
    
    [self showAertWithTitle:@"请选择需要关门的电池仓" preferredStyle:UIAlertControllerStyleActionSheet style:UIAlertActionStyleDefault actionTitle:self.titleArr handler:^(UIAlertAction *action) {
        if ([action.title isEqualToString:@"BOX1"]) {
            [self closeDoorWithDoorNumber:1];
        } else if ([action.title isEqualToString:@"BOX2"]) {
            [self closeDoorWithDoorNumber:2];
        } else if ([action.title isEqualToString:@"BOX3"]) {
            [self closeDoorWithDoorNumber:3];
        } else if ([action.title isEqualToString:@"BOX4"]) {
            [self closeDoorWithDoorNumber:4];
        } else if ([action.title isEqualToString:@"BOX5"]) {
            [self closeDoorWithDoorNumber:5];
        } else if ([action.title isEqualToString:@"BOX6"]) {
            [self closeDoorWithDoorNumber:6];
        } else if ([action.title isEqualToString:@"BOX7"]) {
            [self closeDoorWithDoorNumber:7];
        } else if ([action.title isEqualToString:@"BOX8"]) {
            [self closeDoorWithDoorNumber:8];
        }
    }];
}

- (void)closeDoorWithDoorNumber:(NSInteger)box {
    
    [self.boxArray removeAllObjects];
    [self.boxArray addObjectsFromArray:@[self.box1Model, self.box2Model, self.box3Model, self.box4Model, self.box5Model, self.box6Model, self.box7Model, self.box8Model]];
    BatteryModel *model = [self.boxArray objectAtIndex:box - 1];

    unsigned char send[8] = {0x68, 0x16, 0x00, 0x00, 63, 0x00, 0x00};
    NSData *sendData = [NSData dataWithBytes:send length:8];
    
    NSMutableData *bodyData = [NSMutableData new];
    
    unsigned char boxId[1] = {box};
    [bodyData appendData:[NSData dataWithBytes:boxId length:1]];
//    [bodyData appendData:[Tools hexToBytes:[Tools hexStringFromString:model.parentNumber] length:20]];
    
//    NSInteger online;
//    if (model.haveBattery) {
//        online = 0;
//    } else {
//        online = 2;
//    }
//    unsigned char isOnLine[1] = {online};
//    [bodyData appendData:[NSData dataWithBytes:isOnLine length:1]];
    
    NSString *batteryNum = [Tools hexStringFromString:model.batteryId];
    [bodyData appendData:[Tools hexToBytes:batteryNum length:26]];
    
    if (self.serialNumData) {
        [bodyData appendData:self.serialNumData];
    } else {
        NSString *serialNumStr = [Tools hexStringFromString:@"C129912010010"];
        [bodyData appendData:[Tools hexToBytes:serialNumStr length:36]];
    }
    
    NSMutableData *finalData = [NSMutableData dataWithData:sendData];
    [finalData appendData:bodyData];
    [self.clientSocket writeData:finalData withTimeout:-1 tag:0];
    model.isOpen = false;
}

- (IBAction)updateCharging:(id)sender {
    [self.boxArray removeAllObjects];
    [self.boxArray addObjectsFromArray:@[self.box1Model, self.box2Model, self.box3Model, self.box4Model, self.box5Model, self.box6Model, self.box7Model, self.box8Model]];
    

    for (BatteryModel *model in self.boxArray) {
        if ([model.boxStatus isEqualToString:@"0x03"] || [model.boxStatus isEqualToString:@"03"]) {
            unsigned char send[8] = {0x68, 0x17, 0x00, 0x00, 78, 0x00, 0x00};
            NSData *sendData = [NSData dataWithBytes:send length:8];
            
            NSMutableData *bodyData = [NSMutableData new];
            unsigned char boxID[1] = {model.boxId.intValue};
            [bodyData appendData:[NSData dataWithBytes:boxID length:1]];
            
            if (self.serialNumData) {
                [bodyData appendData:self.serialNumData];
            } else {
                NSString *serialNumStr = [Tools hexStringFromString:@"C129912010010"];
                [bodyData appendData:[Tools hexToBytes:serialNumStr length:36]];
            }
            
            NSString *batteryNum = [Tools hexStringFromString:model.batteryId];
            [bodyData appendData:[Tools hexToBytes:batteryNum length:26]];
            
//            NSString *timeStr = [Tools currentdateInterval];
//            NSString *time = [Tools reverseWithString:[Tools getHexByDecimal:timeStr.intValue]];
//            [bodyData appendData:[Tools convertHexStrToData:time length:4]];
            
            //充电电量
            [bodyData appendData:[Tools convertHexStrToData:[Tools reverseWithString:[Tools getHexByDecimal:4000]] length:2]];
            //当前充电电压
            [bodyData appendData:[Tools convertHexStrToData:[Tools reverseWithString:[Tools getHexByDecimal:6000]] length:2]];
            //当前充电电流
            [bodyData appendData:[Tools convertHexStrToData:[Tools reverseWithString:[Tools getHexByDecimal:2000]] length:2]];

            NSString *beginTime = [Tools reverseWithString:[Tools getHexByDecimal:[Tools currentdateInterval].intValue]];
            [bodyData appendData:[Tools convertHexStrToData:beginTime length:4]];
            
            NSString *duration = [Tools reverseWithString:[Tools getHexByDecimal:900]];
            [bodyData appendData:[Tools convertHexStrToData:duration length:4]];
            
            unsigned char soc[1] = {model.SOC.intValue};
            [bodyData appendData:[NSData dataWithBytes:soc length:1]];
            
            NSMutableData *finalData = [NSMutableData dataWithData:sendData];
            [finalData appendData:bodyData];
            [self.clientSocket writeData:finalData withTimeout:-1 tag:0];
        }
    }
    
}

/// 上报充电订单数据
- (void)uploadChargeOrderWithOrderModel:(OrderModel *)model {
    unsigned char send[8] = {0x68, 0x18, 0x00, 0x00, 80, 0x00, 0x00};
    NSData *sendData = [NSData dataWithBytes:send length:8];
    
    NSMutableData *bodyData = [NSMutableData new];
    
    unsigned char boxID[1] = {1};
    [bodyData appendData:[NSData dataWithBytes:boxID length:1]];
    
    if (self.serialNumData) {
        [bodyData appendData:self.serialNumData];
    } else {
        NSString *serialNumStr = [Tools hexStringFromString:@"C129912010010"];
        [bodyData appendData:[Tools hexToBytes:serialNumStr length:36]];
    }
    
    NSString *batteryNum = [Tools hexStringFromString:model.batteryId];
    [bodyData appendData:[Tools hexToBytes:batteryNum length:26]];
    
    
    double kwhD = model.chargeKwh.doubleValue * 100;
    [bodyData appendData:[Tools convertHexStrToData:[Tools reverseWithString:[Tools getHexByDecimal:(int)kwhD]] length:2]];

    NSString *beginTimeStr = [Tools reverseWithString:[Tools getHexByDecimal:model.beginTime.intValue]];
    [bodyData appendData:[Tools convertHexStrToData:beginTimeStr length:4]];
    
    NSString *endTimeStr = [Tools reverseWithString:[Tools getHexByDecimal:model.endTime.intValue]];
    [bodyData appendData:[Tools convertHexStrToData:endTimeStr length:4]];
    
    NSInteger duration = model.endTime.intValue - model.beginTime.intValue;
    NSString *durationStr = [Tools reverseWithString:[Tools getHexByDecimal:duration]];
    [bodyData appendData:[Tools convertHexStrToData:durationStr length:4]];
    
    
    unsigned char endReason[1] = {[Tools remove0xStringWithString:model.endReason].intValue};
    [bodyData appendData:[NSData dataWithBytes:endReason length:1]];
    
    unsigned char soc[1] = {10};
    [bodyData appendData:[NSData dataWithBytes:soc length:1]];
    
    unsigned char leftCapcity[1] = {model.leftCapcity.intValue};
    [bodyData appendData:[NSData dataWithBytes:leftCapcity length:1]];
    
    NSMutableData *finalData = [NSMutableData dataWithData:sendData];
    [finalData appendData:bodyData];
    [self.clientSocket writeData:finalData withTimeout:-1 tag:0];
}

- (IBAction)swipeCardButtonClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Title" message:nil preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
            UITextField *cardNumTf = alert.textFields.lastObject;

            [self swipeCardWithCardNum:cardNumTf.text];
            NSLog(@"OK pushed");
        }]];

        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"请输入卡号";
        }];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];

        [self presentViewController:alert animated:YES completion:nil];
}

- (void)swipeCardWithCardNum:(NSString *)cardNum {
    unsigned char send[8] = {0x68, 0x19, 0x00, 0x00, 21, 0x00, 0x00};
    NSData *sendData = [NSData dataWithBytes:send length:8];
    
    NSMutableData *bodyData = [NSMutableData new];
    
    unsigned char numLength[1] = {cardNum.length};
    [bodyData appendData:[NSData dataWithBytes:numLength length:1]];
    
    NSString *cardNumStr16 = [Tools hexStringFromString:cardNum];
    NSData *cardNumData = [Tools hexToBytes:cardNumStr16 length:20];
    [bodyData appendData:cardNumData];
    
    NSMutableData *finalData = [NSMutableData dataWithData:sendData];
    [finalData appendData:bodyData];
    [self.clientSocket writeData:finalData withTimeout:-1 tag:0];
}

- (IBAction)batteryLoginButtonClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Title" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
        UITextField *batteryNumTf = alert.textFields.firstObject;
        UITextField *batteryVersionTf = [alert.textFields objectAtIndex:1];
        UITextField *batteryTypeTf = alert.textFields.lastObject;
        [self batteryLoginWithBatteryNum:batteryNumTf.text batteryV:batteryVersionTf.text batteryType:batteryTypeTf.text];
        NSLog(@"OK pushed");
    }]];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入电池编号";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入电池型号";
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入电池类型";
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)batteryLoginWithBatteryNum:(NSString *)batteryNum batteryV:(NSString *)batteryV batteryType:(NSString *)batteryType {
    
    unsigned char send[8] = {0x68, 0x30, 0x00, 0x00, 46, 0x00, 0x00};
    NSData *sendData = [NSData dataWithBytes:send length:8];
    
    NSMutableData *bodyData = [NSMutableData new];
    
    NSString *batteryNumStr = [Tools hexStringFromString:batteryNum];
    [bodyData appendData:[Tools hexToBytes:batteryNumStr length:26]];
    
    NSString *batteryVStr16 = [Tools hexStringFromString:batteryV];
    [bodyData appendData:[Tools hexToBytes:batteryVStr16 length:10]];
    
    unsigned char type[1] = {[Tools remove0xStringWithString:batteryType].intValue};
    [bodyData appendData:[NSData dataWithBytes:type length:1]];
    
    unsigned char body[4] = {0x01,0x02,0x03,8};
    NSData *data = [NSData dataWithBytes:body length:4];
    [bodyData appendData:data];
    
    NSString *magicByteStr = [Tools reverseWithString:[Tools getHexByDecimal:10086]];
    NSData *magicData = [Tools convertHexStrToData:magicByteStr length:4];
    [bodyData appendData:[NSData dataWithBytes:[magicData bytes] length:4]];
    
    unsigned char sign[1] = {3};
    [bodyData appendData:[NSData dataWithBytes:sign length:1]];
    
    NSMutableData *finalData = [NSMutableData dataWithData:sendData];
    [finalData appendData:bodyData];
    [self.clientSocket writeData:finalData withTimeout:-1 tag:0];
}

- (void)batteryHeartbeatWithBatteryModel:(BatteryModel *)model {
    unsigned char send[8] = {0x68, 0x31, 0x00, 0x00, 67, 0x00, 0x00};
    NSData *sendData = [NSData dataWithBytes:send length:8];
    
    NSMutableData *bodyData = [NSMutableData new];
    
    unsigned locationType[1] = {0x00};
    [bodyData appendData:[NSData dataWithBytes:locationType length:1]];
    
    NSString *lonStr = @"116.397128";
    double lonD = lonStr.doubleValue * 100000;
    NSString *lonByteStr = [Tools reverseWithString:[Tools getHexByDecimal:(int)lonD]];
    NSData *lonData = [Tools convertHexStrToData:lonByteStr length:4];
    [bodyData appendData:[NSData dataWithBytes:[lonData bytes] length:4]];

    NSString *latStr = @"39.916527";
    double latD = latStr.doubleValue * 100000;
    NSString *str = [Tools getHexByDecimal:(int)latD];
    NSString *latByteStr = [Tools reverseWithString:str];
    NSData *latData =[Tools convertHexStrToData:latByteStr length:4];
    [bodyData appendData:[NSData dataWithBytes:[latData bytes] length:4]];
    
    unsigned batteryStaus[1] = {0x00};
    [bodyData appendData:[NSData dataWithBytes:batteryStaus length:1]];
    
    double declareV = model.declareV.doubleValue * 100;
    NSString *declareVStr = [Tools reverseWithString:[Tools getHexByDecimal:(int)declareV]];
    [bodyData appendData:[Tools convertHexStrToData:declareVStr length:2]];
    
    double temp = self.boxModel.boxTemperature.doubleValue * 100;
    NSString *tempStr = [Tools reverseWithString:[Tools getHexByDecimal:(int)temp]];
    [bodyData appendData:[Tools convertHexStrToData:tempStr length:2]];
    
    NSString *cellTemp1 = [Tools reverseWithString:[Tools getHexByDecimal:40]];
    [bodyData appendData:[Tools convertHexStrToData:cellTemp1 length:2]];
    
    NSString *cellTemp2 = [Tools reverseWithString:[Tools getHexByDecimal:42]];
    [bodyData appendData:[Tools convertHexStrToData:cellTemp2 length:2]];
    
    NSString *cardTemp = [Tools reverseWithString:[Tools getHexByDecimal:28]];
    [bodyData appendData:[Tools convertHexStrToData:cardTemp length:2]];
    
    double cap = model.totalAh.doubleValue * 100;
    [bodyData appendData:[Tools convertHexStrToData:[Tools reverseWithString:[Tools getHexByDecimal:(int)cap]] length:2]];

    double leftCap = model.leftAh.doubleValue * 100;
    [bodyData appendData:[Tools convertHexStrToData:[Tools reverseWithString:[Tools getHexByDecimal:(int)leftCap]] length:2]];
    
    unsigned left[2] = {model.SOC.intValue, 8};
    [bodyData appendData:[NSData dataWithBytes:left length:2]];
    
    for (int i = 0; i < 20; i++) {
        unsigned char v[2] = {11};
        [bodyData appendData:[NSData dataWithBytes:v length:2]];
    }
    
    NSMutableData *finalData = [NSMutableData dataWithData:sendData];
    [finalData appendData:bodyData];
    [self.clientSocket writeData:finalData withTimeout:-1 tag:0];
}

- (void)showLogWithStr:(NSString *)str {
    NSLog(@"%@", str);
    [self.logStr appendString:[NSString stringWithFormat:@"%@\n", str]];
    self.logLabel.text = self.logStr;
}

- (void)initStatus {
    self.logLabel.text = @"...";
    self.logStr = [[NSMutableString alloc] initWithString:@""];
    
    [self.boxArray removeAllObjects];
    
    self.box1Model = [Tools creatBatteryModelWithBoxNumber:@"box1"];
    self.box2Model = [Tools creatBatteryModelWithBoxNumber:@"box2"];
    self.box3Model = [Tools creatBatteryModelWithBoxNumber:@"box3"];
    self.box4Model = [Tools creatBatteryModelWithBoxNumber:@"box4"];
    self.box5Model = [Tools creatBatteryModelWithBoxNumber:@"box5"];
    self.box6Model = [Tools creatBatteryModelWithBoxNumber:@"box6"];
    self.box7Model = [Tools creatBatteryModelWithBoxNumber:@"box7"];
    self.box8Model = [Tools creatBatteryModelWithBoxNumber:@"box8"];
    self.boxModel = [[BoxModel alloc] init];
    self.orderModel = [OrderModel new];
    
    [self.boxArray addObjectsFromArray:@[self.box1Model, self.box2Model, self.box3Model, self.box4Model, self.box5Model, self.box6Model, self.box7Model, self.box8Model]];
}

- (void)showAertWithTitle:(NSString *)title preferredStyle:(UIAlertControllerStyle *)preferredStyle style:(UIAlertActionStyle *)style actionTitle:(NSArray *)actionTitleArr handler:(void(^)(UIAlertAction *action))block {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString *actionTitle in actionTitleArr) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            block(action);
        }];
        [alert addAction:action];
    }
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSArray *)titleArr {
    if (_titleArr == nil) {
        _titleArr = @[@"BOX1",@"BOX2",@"BOX3",@"BOX4",@"BOX5",@"BOX6",@"BOX7",@"BOX8",];
    }
    return _titleArr;
}

- (IBAction)exitToHere:(UIStoryboardSegue *)sender {
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    __weak typeof (self) weakSelf = self;
    if ([segue.identifier isEqualToString:@"setting"]) {
        SettingViewController *set = (SettingViewController *)segue.destinationViewController;
        set.currentModel = self.boxModel;
        set.saveBlock = ^(BoxModel * _Nonnull newModel) {
            weakSelf.boxModel = newModel;
        };
    } else if ([segue.identifier isEqualToString:@"order"]) {
        OrderSettingViewController *order = (OrderSettingViewController *)segue.destinationViewController;
        order.currentModel = self.orderModel;
        order.saveBlock = ^(OrderModel * _Nonnull model) {
            weakSelf.orderModel = model;
            [weakSelf uploadChargeOrderWithOrderModel:model];
        };
    } else {
        BoxDetailViewController *detail = (BoxDetailViewController *)segue.destinationViewController;
        if ([segue.identifier isEqualToString:@"box1"]) {
            
            detail.currentModel = self.box1Model;
            detail.saveBlock = ^(BatteryModel * _Nonnull newModel) {
                weakSelf.box1Model = newModel;
            };
            detail.heartbeatBlock = ^(BatteryModel * _Nonnull model) {
                [weakSelf batteryHeartbeatWithBatteryModel:model];
            };
        } else if ([segue.identifier isEqualToString:@"box2"]) {
            
            detail.currentModel = self.box2Model;
            detail.saveBlock = ^(BatteryModel * _Nonnull newModel) {
                weakSelf.box2Model = newModel;
            };
        } else if ([segue.identifier isEqualToString:@"box3"]) {
            
            detail.currentModel = self.box3Model;
            detail.saveBlock = ^(BatteryModel * _Nonnull newModel) {
                weakSelf.box3Model = newModel;
            };
        } else if ([segue.identifier isEqualToString:@"box4"]) {
            
            detail.currentModel = self.box4Model;
            detail.saveBlock = ^(BatteryModel * _Nonnull newModel) {
                weakSelf.box4Model = newModel;
            };
        } else if ([segue.identifier isEqualToString:@"box5"]) {
           detail.currentModel = self.box5Model;
            detail.saveBlock = ^(BatteryModel * _Nonnull newModel) {
                weakSelf.box5Model = newModel;
            };
        } else if ([segue.identifier isEqualToString:@"box6"]) {
            
            detail.currentModel = self.box6Model;
            detail.saveBlock = ^(BatteryModel * _Nonnull newModel) {
                weakSelf.box6Model = newModel;
            };
        } else if ([segue.identifier isEqualToString:@"box7"]) {
            
            detail.currentModel = self.box7Model;
            detail.saveBlock = ^(BatteryModel * _Nonnull newModel) {
                weakSelf.box7Model = newModel;
            };
        } else if ([segue.identifier isEqualToString:@"box8"]) {
            
            detail.currentModel = self.box8Model;
            detail.saveBlock = ^(BatteryModel * _Nonnull newModel) {
                weakSelf.box8Model = newModel;
            };
        }
    }
    
}
- (IBAction)clearLogButttonClick:(id)sender {
    self.logStr = [[NSMutableString alloc] initWithString:@""];
    self.logLabel.text = self.logStr;
}

- (NSMutableArray *)boxArray {
    if (_boxArray == nil) {
        _boxArray = [NSMutableArray new];
    }
    return _boxArray;
}
@end
