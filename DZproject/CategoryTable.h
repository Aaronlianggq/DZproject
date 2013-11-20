//
//  CategoryTable.h
//  DZproject
//
//  Created by lianggq on 13-11-18.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyComboxHead.h"

@protocol  CategoryTableDelegate;

@interface CategoryTable : UIView<UITableViewDataSource,UITableViewDelegate>

@property (retain,nonatomic) UIImageView *imgView;//撤销图片

@property (retain,nonatomic) UITableView *table;// 选项表格

@property (retain,nonatomic) NSArray *arr;// table数据

@property (assign,nonatomic) id<CategoryTableDelegate> delegate; //传值代理
@property (retain,nonatomic) NSString *selectData; //选中数据
@property (retain,nonatomic) MyComboxHead * head; //当前按钮

@end


@protocol CategoryTableDelegate <NSObject>

@required

-(void)didSelectCategoryData;

@optional
-(void)transCategoryData:(id)data;

@end