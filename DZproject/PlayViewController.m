//
//  PlayViewController.m
//  DZproject
//
//  Created by lianggq on 13-11-12.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import "PlayViewController.h"
#import "LGQAppDelegate.h"
#import "MerchantsViewController.h"
#import "CustomeCell.h"
#import "NotifitionNames.h"
#import "MyComboxHead.h"
#import "MyDPAPIData.h"

#define DPQYSHAPIURL          @"v1/business/find_businesses"
#define DPQYSHPARAMS          @"limit=20&format=json&platform=2"



#define FONTSIZE              10.0

@interface PlayViewController ()<DPRequestDelegate>

@end

@implementation PlayViewController{
    NSMutableArray *_categoryList;//选中类别
    NSString * _category ;//选中的分类值
    MyComboxHead *categoryHead;//分类下拉框头
    
    NSMutableArray *_regionList;
    NSString * _region;//选中所属区值
    MyComboxHead *regionHead;
    
    NSArray *sortArr;//排序方式
    NSInteger _sort ;//选中排序索引
    MyComboxHead *sortHead;
    
    CategoryTable *cateTable;//选者的数据
    
}
@synthesize dataArr,categoryArr,regionArr;
@synthesize myTable,toobar;
@synthesize params,city,catagoryType;

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
    self.navigationItem.title =catagoryType;
    self.myTable.dataSource =self;
    self.myTable.delegate =self;
    sortArr=[NSArray arrayWithObjects:@"默认排序",@"星级高优先",@"评价高优先",@"环境高优先",@"服务高优先",@"点评多优先",@"距离近优先",@"价格低优先",@"价格高优先", nil];
    _sort =0; //默认;
    
    [self loadDatas];
    [self addCombos];
    //组合参数
    _category =categoryHead.selectData; //默认选择第一个
    city =[LGQAppDelegate instance].currtCity;
    self.params =[NSString stringWithFormat:@"%@&city=%@&category=%@",DPQYSHPARAMS,city,_category];
    

    [self getDPData];
    [self loadCataTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadDatas
{
    _categoryList =[[NSMutableArray alloc] init];
    _regionList =[[NSMutableArray alloc] init];
    //加载分类数据
    for(NSDictionary *dicRegion in categoryArr){
        [_categoryList addObject:(NSString *)[dicRegion objectForKey:@"category_name"]];
    }
    
    //加载商区数据
    [_regionList addObject:@"全部商区"];    
    for(NSDictionary *dicRegion in regionArr){
        [_regionList addObject:(NSString *)[dicRegion objectForKey:@"district_name"]];
    }
    
}

-(void)loadCataTable
{
    CGRect rect =self.view.frame;
    CGFloat subY  =0.0f; //显示坐标
    if (self.navigationController) {
        CGRect navi =self.navigationController.navigationBar.frame;
        
        subY = navi.origin.y;
    }
    CGFloat step =12.0f;
    subY +=step; //为避免被遮住
    //subY = self.toobar.frame.origin.y;
    CGFloat offsetX =0.0f; //相对偏移量X
    cateTable =[[CategoryTable alloc] initWithFrame:CGRectMake(offsetX, subY, rect.size.width-offsetX, rect.size.height-subY)];
    cateTable.delegate =self;
}

-(void)addCombos
{
    
    regionHead =[[MyComboxHead alloc] initWithFrame:CGRectMake(0.0f,0.0f, 100.0f, 30.0f)];
    [regionHead setButtonTitle:[_regionList objectAtIndex:0]];
    regionHead.respondSEL=self;
    regionHead.myAction =@selector(regionData:);
    
    categoryHead =[[MyComboxHead alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 30.0f)];
    [categoryHead setButtonTitle:[_categoryList objectAtIndex:0]];
    categoryHead.respondSEL=self;
    categoryHead.myAction =@selector(categoryData:);
    
    sortHead =[[MyComboxHead alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 30.0f)];
    [sortHead setButtonTitle:[sortArr objectAtIndex:0]];
    sortHead.respondSEL=self;
    sortHead.myAction =@selector(sortData:);
    
    
        //[self.view bringSubviewToFront:self.toobar];
        
    UIBarButtonItem *regionItem =[[UIBarButtonItem alloc] initWithCustomView:regionHead];
        
    UIBarButtonItem *categoryItem =[[UIBarButtonItem alloc] initWithCustomView:categoryHead];
        
    UIBarButtonItem *sortItem =[[UIBarButtonItem alloc] initWithCustomView:sortHead];
        //创建barbuttonitem,样式是flexible,这个种barbuttonitem用于两个barbuttonitem之间
        //调整两个item之间的距离.flexible表示距离是动态的,fixed表示是固定的
    UIBarButtonItem *flexible =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        
    NSMutableArray *toobarItems =[NSMutableArray arrayWithObjects:regionItem,flexible,categoryItem,flexible,sortItem, nil];
    [self.toobar setItems:toobarItems];
    self.toobar.autoresizesSubviews =YES; //自动调整子视图
        //[self.toobar autoresizingMask]; //布局设置
        //[self.toobar sizeToFit];

    
}

-(void)categoryData:(MyComboxHead *)send
{
    cateTable.head=send;
    
    cateTable.arr =_categoryList;
    [cateTable.table reloadData];
    NSUInteger row =0;
    if (send.selectData) {
         row =[cateTable.arr indexOfObject:send.selectData];
    }
    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:row inSection:0];
    [cateTable.table selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
    [UIView beginAnimations:@"viewAppearFromRight" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    
    [self.view addSubview:cateTable];
    [cateTable becomeFirstResponder];
    [UIView commitAnimations];
    [self.view bringSubviewToFront:cateTable];
    
}

-(void)regionData:(MyComboxHead *)send
{
    
    cateTable.head=send;
    cateTable.arr =_regionList;
    [cateTable.table reloadData];

    NSUInteger row =0;
    if (send.selectData) {
        row =[cateTable.arr indexOfObject:send.selectData];
    }
    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:row inSection:0];
    [cateTable.table selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
    [UIView beginAnimations:@"viewAppearFromRight" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    
    [self.view addSubview:cateTable];
    [cateTable becomeFirstResponder];
    [UIView commitAnimations];
    [self.view bringSubviewToFront:cateTable];
}

-(void)sortData:(MyComboxHead *)send
{
    cateTable.head=send;

    cateTable.arr =sortArr;
    [cateTable.table reloadData];
    NSUInteger row =0;
    if (send.selectData) {
        row =[cateTable.arr indexOfObject:send.selectData];
    }
    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:row inSection:0];
    [cateTable.table selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
    [UIView beginAnimations:@"viewAppearFromRight" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    
    [self.view addSubview:cateTable];
    [cateTable becomeFirstResponder];
    [UIView commitAnimations];
    [self.view bringSubviewToFront:cateTable];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    //return cell.frame.size.height;
    
    return  ((CustomeCell *)[[[NSBundle mainBundle] loadNibNamed:@"CustomeCell" owner:self options:nil] lastObject]).frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if(cell ==nil){
        cell = (UITableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"CustomeCell" owner:self options:nil] lastObject];
    }
    NSInteger row = indexPath.row;
    //取出信息
    NSDictionary * dataDic =(NSDictionary *)[self.dataArr objectAtIndex:row];
    
    //从 xib 文件中取出 组件
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:1000];
    NSString *imgUrl = (NSString *)[dataDic objectForKey:@"s_photo_url"];
    UIImage *img =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
    
    [imgView setImage:img];
    //店名+地址
    UILabel *name_addres =(UILabel *)[cell.contentView viewWithTag:1001];
    NSString *name =(NSString *)[dataDic objectForKey:@"name"];
    NSArray *regions =(NSArray *)[dataDic objectForKey:@"regions"];
    NSMutableString *regionStr =[[NSMutableString alloc] init]  ;
    for (NSString *regionSub in regions) {
        [regionStr appendFormat:@"%@ ",regionSub];
    }
    name_addres.text =[NSString stringWithFormat:@"%@(%@)",name,regionStr];
    name_addres.font =[UIFont boldSystemFontOfSize:FONTSIZE];
    name_addres.numberOfLines =0; //设置换行
    name_addres.textAlignment =NSTextAlignmentLeft ;
    
    //店食品分类
    UILabel *categories =(UILabel *)[cell.contentView viewWithTag:1002];
    NSArray *categoty =(NSArray *)[dataDic objectForKey:@"categories"];
    NSMutableString *categotyStr =[[NSMutableString alloc] init]   ;
    for (NSString *cName in categoty) {
        [categotyStr appendFormat:@"%@ ",cName];
    }
    categories.text =[NSString stringWithFormat:@"%@",categotyStr];
    categories.font =[UIFont boldSystemFontOfSize:FONTSIZE];
    categories.numberOfLines =0; //设置换行
    categories.textAlignment =NSTextAlignmentLeft ;
    
    //人均价格
    UILabel *avgPrice =(UILabel *)[cell.contentView viewWithTag:1003];
    long price =[(NSNumber *)[dataDic objectForKey:@"avg_price"] longValue]; //封装后才能正确解析
    if(price<0l){
        avgPrice.text=[NSString stringWithFormat:@"人均价:未知 " ];
    }else{
        avgPrice.text=[NSString stringWithFormat:@"人均价:%ld元 ",price ];
    }
    avgPrice.font =[UIFont boldSystemFontOfSize:FONTSIZE];
    avgPrice.numberOfLines =0; //设置换行
    avgPrice.textAlignment =NSTextAlignmentRight ;
    return cell;
}

#pragma mark - 实现表格的操作事件代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Contrller 对Controller的跳转
    //[self presentModalViewController:merchant animated:YES];
    [self performSegueWithIdentifier:@"playToBusess" sender:self];
    //之后才能跳转prepareForSegue: sender: 方法
}


#pragma mark UIStoryboardSegue跳转
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"playToBusess"])
    {
        MerchantsViewController *merchant =(MerchantsViewController *)[segue destinationViewController];
        NSIndexPath *index =[self.myTable indexPathForSelectedRow];
        NSInteger row =[index row];
        NSDictionary *tempDic =[[self dataArr] objectAtIndex:row];
        [merchant setBuesData:tempDic ];
    }
}



