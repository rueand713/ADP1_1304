//
//  CustomLocationCell.m
//  BabbleOn
//
//  Created by Rueben Anderson on 4/30/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import "CustomLocationCell.h"
#import "UserAlerts.h"

@implementation CustomLocationCell
@synthesize removeText, weatherText, colorLabel, zipText, tableViewReference, indexPathReference, delegate;

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

- (IBAction)onSwipe:(UISwipeGestureRecognizer *)recognizer
{
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        UserAlerts *alertBlock = [[UserAlerts alloc] init];
        UIAlertView *alert;
        
        if (alertBlock)
        {
            alert = alertBlock.makeShowAlert(@"ALERT", @"Are you sure you want to remove this location?", @"No", @"Yes", NO, self, 500);
    
            // show the alert
            [alert show];
        }
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        // call the delegate and pass in the referenced indexPath and swipe param
        [delegate onSwipe:indexPathReference didSwipeLeft:NO];
    }
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        // call the delegate and pass in the referenced indexPath and swipe param
        [delegate onSwipe:indexPathReference didSwipeLeft:YES];
    }
}

@end
