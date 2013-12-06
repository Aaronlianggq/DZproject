//
//  CategoryTable.m
//  DZproject
//
//  Created by lianggq on 13-11-18.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import "CategoryTable.h"

@implementation CategoryTable{
    SEL action;
    
}

@synthesize arr,table,imgView,delegate;
@synthesize selectData,head;

- (id)initWithFrame:(CGRect)frame
{
    //frame =CGRectMake(40, 0, 400, 280);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect selfRrame = self.frame;
        UIImage *img =[UIImage imageNamed:@"push.png"];
        //得到图片的尺度
        CGFloat imgHeight =0.0f;
        CGFloat imgWidth =0.0f;
        if(img){
             imgHeight =img.size.height;
             imgWidth =img.size.width;
        }
        CGFloat imgY =(selfRrame.size.height-selfRrame.origin.y)/2;//高度居中
        imgView =[[UIImageView alloc] initWithFrame:CGRectMake(0,imgY, imgWidth, imgHeight )];
        [imgView setImage:img];
        //设置点击事件
        UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressDown:)];
        [mTap setNumberOfTapsRequired:1];
        [mTap setNumberOfTouchesRequired:1];
        [imgView addGestureRecognizer:mTap];
        imgView.userInteractionEnabled =YES;
        [self addSubview:imgView];
        
        table =[[UITableView alloc] initWithFrame:CGRectMake(imgWidth+2,0, selfRrame.size.width-imgWidth-2, selfRrame.size.height)];
        table.delegate =self;
        table.dataSource =self;
        table.layer.cornerRadius =10;
        //table.separatorColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0];
        
        table.backgroundColor =[UIColor grayColor];
        
        [self addSubview:table];
        
    }
    return self;
}

-(void)pressDown:(id)sender
{
    if(self.superview){
        [UIView beginAnimations:@"viewDisappearFromLeft" context:nil];
        [UIView setAnimationDuration:0.5];
        [self removeFromSuperview];
        [UIView commitAnimations];
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
    if(self.head){
        //head.selectData =(NSString *)[arr objectAtIndex:row];
        [head setComboxTitle:(NSString *)[arr objectAtIndex:row]];
    }
    
    if(self.delegate){
        [self.delegate didSelectCategoryData];
    }
    [UIView beginAnimations:@"viewDisappearFromLeft" context:nil];
    [UIView setAnimationDuration:0.5];
    [self removeFromSuperview];
    [UIView commitAnimations];

}


@end
