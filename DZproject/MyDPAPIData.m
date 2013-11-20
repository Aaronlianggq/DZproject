//
//  MyDPAPIData.m
//  DZproject
//
//  Created by lianggq on 13-11-19.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import "MyDPAPIData.h"

@implementation MyDPAPIData
@synthesize categories,cities,subCities;


static MyDPAPIData *sharedData = nil;
+(MyDPAPIData *)instanceDPData
{
    @synchronized (self){ //关键字@synchronized是为了保证我们的单例的线程级别的安全，可以适用于多线程模式下
        
        if(sharedData ==nil){
            sharedData= [[[self class] alloc] init]; //[不是MyDPAPIData alloc],一般效果一样 ，[self class]可以动态查找并确定类的类型从而便于实现对该类的子类化。
        }
    }
    return  sharedData;
}

+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (sharedData == nil) {
            sharedData = [super allocWithZone:zone];
            return  sharedData;
        }
    }
    return nil;
}

@end
