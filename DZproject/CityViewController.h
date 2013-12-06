//
//  CityViewController.h
//  DZproject
//
//  Created by lianggq on 13-11-21.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NAMenuView.h"

@protocol  CityDelegate;



@interface CityViewController : UIViewController<NAMenuViewDelegate>

@property (retain,nonatomic) NSArray *menuItems;

@property (strong, nonatomic) IBOutlet UISearchBar *citySearch;

@property (strong, nonatomic) IBOutlet UILabel *resultLab;

@property (nonatomic,assign) id<CityDelegate> delegate;

@end

@protocol CityDelegate <NSObject>

-(void)cityChanged;

@end
