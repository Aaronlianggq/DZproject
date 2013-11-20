//
//  MyComboxHead.h
//  DZproject
//
//  Created by lianggq on 13-11-18.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyComboxHead : UIView

@property (retain,nonatomic) UIButton *but; //按钮

@property (retain,nonatomic) UIImageView *imgView;//下拉图片

@property (assign,nonatomic) SEL myAction; //回调函数
@property (assign,nonatomic) id respondSEL;//回调函数拥有者
@property (readonly,nonatomic) NSString *selectData;// 选中数据

@property (assign,nonatomic) BOOL isAutoSize ; //but是否自适应长度

-(void)setButtonTitle:(NSString *)buttonTitle;

@end
