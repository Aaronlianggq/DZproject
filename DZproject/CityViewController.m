//
//  CityViewController.m
//  DZproject
//
//  Created by lianggq on 13-11-21.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import "CityViewController.h"
#import "MyDPAPIData.h"


@interface CityViewController ()

-(NSArray *)createCities;

@end

@implementation CityViewController
@synthesize menuItems;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init {
	self = [super init];
	
	if (self) {
		self.menuItems =[self createCities];
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if(!self.menuItems){
        self.menuItems =[self createCities];
    }
    
    self.navigationItem.title =@"城市更换";
   
    [self setButtons];
    //NSLog(@"left =%@",self.navigationItem.leftBarButtonItem);
    NAMenuView *menuView = [[NAMenuView alloc] init];
	menuView.menuDelegate = self;
    CGRect selFrame =self.view.frame;
    CGFloat orY =100.0f;
    CGRect menuFrame =CGRectMake(0.0, orY, 320.0,selFrame.size.height-orY);
    menuView.frame =menuFrame;
    [self.view addSubview:menuView];
}


-(void)setButtons
{
    //导航返回
    UIImage *img =[UIImage imageNamed:@"back.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame: CGRectMake(0, 0,55, 44)];
    [backButton setImage:img forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    //[backButton setTitle:@"返回" forState:UIControlStateNormal];
    //UIBarButtonItem *backBar =[[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
    UIBarButtonItem *backBar =[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem =backBar;
}

-(void)goBack:(id)send
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)createCities
{
    NSMutableArray *items =[[NSMutableArray alloc] init];
    for(NSString *city in [MyDPAPIData instanceDPData].cities){
        NAMenuItem *item =[[NAMenuItem alloc] initWithTitle:city];
        [items addObject:item];
    }
    return items;
}

#pragma view life circle
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - NAMenuViewDelegate Methods

- (NSUInteger)menuViewNumberOfItems:(id)menuView {
	NSAssert([self menuItems], @"menuItems无数据");
	return [menuItems count];
}

- (NAMenuItem *)menuView:(NAMenuView *)menuView itemForIndex:(NSUInteger)index {
	NSAssert([self menuItems], @"menuItems无数据");
	return [menuItems objectAtIndex:index];
}

- (void)menuView:(NAMenuView *)menuView didSelectItemAtIndex:(NSUInteger)index {
	NSAssert([self menuItems], @"menuItems无数据");
	NSLog(@"index=%d",index);
    NSString * city =((NAMenuItem *)[self.menuItems objectAtIndex:index]).title;
    
    if(![[MyDPAPIData instanceDPData].selectedCity isEqualToString:city]){
        [MyDPAPIData instanceDPData].selectedCity =city;
        NSNotification *note =[NSNotification notificationWithName:@"cityHasChanged" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:note];
        
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
