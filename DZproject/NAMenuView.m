
//
//  NAMenuView.m
//  NAMenu(九宫格)Test
//
//  Created by lianggq on 13-11-20.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import "NAMenuView.h"


@interface NAMenuView ()
@property (strong,nonatomic) NSMutableArray *itemViews;

-(void)test;
- (void)setupItemViews;
- (void)itemPressed:(id)sender;

@end

@implementation NAMenuView
@synthesize menuDelegate;
@synthesize itemViews;
@synthesize columnCountLandscape,columnCountPortrait;
@synthesize itemSize;

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

#pragma mark - Memory Management

- (id)init {
	self = [super init];
	
	if (self) {
		[self commonInit];
        // CGRect f =self.frame;
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    itemViews= [[NSMutableArray alloc] init];
    
    // set some defaults
    columnCountPortrait = 3;
    columnCountLandscape = 4;
    itemSize = CGSizeMake(100, 80);
}


#pragma -mark layout override
/*
 1、init初始化不会触发layoutSubviews
 2、addSubview会触发layoutSubviews
 3、设置view的Frame会触发layoutSubviews，当然前提是frame的值设置前后发生了变化
 4、滚动一个UIScrollView会触发layoutSubviews
 5、旋转Screen会触发父UIView上的layoutSubviews事件
 6、改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件
 */
-(void)layoutSubviews
{
    [super layoutSubviews ];
    //得到行
    
    NSUInteger numColumns = self.bounds.size.width > self.bounds.size.height ? self.columnCountLandscape : self.columnCountPortrait;
	
	NSUInteger numItems = [self.menuDelegate menuViewNumberOfItems:self];
    
	if (self.itemViews.count != numItems) {
		[self setupItemViews];
	}
    
	//得到水平间隙
    
	CGFloat padding = roundf((self.bounds.size.width - (self.itemSize.width * numColumns)) / (numColumns + 1));
    //得到行
	NSUInteger numRows = numItems % numColumns == 0 ? (numItems / numColumns) : (numItems / numColumns) + 1;
    //总高度
    CGFloat totalHeight=((self.itemSize.height+padding)*numRows) +padding;
    //垂直间隙
    CGFloat yPadding =padding;
    if(totalHeight<self.bounds.size.height){
        CGFloat leftoverHeight =self.bounds.size.height-totalHeight;
        CGFloat extraYPadding =roundf(leftoverHeight/(numRows+1));
        yPadding +=extraYPadding;
        totalHeight =((self.itemSize.height+yPadding)*numRows)+yPadding;
    }
    if (numRows == 1 && numItems < numColumns) {
		padding = roundf((self.bounds.size.width - (numItems * self.itemSize.width)) / (numItems + 1));
	}
	//布局
    for (int i = 0; i < numItems; i++) {
		UIView *item = [self.itemViews objectAtIndex:i];
		NSUInteger column = i % numColumns;
		NSUInteger row = i / numColumns;
		//CGFloat tempXPadding =(column==0?0:padding);
        
		CGFloat xOffset = (column * (self.itemSize.width + padding)) + padding;
		CGFloat yOffset = (row * (self.itemSize.height + yPadding)) + yPadding;
		item.frame = CGRectMake(xOffset, yOffset, self.itemSize.width, self.itemSize.height);
	}
    self.contentSize = CGSizeMake(self.bounds.size.width, totalHeight); //设置滚动大小
    //[self autoresizesSubviews];
    //CGSize g =self.contentSize;
    //NSString *gg=@"sd";
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

-(void)test
{
    
}

- (void)setupItemViews
{
    for(UIView *view in self.itemViews)
    {
        [view removeFromSuperview];
    }
    [self.itemViews removeAllObjects];
    
    NSUInteger numItem =[self.menuDelegate menuViewNumberOfItems:self];
    // CGRect f =self.frame;
    for(NSUInteger i=0;i<numItem;i++){
        NAMenuItemView *itemView =[[NAMenuItemView alloc]init];
        NAMenuItem *item =[self.menuDelegate menuView:self itemForIndex:i];
        itemView.frame =CGRectMake(0, 0, self.itemSize.width, self.itemSize.height);
        //[itemView.button setTitle:item.title forState:UIControlStateNormal];
        itemView.label.text =item.title;
        itemView.butTag=i;
        itemView.tag =i;
        [itemView addTarget:self forAction:@selector(itemPressed:) forEvent:UIControlEventTouchUpInside];
        [self.itemViews addObject:itemView];
        [self addSubview:itemView];
    }
    //CGRect g =self.frame;
    //NSString *ss=@"123";
}

- (void)itemPressed:(UIButton *)sender
{
    NSParameterAssert(sender);
    [self.menuDelegate menuView:self didSelectItemAtIndex:sender.tag];
}
@end

