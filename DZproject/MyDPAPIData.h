//
//  MyDPAPIData.h
//  DZproject
//
//  Created by lianggq on 13-11-19.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DEFAULTCITY           @"上海"  //默认城市


@interface MyDPAPIData : NSObject


@property (retain,nonatomic) NSArray *cities; //城市

@property (retain,nonatomic) NSArray *subCities; //大区

@property (retain,nonatomic) NSArray *categories;//分类


+(MyDPAPIData *)instanceDPData;

@end
