//
//  JERTableViewCell.m
//  Howlr
//
//  Created by Josh Rojas on 4/30/14.
//  Copyright (c) 2014 Joshua Rojas. All rights reserved.
//

#import "JERTableViewCell.h"

@implementation JERTableViewCell

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
