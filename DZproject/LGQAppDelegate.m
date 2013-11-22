//
//  LGQAppDelegate.m
//  DZproject
//
//  Created by lianggq on 13-11-11.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//



#import "LGQAppDelegate.h"
#import "Reachability.h"
#import "MyDPAPIData.h"

//static NSArray *cityAdministrativeArea = nil; //直辖市

@implementation LGQAppDelegate{
    CLLocationManager *locationManager; //定位器
    CLGeocoder *geocoder ;// 经纬度编码器
    NSUInteger reachCount ;//检测网络断网次数
}
@synthesize hostReach;
@synthesize latitude,longitude,currtCity;
//@synthesize appKey,appSecret,dpapi; 自定义set方法 不用同步

+ (LGQAppDelegate *)instance {
	return (LGQAppDelegate *)[[UIApplication sharedApplication] delegate];
    
}

- (id)init {
	self = [super init];
    if (self) {
        reachCount=0;
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
    //cityAdministrativeArea =[NSArray arrayWithObjects:@"上海",@"北京",@"天津",@"重庆", nil]; //直辖市单独拿出来
    [MyDPAPIData instanceDPData].selectedCity =DEFAULTCITY;
    [self loadMyLocation];  //定位;
    
    return YES;
}

-(void)loadMyLocation
{
    if([CLLocationManager locationServicesEnabled])
    {
        locationManager =[[CLLocationManager alloc] init];
        locationManager.delegate =self;
        locationManager.desiredAccuracy =kCLLocationAccuracyBest;//定位最好
        //locationManager.distanceFilter =1000.0f;//过滤一千米 再通知代理
        [locationManager startUpdatingLocation]; //定位开始
    }else{
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"定位提示" message:@"当前未开启城市定位,为方便商户距离检测,推荐开启定位后重新进入" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
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

#pragma  -mark locationDelegate Methods
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [locationManager stopUpdatingLocation];
//    UIAlertView *alert = [[UIAlertView alloc]
//                          initWithTitle:@"地理解码错误息"
//                          message:@"信号不足"
//                          delegate:nil
//                          cancelButtonTitle:@"Ok"
//                          otherButtonTitles:nil];
//    [alert show];
    NSLog(@"error=%@",[error localizedDescription]);
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [locationManager stopUpdatingLocation]; //停止更新 省电;
    if([locations count]>0){
        CLLocation *currtLocation = (CLLocation *)[locations objectAtIndex:0]; //得到当前位置
        self.latitude  =currtLocation.coordinate.latitude;
        self.longitude =currtLocation.coordinate.longitude;
        
        geocoder =[[CLGeocoder alloc ] init];
        
        [geocoder reverseGeocodeLocation:currtLocation completionHandler:^(NSArray *placeMarks,NSError *err){
            if(err==nil && [placeMarks count]>0)
            {
                CLPlacemark *mark =[placeMarks objectAtIndex:0];
                self.currtCity =mark.administrativeArea; //城市
                if(self.currtCity==nil){
                    self.currtCity =mark.locality ;//取直辖市 或省份
                }
                //[MyDPAPIData instanceDPData].selectedCity =self.currtCity;
                //NSDictionary *addre =mark.addressDictionary;
                NSLog(@"name:%@\n country:%@\n postalCode:%@\n ISOcountryCode:%@\n ocean:%@\n inlandWater:%@\n locality:%@\n subLocality:%@\n administrativeArea:%@\n subAdministrativeArea:%@\n thoroughfare:%@\n subThoroughfare:%@\n",
                                                    mark.name,
                                                    mark.country,
                                                    mark.postalCode,
                                                    mark.ISOcountryCode,
                                                    mark.ocean,
                                                    mark.inlandWater,
                                                    mark.administrativeArea,
                                                    mark.subAdministrativeArea,
                                                    mark.locality,
                                                    mark.subLocality,
                                                    mark.thoroughfare,
                                mark.subThoroughfare);
            }
            
            
        }];
        
    }
    
    
}

//ios7以下使用方法
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
}



#pragma -mark 检测网络
-(void)reachabilityChanged:(NSNotification *)note
{
    Reachability * reach = [note object];
    UIAlertView * alert ;
    if([reach isReachable])
    {
        if(reachCount>0){
            alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接通畅" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
            [alert show];
        }
    }else{
        alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alert show];
    }
    reachCount ++;
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
