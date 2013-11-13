//
//  BuessViewController.m
//  DZproject
//
//  Created by lianggq on 13-11-11.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import "BuessViewController.h"
#import "LGQAppDelegate.h"
#import "SBJsonParser.h"
#import "CustomeCell.h"

#define DPSSSHAPIURL      @"v1/business/find_businesses"  //搜索商户API
#define DPSSSHPARAMS   @"city=北京&region=海淀区&category=美食&has_coupon=1&sort=2&limit=20"   //相关参数

#define FONTSIZE   10.0

@interface BuessViewController ()<DPRequestDelegate>
@end

@implementation BuessViewController
@synthesize dataArr,myTable;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title =@"品食";
    self.tableView.dataSource =self;
    self.tableView.delegate =self;
    [self getDPData];
    
}

-(void)loadTableData
{
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier  ];
    //CustomeCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier  ];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"CustomeCell" owner:self options:nil] lastObject];
       // cell =[[CustomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
       
    }
    // Configure the cell...
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

#pragma -mark 获取点评网数据
-(void)getDPData
{
    NSString *url = DPSSSHAPIURL;
	NSString *params = DPSSSHPARAMS;
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
        [self loadTableData];
    }
    else{
        
    }
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
