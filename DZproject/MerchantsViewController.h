//
//  MerchantsViewController.h
//  DZproject
//
//  Created by lianggq on 13-11-13.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchantsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic ) NSDictionary *buesData ; //商户数据

@property (retain, nonatomic) NSArray *reviewArr; //最新点评数据

@property (strong, nonatomic) IBOutlet UIImageView *merchImg;    //商户图片

@property (strong, nonatomic) IBOutlet UIImageView *ratingImg;   //评分图片

@property (strong, nonatomic) IBOutlet UILabel *coupon; //优惠信息

@property (strong, nonatomic) IBOutlet UILabel *deals; //团购信息

@property (strong, nonatomic) IBOutlet UILabel *address;// 地址
@property (strong, nonatomic) IBOutlet UILabel *review_count; //点评数信息

@property (strong, nonatomic) IBOutlet UITableView *reViewTable; //点评数据

@property (strong, nonatomic) IBOutlet UILabel *merchanName;



@end
