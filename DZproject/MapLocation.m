//
//  MapLocation.m
//  MapDemo
//
//  Created by lianggq on 13-11-14.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import "MapLocation.h"


@implementation MapLocation
@synthesize subLocality,streetAddress,mapTitle,city,subName;
@synthesize coordinate;


-(id)initCustomeAnnotation:(CLLocationCoordinate2D)coords{
    if (self = [super init]){
        coordinate = coords;
    }
    return self;
}

- (NSString *)title {
    if(mapTitle ==nil){
        mapTitle =@"所在位置";
    }
    return mapTitle;
}
- (NSString *)subtitle {
    
    
    return self.subName;
}

#pragma mark NSCoding Methods
- (void) encodeWithCoder: (NSCoder *)encoder {
    [encoder encodeObject: [self streetAddress] forKey: @"streetAddress"];
    [encoder encodeObject: [self city] forKey: @"city"];
    [encoder encodeObject: [self subLocality] forKey: @"subLocality"];
    }
- (id) initWithCoder: (NSCoder *)decoder  {
    if (self = [super init]) {
        [self setStreetAddress: [decoder decodeObjectForKey: @"streetAddress"]];
        [self setCity: [decoder decodeObjectForKey: @"city"]];
        [self setSubLocality: [decoder decodeObjectForKey: @"subLocality"]];
        
    }
    return self;
}

@end
