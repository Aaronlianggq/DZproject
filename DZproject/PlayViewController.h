//
//  PlayViewController.h
//  DZproject
//
//  Created by lianggq on 13-11-12.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CategoryTable.h"

@interface PlayViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CategoryTableDelegate>

@property (retain,nonatomic) NSArray * dataArr;//table数据

@property (retain,nonatomic) NSString *params;//访问大众点评网参数

@property (retain,nonatomic) NSString *city ;//定位的城市

@property (retain,nonatomic) NSArray *categoryArr; //全部小类
@property (retain,nonatomic) NSString *catagoryType;//选中大类

@property (retain,nonatomic) NSArray *regionArr; //市区

@property (strong, nonatomic) IBOutlet UITableView *myTable;

@property (strong, nonatomic) IBOutlet UIToolbar *toobar;
@end
