//
//  LGQAppDelegate.h
//  DZproject
//
//  Created by lianggq on 13-11-11.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPAPI.h"
#import <MapKit/MapKit.h>




@class Reachability;
@interface LGQAppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) Reachability *hostReach;

@property (readonly, nonatomic) DPAPI *dpapi;
@property (strong, nonatomic) NSString *appKey;
@property (strong, nonatomic) NSString *appSecret;

@property (assign, nonatomic) double latitude; //当前维度
@property (assign, nonatomic) double longitude; //当前经度
@property (retain, nonatomic) NSString *currtCity;//当前城市;


+ (LGQAppDelegate *)instance;
@end
