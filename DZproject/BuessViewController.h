//
//  BuessViewController.h
//  DZproject
//
//  Created by lianggq on 13-11-11.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuessViewController : UITableViewController

@property (retain,nonatomic) NSArray * dataArr;

@property (strong, nonatomic) IBOutlet UITableView *myTable;
@end
