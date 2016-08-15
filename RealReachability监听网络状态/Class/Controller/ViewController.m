//
//  ViewController.m
//  RealReachability监听网络状态
//
//  Created by 朱占龙 on 16/8/15.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "ViewController.h"
#import "RealReachability.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //提示信息
    self.view.backgroundColor = [UIColor purpleColor];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
    label.text = @"请切换网络状态，以查看RealReachability对网络状态的实时监控";
    label.font = [UIFont boldSystemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [label sizeToFit];
    label.center = self.view.center;
    [self.view addSubview:label];
    
    //添加一个通知监听网络状态切换
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:kRealReachabilityChangedNotification
                                               object:nil];
    [GLobalRealReachability startNotifier];
}

//网络改变通知

- (void)networkChanged:(NSNotification *)notification{
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    if (status == RealStatusNotReachable)
    {
        [self showNotificationMessageWithStatus:@"当前无联网连接"];
    }
    if (status == RealStatusViaWiFi)
    {
        [self showNotificationMessageWithStatus:@"已连接至WiFi"];
    }
    WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
    if (status == RealStatusViaWWAN)
    {
        if (accessType == WWANType2G)
        {
            [self showNotificationMessageWithStatus:@"已连接2G"];
        }
        else if (accessType == WWANType3G)
        {
            [self showNotificationMessageWithStatus:@"已连接3G"];
        }
        else if (accessType == WWANType4G)
        {
            [self showNotificationMessageWithStatus:@"已连接4G"];
        }
        else
        {
            [self showNotificationMessageWithStatus:@"未知网络"];
        }
    }
}

//状态切换后提示信息
- (void)showNotificationMessageWithStatus: (NSString *)status{
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"网络状态改变" message:status delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    // 显示 UIAlertView
    [alert show];
    // 添加延迟时间为 2 秒 然后执行 dismiss: 方法
    [self performSelector:@selector(dismiss:) withObject:alert afterDelay:2];
}

//实现dismiss方法

- (void)dismiss:( UIAlertView *)alert{
    // 此处即相当于点击了 cancel 按钮
    [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];}

//视图销毁的时候停止监听，移除通知
- (void)dealloc{
    [GLobalRealReachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
