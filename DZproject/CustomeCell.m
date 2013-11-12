//
//  CustomeCell.m
//  DZproject
//
//  Created by lianggq on 13-11-12.
//  Copyright (c) 2013年 lianggq. All rights reserved.
//

#import "CustomeCell.h"

@implementation CustomeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
