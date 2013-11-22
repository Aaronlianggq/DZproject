//
//  CityViewController.h
//  DZproject
//
//  Created by lianggq on 13-11-21.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NAMenuView.h"


@interface CityViewController : UIViewController<NAMenuViewDelegate>

@property (retain,nonatomic) NSArray *menuItems;

@end
