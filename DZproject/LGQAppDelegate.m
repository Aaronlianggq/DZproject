//
//  LGQAppDelegate.m
//  DZproject
//
//  Created by lianggq on 13-11-11.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import "LGQAppDelegate.h"
#import "Reachability.h"

@implementation LGQAppDelegate
@synthesize hostReach;
//@synthesize appKey,appSecret,dpapi; 自定义set方法 不用同步

+ (LGQAppDelegate *)instance {
	return (LGQAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (id)init {
	self = [super init];
    if (self) {
        _dpapi = [[DPAPI alloc] init];
		_appKey = [[NSUserDefaults standardUserDefaults] valueForKey:@"appkey"];
		if (_appKey.length<1) {
			_appKey = kDPAppKey;
		}
		_appSecret = [[NSUserDefaults standardUserDefaults] valueForKey:@"appsecret"];
		if (_appSecret.length<1) {
			_appSecret = kDPAppSecret;
		}
    }
    return self;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
    
    //检测网络状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:Nil];
    hostReach =[Reachability reachabilityWithHostname:@"http://www.dianping.com"];
    [hostReach startNotifier];
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)reachabilityChanged:(NSNotification *)note
{
    Reachability * reach = [note object];
    UIAlertView * alert ;
    if([reach isReachable])
    {
//        alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接通畅" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
//        [alert show];
    }else{
        alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alert show];
    }

}

//没同步 用set方法
- (void)setAppKey:(NSString *)appKey {
	_appKey = appKey;
	[[NSUserDefaults standardUserDefaults] setValue:appKey forKey:@"appkey"];
}

- (void)setAppSecret:(NSString *)appSecret {
	_appSecret = appSecret;
	[[NSUserDefaults standardUserDefaults] setValue:appSecret forKey:@"appsecret"];
}

@end
