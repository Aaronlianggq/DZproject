//
//  MapLocation.h
//  MapDemo
//
//  Created by lianggq on 13-11-14.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapLocation : NSObject<MKAnnotation,NSCoding> //MKAnnotation 地图标注协议


@property (nonatomic, copy) NSString *streetAddress; //街道地址
@property (nonatomic, copy) NSString *city; // 城市
@property (nonatomic, copy) NSString *subLocality; // 区域
@property (nonatomic, copy) NSString *mapTitle; //

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate; // 经纬度

-(id)initCustomeAnnotation:(CLLocationCoordinate2D)coords;

@end
