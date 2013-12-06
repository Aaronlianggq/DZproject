//
//  MyComboxHead.m
//  DZproject
//
//  Created by lianggq on 13-11-18.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import "MyComboxHead.h"
#define COMBOXBUTHIGHT  30.0f  //一个下拉框按钮一般只要30的高度

@implementation MyComboxHead
@synthesize but,imgView;
@synthesize myAction,respondSEL;
@synthesize isAutoSize;
@synthesize selectData;

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        //CGRect my =self.frame;
        // Initialization code
        UIImage *img =[UIImage imageNamed:@"comSamlldown.png"];
        CGFloat imgWidth =img.size.width;
        CGFloat imgHeith =img.size.height;
        
        but =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [but setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        but.frame =CGRectMake(0, 0, frame.size.width-imgWidth, COMBOXBUTHIGHT);
        [but addTarget:self action:@selector(pressDown:) forControlEvents:UIControlEventTouchUpInside];
        [but setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter]; //对齐方式
        [self addSubview:but];
        
        //CGRect f =but.frame;
        imgView =[[UIImageView alloc] initWithFrame:CGRectMake(but.frame.size.width,(COMBOXBUTHIGHT-imgHeith)/2,imgWidth,imgHeith )];
        [imgView setImage:img];
        //CGRect imgCG =imgView.frame;
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



-(void)setComboxTitle:(NSString *)comboxTitle
{
    
    [self.but setTitle:comboxTitle forState:UIControlStateNormal];
    selectData =comboxTitle;
    
    if(isAutoSize){
//        CGSize titleSize = [buttonTitle sizeWithFont:self.but.titleLabel.font];
//        titleSize.width += 10;
//        CGRect butRect =self.but.frame;
//        [self.but setFrame:CGRectMake(butRect.size.width-titleSize.width, self.but.frame.origin.y, titleSize.width, self.but.frame.size.height)];
    }
}

-(void)pressDown:(id)sender
{
    if(self.myAction){
        //判断是否能响应消息
        if([self.respondSEL respondsToSelector:myAction]){
            [self.respondSEL performSelector: myAction withObject:self];
            
        }
    }
}

-(void)addtarget:(id)target action:(SEL)action controllEvents:(UIControlEvents)controlEvent
{
    [self.but addTarget:target action:action forControlEvents:controlEvent];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
