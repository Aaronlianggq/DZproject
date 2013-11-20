//
//  MyComboxView.m
//  ComBoxTest
//
//  Created by lianggq on 13-11-16.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import "MyComboxView.h"

#define COMBOXBUTHIGHT  30.0f  //一个下拉框按钮一般只要30的高度

@implementation MyComboxView{
    BOOL showList;//是否弹出下拉列表
    
    CGFloat tabheight;//table下拉列表的高度
    
    CGFloat frameHeight;//frame的高度

}
@synthesize table,but,imgView,arr;
@synthesize delegate;

//-(id)init{
//    if(self =[super init]){
//        
//    }
//     return self;
//}

- (id)initWithFrame:(CGRect)frame
{
    
    if(frame.size.height<200){
        frameHeight =200;
    }else{
        frameHeight = frame.size.height;
    }
    
    tabheight = frameHeight -COMBOXBUTHIGHT;
    
    frame.size.height =COMBOXBUTHIGHT;
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        showList =NO;
        
        table =[[UITableView alloc]initWithFrame:CGRectMake(0, COMBOXBUTHIGHT, frame.size.width, 30)];
        table.delegate =self;
        table.dataSource =self;
        table.layer.cornerRadius =10;
        //table.separatorColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0];
        table.alpha =0.8;
        table.backgroundColor =[UIColor grayColor];
        [table setHidden:YES];
        [self addSubview:table];
        
        UIImage *img =[UIImage imageNamed:@"comSamlldown.png"];
        CGFloat imgWidth =img.size.width;
        CGFloat imgHeith =img.size.height;
        but =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        //[but setTitle:@"测试" forState:UIControlStateNormal];
        [but setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
       
        but.frame =CGRectMake(0, 0, frame.size.width-imgWidth, COMBOXBUTHIGHT);
        [but addTarget:self action:@selector(pressDown:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:but];
               imgView =[[UIImageView alloc] initWithFrame:CGRectMake(but.frame.size.width,(COMBOXBUTHIGHT-imgHeith)/2, imgWidth,imgHeith )];
        [imgView setImage:img];
        //设置点击事件
        UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressDown:)];
        [mTap setNumberOfTapsRequired:1];
        [mTap setNumberOfTouchesRequired:1];
        [imgView addGestureRecognizer:mTap];
        imgView.userInteractionEnabled =YES;
        [self addSubview:imgView];
        //[self autoresizingMask];
    }
    return self;
}

-(void)hidSelfView
{
    showList = NO;
    
    [table setHidden:YES];
   
    CGRect sf = self.frame;
    sf.size.height = COMBOXBUTHIGHT;
    self.frame = sf;
    
    CGRect frame = table.frame;
    frame.size.height = 0;
    table.frame = frame;
}

-(void)pressDown:(id)sender
{
    
    if(showList){
        [self hidSelfView];
        //if(self.superview)[self.superview sendSubviewToBack:self];
        
        return;
    }else{
        CGRect tempFrame = self.frame;
        tempFrame.size.height =frameHeight;
        if(self.superview){
            NSLog(@"super=%@",self.superview);
            [self.superview bringSubviewToFront:self];
        }
        [table setHidden:NO];
        //[table selectRowAtIndexPath:0 animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        CGRect tabFrame =table.frame;
        tabFrame.size.height =0;
        table.frame =tabFrame;
        tabFrame.size.height =tabheight;
        
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];//选择类型
        
        self.frame = tempFrame;
        
        table.frame =tabFrame;
        
        [UIView commitAnimations];
        
        showList = YES;
        

    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    return [arr count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    static NSString *CellIdentifier = @"Cell";
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        
    }
    
    cell.backgroundColor =[UIColor grayColor];

    cell.textLabel.text = [arr objectAtIndex:[indexPath row]];
    
    cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
    
    cell.accessoryType = UITableViewCellAccessoryNone;

    //cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    //自定义选中颜色
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
    cell.selectedBackgroundView.backgroundColor = [UIColor brownColor];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return 25;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    NSUInteger row =[indexPath row];
    NSString *titName =[arr objectAtIndex:row];
    [but setTitle:titName forState:UIControlStateNormal];
    
   [self hidSelfView];
    
    self.selectData = titName;
    if(delegate) {
        [delegate didSelectData];
    }

}



@end
