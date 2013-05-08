//
//  CustomMainCell.m
//  BabbleOn
//
//  Created by Rueben Anderson on 4/15/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import "CustomMainCell.h"

@implementation CustomMainCell

@synthesize cellColor, cellImage, mediaText, description;

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
