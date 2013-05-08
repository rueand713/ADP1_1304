//
//  CustomTweetCell.m
//  BabbleOn
//
//  Created by Rueben Anderson on 4/24/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import "CustomTweetCell.h"

@implementation CustomTweetCell
@synthesize tweetLabel, dateLabel, cellColor;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
