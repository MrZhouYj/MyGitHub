//
//  ViewController.m
//  shunluQQ
//
//  Created by 周永建 on 16/7/13.
//  Copyright © 2016年 xinde. All rights reserved.
//

#import "ViewController.h"
#import "JPUSHService.h"
@interface ViewController ()

@property (nonatomic, strong)UILabel *netWorkStateLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor whiteColor];

    _netWorkStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    _netWorkStateLabel.textColor = [UIColor redColor];
    [self.view addSubview:_netWorkStateLabel];
    
    
    
    _netWorkStateLabel.center = self.view.center;
    
    
    
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];

    
}

- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
    NSLog(@"%@", error);
}

- (void)networkDidSetup:(NSNotification *)notification {
    self.title = @"已连接";
    NSLog(@"已连接");
    _netWorkStateLabel.textColor = [UIColor colorWithRed:0.0 / 255
                                                   green:122.0 / 255
                                                    blue:255.0 / 255
                                                   alpha:1];
}

- (void)networkDidClose:(NSNotification *)notification {
    self.title = @"未连接。。。";
    NSLog(@"未连接");
    _netWorkStateLabel.textColor = [UIColor redColor];
}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"%@", [notification userInfo]);
   self.title = @"已注册";
    _netWorkStateLabel.textColor = [UIColor colorWithRed:0.0 / 255
                                                   green:122.0 / 255
                                                    blue:255.0 / 255
                                                   alpha:1];
      NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    self.title = @"已登录";
    _netWorkStateLabel.textColor = [UIColor colorWithRed:0.0 / 255
                                                   green:122.0 / 255
                                                    blue:255.0 / 255
                                                   alpha:1];
    NSLog(@"已登录");
    
    NSMutableSet * set = [NSMutableSet set];
    
    [set addObject:@"快递员"];
    [set addObject:@"司机"];
    
    [JPUSHService setTags:set alias:@"18233209882" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"iResCodeiResCode==%d",iResCode);
    }];
   
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    NSLog(@"自定义消息%@",notification);
    
    NSDictionary * dic = notification.userInfo;
    
    UILocalNotification * local = [[UILocalNotification alloc] init];
    
    local.alertBody=dic[@"content"];
    
    
    [JPUSHService showLocalNotificationAtFront:local identifierKey:@"4b3eba3a9b409323818137ef"];
    
}

@end
