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

#define DPQYSHAPIURL          @"v1/business/find_businesses"
#define DPQYSHPARAMS          @"category=休闲娱乐&city=上海&region=长宁区&limit=20&format=json&platform=2"
#define FONTSIZE              10.0

@interface PlayViewController ()<DPRequestDelegate>

@end

@implementation PlayViewController
@synthesize dataArr;
@synthesize myTable;

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
    self.navigationItem.title =@"休闲娱乐";
    self.myTable.dataSource =self;
    self.myTable.delegate =self;
    
    [self getDPData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    for (NSString *region in regions) {
        [regionStr appendFormat:@"%@ ",region];
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
    avgPrice.text=[NSString stringWithFormat:@"人均价%ld元 ",price ];
    avgPrice.font =[UIFont boldSystemFontOfSize:FONTSIZE];
    avgPrice.numberOfLines =0; //设置换行
    avgPrice.textAlignment =NSTextAlignmentRight ;
    return cell;
}

#pragma mark - 实现表格的操作事件代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //消息发送传递 ios7貌似有问题
    //[[NSNotificationCenter defaultCenter ] postNotificationName:NOTIFICONTROLSTOMERCHANS object:tempDic];
    
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
	NSString *params = DPQYSHPARAMS;
	[[[LGQAppDelegate instance] dpapi] requestWithURL:url paramsString:params delegate:self];
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

@end
