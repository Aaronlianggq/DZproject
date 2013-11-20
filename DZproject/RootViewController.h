//
//  RootViewController.h
//  DZproject
//
//  Created by lianggq on 13-11-11.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//



#import <UIKit/UIKit.h>


typedef enum{
    GETCITIES=0,
    GETSUBCITIES,
    GETCATEGORY
} GetApiType;

@interface RootViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *eatImg;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *eatGuest;


- (IBAction)shoppingPress:(id)sender;
@end
