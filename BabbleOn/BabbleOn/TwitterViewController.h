//
//  TwitterViewController.h
//  BabbleOn
//
//  Created by Rueben Anderson on 4/22/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "UserDefaults.h"
#import "UserAlerts.h"

@interface TwitterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *twitterTable;
    IBOutlet UILabel *headerLabel;
    IBOutlet UILabel *timelineText;
    IBOutlet UISegmentedControl *timelineControl;
    
    NSString *defaultTwitter;
    NSString *timeline;
    NSArray *twitterFeed;
    
    float tableRed;
    float tableBlue;
    float tableGreen;
    
    float cellRed;
    float cellBlue;
    float cellGreen;
    
    float fontRed;
    float fontBlue;
    float fontGreen;
    
    float alphaValue;
    float fontSize;
    
    UserAlerts *alertBlock;
    UIAlertView *progressMeter;
    BOOL firstRun;
}

- (void)fetchTwitterData;
- (void)loadDefaults;
- (IBAction)onClick:(id)sender;
- (IBAction)onClickSegment:(id)sender;

@end
