//
//  DefaultSettingsCell.m
//  BabbleOn
//
//  Created by Rueben Anderson on 4/25/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import "DefaultSettingsCell.h"

@implementation DefaultSettingsCell
@synthesize cellID, imageView, cellText;

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
