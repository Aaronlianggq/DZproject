//
//  NAMenuItemView.m
//
//  Created by Cameron Saul on 02/20/2012.
//  Copyright 2012 Cameron Saul. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "NAMenuItemView.h"
#import <QuartzCore/QuartzCore.h>

@implementation NAMenuItemView

@synthesize label;
@synthesize button;
@synthesize butTag;
- (id)init {
	self = [super init];
	
	if (self) {
		NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"NAMenuItemView" owner:self options:nil];
		[self addSubview:[views objectAtIndex:0]];
		
		// customize the view a bit
        self.button.layer.borderWidth=1.0;
        self.button.layer.borderColor=[[UIColor colorWithWhite:0.4 alpha:0.4] CGColor];
        
//        self.layer.borderWidth =1.5;
//        self.layer.borderColor=[[UIColor redColor] CGColor];
		//self.button.clipsToBounds = YES;
		self.label.layer.cornerRadius = 5.0;
        self.label.font =[UIFont systemFontOfSize:12.0];

	}
	
	return self;
}




-(void)addTarget:(id)target forAction:(SEL)action forEvent:(UIControlEvents)controlevent
{
    [self.button addTarget:target action:action forControlEvents:controlevent];
}



#pragma mark - Overriden Setters / Getters

- (void)setButTag:(NSInteger)aTag {
	self.button.tag = aTag;
    butTag =aTag;
}

- (NSInteger)butTag {
	return self.button.tag;
}

@end