#pragma -mark 获取点评网数据
-(void)getDPData
{
    NSString *url = DPQYSHAPIURL;
	//NSString *_params = self.params;
	[[[LGQAppDelegate instance] dpapi] requestWithURL:url paramsString:self.params delegate:self];
}

#pragma -mark DPRequestDelegate协议方法
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
	NSLog(@"error = %@",[error description]);
}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    //NSDictionary *d =(NSDictionary *)result;
    
    NSDictionary *_result =(NSDictionary *)result ;
    
    self.dataArr = (NSArray *)[_result objectForKey:@"businesses"];
    
    if(self.dataArr){
        [self.myTable reloadData];
    }
    else{
        
    }
    
}

#pragma -mark 下拉框回调

-(void)didSelectCategoryData
{
    NSMutableString *temp =[[NSMutableString alloc]init];
    if(regionHead.selectData){
        _region =regionHead.selectData;
        if(![_region isEqualToString:[_regionList objectAtIndex:0]])
            [temp appendFormat:@"&region=%@",_region];
    }
    if(categoryHead.selectData){
        _category =categoryHead.selectData;
        [temp appendFormat:@"&category=%@",_category];
        
    }
    if(sortHead.selectData){
        _sort =[sortArr indexOfObject:sortHead.selectData];
        if(_sort>9||_sort<0) _sort=0; //出现未知错误 视为默认
    }
    [temp appendFormat:@"&sort=%d",_sort+1];
    self.params =[NSString stringWithFormat:@"%@&city=%@%@",DPQYSHPARAMS,city,temp];
    //NSLog(@"parma =%@",params);
    [self getDPData];
}

@end
