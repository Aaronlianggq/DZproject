//
//  RootViewController.m
//  DZproject
//
//  Created by lianggq on 13-11-11.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import "RootViewController.h"
#import "PBFlatBarButtonItems.h"
#import "KxMenu.h"

@interface RootViewController ()

@end

@implementation RootViewController
@synthesize eatGuest,eatImg;
@synthesize urlImg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"大众品食";
    //导航栏右侧，Flat框架按钮
    [self.navigationItem setRightBarButtonItem:[PBFlatBarButtonItems moreBarButtonItemWithTarget:self selector:@selector(showMenu:)]];
    //设置图片可触摸
    eatImg.userInteractionEnabled =YES;
    [eatGuest setNumberOfTapsRequired:1];
    [eatGuest setNumberOfTouchesRequired:1];
    
    UIImage *img =[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://i1.dpfile.com/pc/d85d4f65e6b9b1a7075f6f2b4827f794%28278x200%29/thumb.jpg"]]];
    
    [self.urlImg setImage:img];
    
    
}

#pragma -mark 导航右边按钮定义
-(void)setButtons
{
    //右边导航自定义
    UIButton *rightbar =[[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
    [rightbar setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
    [rightbar addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbarItem = [[UIBarButtonItem alloc]initWithCustomView:rightbar];
    [self.navigationItem setRightBarButtonItem:rightbarItem];
}

#pragma -mark 菜单定义
-(void)showMenu:(UIButton *)sender
{
    
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"进入..."
                     image:nil
                    target:nil
                    action:NULL],
      
      [KxMenuItem menuItem:@"大众首页"
                     image:[UIImage imageNamed:@"love.png"]
                    target:self
                    action:@selector(gotoDaZhongFirstPage:)],
      
      
      [KxMenuItem menuItem:@"商品搜索"
                     image:[UIImage imageNamed:@"love.png"]
                    target:self
                    action:@selector(gotoSearchPage:)],
      
      ];
    
    KxMenuItem *first = menuItems[0];
    
    first.foreColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
    
    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuItems];
}

-(void)gotoDaZhongFirstPage:(UIButton *)button
{
    //    DZViewController *view =[[DZViewController alloc]init];
    //    [self.navigationController pushViewController:view animated:YES];
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    // 获取故事板中某个View
    UIViewController *next = [board instantiateViewControllerWithIdentifier:@"dazhong"];
    
    [self.navigationController pushViewController:next animated:YES];

}

-(void)gotoSearchPage:(UIButton *)button
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
