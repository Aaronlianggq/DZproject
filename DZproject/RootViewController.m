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
#import "CategoryTable.h"
#import "MyComboxHead.h"
#import "LGQAppDelegate.h"
#import "MyDPAPIData.h"
#import "PlayViewController.h"

#define DPCITIES    @"v1/metadata/get_cities_with_businesses" //城市API
#define DPSUBCITIES  @"v1/metadata/get_regions_with_businesses" //城区API
#define DPCATEGORIES          @"v1/metadata/get_categories_with_businesses" //分类



@interface RootViewController ()<DPRequestDelegate>

@end

@implementation RootViewController{
    //城市数据是否加载 //默认加载城市
    BOOL isCities; //是否加载了城市数据
    
    BOOL isSubCities;//城市分区
    BOOL isCategories;//商户分类
    
    GetApiType apiType; //访问API类型
    NSString *url; //
    
    MyComboxHead *rightHead ; //右边按钮
}
@synthesize eatGuest,eatImg;


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
    self.navigationItem.title = @"吃-玩-购";
    
    //设置图片可触摸
    eatImg.userInteractionEnabled =YES;
    [eatGuest setNumberOfTapsRequired:1];
    [eatGuest setNumberOfTouchesRequired:1];
    [self setButtons];
    [LGQAppDelegate instance].currtCity =DEFAULTCITY; //先设定默认城市
    [self getCityAndSubAreaAndCategory];
    
}

-(void)getCityAndSubAreaAndCategory
{
    [self getDPDataCities];
    
}

#pragma -mark 导航按钮定义
-(void)setButtons
{
    
    //导航栏左侧侧，Flat框架按钮
    [self.navigationItem setLeftBarButtonItem:[PBFlatBarButtonItems moreBarButtonItemWithTarget:self selector:@selector(showMenu:)]];
    //右边导航自定义
    
    
    UIBarButtonItem *rightBar =[[UIBarButtonItem alloc] initWithTitle:@"城市1" style:UIBarButtonItemStyleBordered target:self action:nil];
    
    rightHead =[[MyComboxHead alloc] initWithFrame:CGRectMake(0.0f,0.0f, 100.0f, 30.0f)];
    rightHead.isAutoSize =YES;
    rightHead.myAction =@selector(showCities);
    [rightHead setButtonTitle:DEFAULTCITY];
    [rightHead.but setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    //[regionHead.but setBackgroundColor:[UIColor brownColor]];
    //[regionHead.but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBar setCustomView:rightHead];
    
    
    
    [self.navigationItem setRightBarButtonItem:rightBar];
}

-(void)showCities
{
    NSLog(@"113");
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

- (IBAction)shoppingPress:(id)sender {
    

    
}

#pragma -mark segue跳转
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSArray *temparr =[MyDPAPIData instanceDPData].categories;
    NSString *str;
    NSMutableArray *categoryArr;
    NSMutableArray *regionArr;
    PlayViewController *next =(PlayViewController *)[segue destinationViewController];
    
    if([[segue identifier] isEqualToString:@"playToData"]){
        //休闲
        for(NSDictionary *dic in temparr){
            str =(NSString *)[dic objectForKey:@"category_name"];
            if([str isEqualToString:@"休闲娱乐"]){
                categoryArr =(NSMutableArray *)[dic objectForKey:@"subcategories"];
                next.catagoryType =@"休闲娱乐";
                break;
            }
        }
        
        
    }else if([[segue identifier] isEqualToString:@"shoppingToData"]){
        //商场
        for(NSDictionary *dic in temparr){
            str =(NSString *)[dic objectForKey:@"category_name"];
            if([str isEqualToString:@"购物"]){
                categoryArr =(NSMutableArray *)[dic objectForKey:@"subcategories"];
                next.catagoryType =@"美食";
                break;
            }
        }
    }else if ([[segue identifier] isEqualToString:@"eatToData"]){
        //美食
        for(NSDictionary *dic in temparr){
            str =(NSString *)[dic objectForKey:@"category_name"];
            if([str isEqualToString:@"美食"]){
                categoryArr =(NSMutableArray *)[dic objectForKey:@"subcategories"];
                next.catagoryType =@"美食";
                break;
            }
        }
    }
    next.categoryArr =categoryArr;
    //取得城市
    
    for(NSDictionary *dic in [MyDPAPIData instanceDPData].subCities){
        NSString * city =(NSString *)[dic objectForKey:@"city_name"];
        if([[LGQAppDelegate instance].currtCity hasPrefix:city]){
            regionArr =(NSMutableArray *)[dic objectForKey:@"districts"];
            break;
        }
    }

    next.regionArr =regionArr;
    
}

#pragma -mark 获取点评网数据
-(void)getDPDataCities
{
    apiType =GETCITIES;
    //isCities =YES;
    url =DPCITIES;
    [[[LGQAppDelegate instance] dpapi] requestWithURL:url params:nil delegate:self];
}

-(void)getDPDataSubCites
{
    apiType =GETSUBCITIES;
    //isSubCities=YES;
    url =DPSUBCITIES;
    [[[LGQAppDelegate instance] dpapi] requestWithURL:url params:nil delegate:self];
    
}

-(void)getDPDataCategoties
{
    apiType=GETCATEGORY;
    //isCategories =YES;
    url =DPCATEGORIES;
    [[[LGQAppDelegate instance] dpapi] requestWithURL:url params:nil delegate:self];
}

#pragma -mark DPRequestDelegate协议方法
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
	NSLog(@"error = %@",[error description]);
}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    //NSDictionary *d =(NSDictionary *)result;
    
    if(result){
        if(apiType ==GETCITIES){
            [MyDPAPIData instanceDPData].cities =[(NSDictionary *)result objectForKey:@"cities"];
            isCities =YES;
            NSLog(@"city complete");
        }else if(apiType ==GETSUBCITIES){
            [MyDPAPIData instanceDPData].subCities =[(NSDictionary *)result objectForKey:@"cities"];
            isSubCities=YES;
            NSLog(@"subcity complete");
        }else if(apiType ==GETCATEGORY){
            [MyDPAPIData instanceDPData].categories =[(NSDictionary *)result objectForKey:@"categories"];
            isCategories=YES;
            NSLog(@"categories complete");
        }
    }
    
    if(!isSubCities){
        [self getDPDataSubCites];
    }else if(!isCategories){
        [self getDPDataCategoties];
    }
    if(isSubCities && isCategories && isCities){ //全部加载完成
        for(NSString *city in [MyDPAPIData instanceDPData].cities)
        {
            if([[LGQAppDelegate instance].currtCity hasPrefix:city])
            {
                [LGQAppDelegate instance].currtCity =city;
            }
            
        }
        [rightHead setButtonTitle:[LGQAppDelegate instance].currtCity];
    }
    

}


@end
