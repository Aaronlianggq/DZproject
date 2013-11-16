//
//  MerchantsViewController.m
//  DZproject
//
//  Created by lianggq on 13-11-13.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import "MerchantsViewController.h"
#import "NotifitionNames.h"
#import "LGQAppDelegate.h"
#import "MapViewController.h"

#define DPMERCHANRUL       @"v1/review/get_recent_reviews" //点评api
#define DPMERCHPARAMS      @"&platform=2&format=json"

@interface MerchantsViewController ()<DPRequestDelegate>

@end

@implementation MerchantsViewController{
    double latitude;  //维度坐标
    double longitude; //经度坐标
    long   merchantID; //商户ID
}
@synthesize buesData,reviewArr;
@synthesize review_count,address,coupon,deals,merchanName;
@synthesize merchImg,ratingImg;
@synthesize reViewTable;

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
    self.navigationItem.title =@"商户详情";
    //消息机制 ios7貌似有问题
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData:) name:NOTIFICONTROLSTOMERCHANS object:nil];
    
    [self loadData];
    reViewTable.dataSource =self;
    reViewTable.delegate =self;
    if(merchantID){[self getDPData];};
}

#pragma -mark 加载数据
-(void)loadData
{
    if(buesData){
        //商户图
        NSString *merUrl =[ buesData objectForKey:@"s_photo_url"];
        UIImage *merTempImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:merUrl]]];
        [merchImg setImage:merTempImg];
    
        NSString *merName =(NSString *)[buesData objectForKey:@"name"];
        NSString *branch_name =(NSString *)[buesData objectForKey:@"branch_name"];
        merchanName.text =[NSString stringWithFormat:@"%@(%@)",merName,branch_name];
        
        //星级图片
        NSString *ratingUrl =(NSString *)[buesData objectForKey:@"rating_s_img_url" ];
        UIImage *ratTempImg=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ratingUrl]]];
        [ratingImg setImage:ratTempImg];
        
        //平均星级评分
        //float avg_rating =[(NSNumber *) [buesData objectForKey:@"avg_rating"] floatValue];
        
        //优惠券
        NSInteger has_coupon =[(NSNumber *)[buesData objectForKey:@"has_coupon" ] intValue]  ;
        coupon.text =(has_coupon==1?@"有":@"无");
        
        //团购
        NSInteger has_deal =[(NSNumber *)[buesData objectForKey:@"has_deal" ] intValue]  ;
        deals.text =(has_deal==1?@"有":@"无");
        
        //地址
        address.text =(NSString *)[buesData objectForKey:@"address" ];
        [address setFont:[UIFont systemFontOfSize:12.0]];
        address.numberOfLines =0;
        //点评数量
        //NSUInteger reviews =[(NSNumber *)[buesData objectForKey:@"review_count" ] unsignedIntegerValue]  ;
    
        //定位坐标
        latitude =[(NSNumber *)[buesData objectForKey:@"latitude"] doubleValue];
        longitude =[(NSNumber *)[buesData objectForKey:@"longitude"] floatValue];
        //商户ID
        merchantID =[(NSNumber *)[buesData objectForKey:@"business_id"] doubleValue];
        

     }
 
    
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
    return [self.reviewArr count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Review";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath ];
    
    if(cell ==nil){
        cell = [[UITableViewCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSInteger row = [indexPath row];
    NSDictionary *rowDic =(NSDictionary *)[self.reviewArr objectAtIndex:row];
    //评论者
    UILabel *auther =(UILabel *)[cell.contentView viewWithTag:1001];
    [auther setFont:[UIFont systemFontOfSize:12.0]];
    auther.text =[rowDic objectForKey:@"user_nickname"];
    
    //时间
    UILabel *time =(UILabel *)[cell.contentView viewWithTag:1002 ];
    time.text =[rowDic objectForKey:@"created_time"];
    [time setTextAlignment:NSTextAlignmentRight];
    
    //评论星级
    UIImageView *ratImgView =(UIImageView *)[cell.contentView viewWithTag:1003];
    NSString *ratImgUrl =[rowDic objectForKey:@"rating_s_img_url"];
    UIImage *ratImg =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ratImgUrl]]];
    [ratImgView setImage:ratImg];
    
    //评论信息
    UITextView *textView =(UITextView *)[cell.contentView viewWithTag:1004];
    [textView resignFirstResponder];
    [textView.layer setCornerRadius:10.0];//圆角
    [textView setFont:[UIFont systemFontOfSize:12.0]];
    [textView.layer setBorderWidth:1.0];//边框大小颜色
    [textView.layer setBorderColor:[[UIColor grayColor]CGColor]];
    textView.text =[rowDic objectForKey:@"text_excerpt"];
    return cell;
}


#pragma mark 获取点评数据
-(void)getDPData
{
    NSString *url = DPMERCHANRUL;
	NSString *params =[NSString stringWithFormat:@"business_id=%ld%@",merchantID,DPMERCHPARAMS];
	[[[LGQAppDelegate instance] dpapi] requestWithURL:url paramsString:params delegate:self];
}

#pragma -mark DPRequestDelegate协议方法
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
	NSLog(@"error = %@",[error description]);
}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    //NSDictionary *d =(NSDictionary *)result;
    
     self.reviewArr= (NSArray *)[result objectForKey:@"reviews"];
    if(self.reviewArr){
        [self.reViewTable reloadData];
    }else{
        
    }
        
}

- (IBAction)merchantDetail:(id)sender {
    
   //使用modal跳转关闭当前界面 目的返回之前界面
   // [self dismissViewControllerAnimated:YES completion:^{}];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"toMerchanMap"]){
        //跳转地图
        MapViewController *selfMap =(MapViewController *) [segue destinationViewController];
        
        [selfMap setDataDic:[self buesData] ];
        
    }
}


@end
