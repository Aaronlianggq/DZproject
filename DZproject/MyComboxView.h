//
//  MyComboxView.h
//  ComBoxTest
//
//  Created by lianggq on 13-11-16.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MyComboDelegate.h"

@protocol MyComboDelegate;


@interface MyComboxView : UIView<UITableViewDataSource,UITableViewDelegate> //父视图高度大于200有效 m文件设置固定高度200

@property (retain,nonatomic) UIButton *but; //按钮

@property (retain,nonatomic) UIImageView *imgView;//下拉图片

@property (retain,nonatomic) UITableView *table;//下拉框表格

@property (retain,nonatomic) NSArray *arr;// table数据

@property (assign,nonatomic) id<MyComboDelegate> delegate; //传值代理

@property (retain,nonatomic) NSString *selectData; //默认选中的数据



@end





@protocol MyComboDelegate <NSObject>

@required

-(void)didSelectData;

@optional
-(void)transData:(id)data;

@end


