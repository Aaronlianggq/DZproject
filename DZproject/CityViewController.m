//
//  CityViewController.m
//  DZproject
//
//  Created by lianggq on 13-11-21.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import "CityViewController.h"
#import "MyDPAPIData.h"

#define RESULTTABLEHEITH  100.0

@interface CityViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

-(NSArray *)createCities;


@end

@implementation CityViewController{
    NAMenuView *menuView;
    
    UITableView *resultTable; //显示结果
    NSMutableArray *resultData;
    
    NAMenuItemView *tempItem; //临时标记
    UIColor *color ;//NAMenuItemView 背景颜色
}
@synthesize menuItems;
@synthesize citySearch,resultLab;
@synthesize delegate;

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
    //NSLog(@"left =%@",self.navigationItem.leftBarButtonItem);
    
    //self.resultLab.lineBreakMode = UILineBreakModeWordWrap;
    self.resultLab.numberOfLines=0; //多行
    [self.resultLab setFont:[UIFont systemFontOfSize:12.0]];
    self.navigationItem.title =@"城市更换";
    
    [self setButtons]; //返回按钮
    [self searchHander];  //处理搜索框
    [self resultTableHander]; //显示集合
    menuView = [[NAMenuView alloc] init];
	menuView.menuDelegate = self;
    CGRect selFrame =self.view.frame;
    CGFloat orY =self.citySearch.frame.origin.y +self.citySearch.frame.size.height+5.0; //留5空隙
    CGRect menuFrame =CGRectMake(0.0, orY, 320.0,selFrame.size.height-orY);
    menuView.frame =menuFrame;
    [self.view addSubview:menuView];
    color =[menuView viewWithTag:0].backgroundColor;
    
}


-(void)searchHander
{
    self.citySearch.placeholder =@"城市关键字查找 ";
//    CGRect searchRect =self.citySearch.frame;
//    searchRect.size.height =35.0;
//    self.citySearch.frame =searchRect;
//    CGRect searchRect2 =self.citySearch.frame;
//     NSLog(@"mx=%f,my=%f,mw=%f,mh=%f",searchRect2.origin.x,searchRect2.origin.y,searchRect2.size.width,searchRect2.size.height);
    self.citySearch.delegate =self;
    //ios7 只有一个子视图 获取子视图
    UIView *topView = self.citySearch.subviews[0];
    topView.layer.cornerRadius=2;
    [self.citySearch setBarTintColor:[UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0]];
    
}

-(void)resultTableHander
{
    resultData =[[NSMutableArray alloc] init];
    CGRect searchRect =self.citySearch.frame;
    
    CGRect tableRect =CGRectMake(searchRect.origin.x, searchRect.origin.y+searchRect.size.height,searchRect.size.width , RESULTTABLEHEITH);
    
    resultTable =[[UITableView alloc] initWithFrame:tableRect];
    //隐藏分割线
    [resultTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    resultTable.delegate =self;
    resultTable.dataSource=self;
    resultTable.layer.borderColor =[[UIColor grayColor] CGColor];
    resultTable.layer.borderWidth=1.0;
    [self.view addSubview:resultTable];
    
    [self hideTable];
}

#pragma mark 隐藏列表
-(void)hideTable
{
    [resultTable setHidden:YES];
    CGRect tf =resultTable.frame;
    tf.size.height = 0;
    resultTable.frame = tf;
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

#pragma mark 显示匹配的城市
-(void)resultData:(NSString *)cityName
{
    //NSLog(@"cityName=%@",cityName);
    
    if([resultData count]>0) {[resultData removeAllObjects]; }

    for (NAMenuItem *item in menuItems){
        NSString *cName =item.title;
        NSRange range  =[cName rangeOfString:cityName];
        if(range.length>0){
            [resultData addObject:cName];
        }
    }
    NSString *result =[NSString stringWithFormat:@"有%i个城市匹配",[resultData count]];
    self.resultLab.text =result;
    if([resultData count]>0){
        [resultTable becomeFirstResponder];
        [resultTable reloadData];
        CGRect tf =resultTable.frame;
        tf.size.height =RESULTTABLEHEITH;
        
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];//选择类型
        
        [resultTable setHidden:NO];
        resultTable.frame =tf;
    
        [UIView commitAnimations];
        [self.view bringSubviewToFront:resultTable];
    }
    
}

-(void)findCity:(NSString *)cityName
{
    for (int i=0;i<[self.menuItems count];i++){
        NAMenuItem *item =[self.menuItems objectAtIndex:i];
        NSString *cName =item.title;
        if([cName isEqualToString:cityName]){
            //找到目标view
            if(tempItem){
                [tempItem setBackgroundColor:color];
            }
            NAMenuItemView *viewItem =(NAMenuItemView *)[menuView viewWithTag:i];
            tempItem =viewItem;
            //设置颜色区别
            UIColor *itemColor =[UIColor colorWithRed:111/255 green:111/255 blue:111/255 alpha:0.5];
            [viewItem setBackgroundColor:itemColor];
            //显示居中
            CGRect select =viewItem.frame;
            CGRect menuFrame =menuView.frame;
            CGFloat pY =select.origin.y -(menuFrame.size.height)/2;
            if(pY<0){
                pY =0.0;
            }
            
            CGPoint offset =CGPointMake(0,pY );
            [menuView setContentOffset:offset animated:YES];
            break;
        }
    }
}

#pragma mark 城市数据
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
    NSString * city =((NAMenuItem *)[self.menuItems objectAtIndex:index]).title;
    
    if(![[MyDPAPIData instanceDPData].selectedCity isEqualToString:city]){
        [MyDPAPIData instanceDPData].selectedCity =city;
//        NSNotification *note =[NSNotification notificationWithName:@"cityHasChanged" object:nil];
//        [[NSNotificationCenter defaultCenter] postNotification:note];
        if(self.delegate){
            [delegate cityChanged];
        }
        
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark searchBarDelegate
-(void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text =@"";
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    //去掉前后空格
    NSString *text =[searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self resultData:text];
}

-(void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar
{
    
}

//showsScopeBar显示 才能调用
-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    
    NSLog(@"selectedScope=%d",selectedScope);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [resultData count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if(cell ==nil){
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSInteger row = indexPath.row;
    cell.textLabel.text =[resultData objectAtIndex:row];
    return  cell;
   
}

#pragma mark - 实现表格的操作事件代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row =[indexPath row];
    NSString *select =[resultData objectAtIndex:row];
    self.citySearch.text =select;
    if(!resultTable.hidden){
        [self hideTable];
    }
    
    [self findCity:select];
}


@end
