//
//  PlayViewController.h
//  DZproject
//
//  Created by lianggq on 13-11-12.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain,nonatomic) NSArray * dataArr;


@property (strong, nonatomic) IBOutlet UITableView *myTable;

@end
