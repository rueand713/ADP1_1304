//
//  UserTimelineView.h
//  BabbleOn
//
//  Created by Rueben Anderson on 4/30/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAlerts.h"
#import "UserDefaults.h"

@interface UserTimelineView : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *userTable;
    
    NSArray *twitterFeed;
    NSString *defaultTwitter;
    NSDictionary *userData;
    
    float cellRed;
    float cellBlue;
    float cellGreen;
    
    float tableRed;
    float tableBlue;
    float tableGreen;
    
    float fontRed;
    float fontBlue;
    float fontGreen;
    
    float alphaValue;
    float fontSize;
    
    UIAlertView *progressMeter;
    
    UserAlerts *alertBlock;
    NSString *userTimeline;
    BOOL firstRun;
}

@property (nonatomic, strong) NSDictionary *userData;
- (void)fetchTwitterData;
- (void)loadDefaults;
@end
