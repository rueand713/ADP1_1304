//
//  CustomSwitchCell.m
//  BabbleOn
//
//  Created by Rueben Anderson on 4/16/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import "CustomSwitchCell.h"
#import "UserDefaults.h"

@implementation CustomSwitchCell
@synthesize cellSwitch, cellTitle, switchID;

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

- (IBAction)onClick:(id)sender
{
    UISwitch *switchObject = (UISwitch *) sender;
    
    if (switchObject.on)
    {
        // save the selected default account to the defaults
        [UserDefaults setItem:@"YES" forKey:@"UseLocation"];
    }
    else if (!switchObject.on)
    {
        // save the selected location services
        [UserDefaults setItem:@"NO" forKey:@"UseLocation"];
    }
}

@end
