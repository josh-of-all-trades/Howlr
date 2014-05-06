//
//  JERMessageTableViewCell.m
//  Howlr
//
//  Created by Josh Rojas on 5/6/14.
//  Copyright (c) 2014 Joshua Rojas. All rights reserved.
//

#import "JERMessageTableViewCell.h"

@implementation JERMessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
