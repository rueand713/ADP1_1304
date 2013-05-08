//
//  TwitterSetupView.h
//  BabbleOn
//
//  Created by Rueben Anderson on 4/25/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDefaults.h"
#import "UserAlerts.h"

@interface TwitterSetupView : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *accountTable;
    NSArray *twitterAccounts;
    
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
    
    BOOL firstRun;
    
    UserAlerts *alertBlock;
}

@property (nonatomic, strong) NSArray *twitterAccounts;
- (void)loadDefaults;

@end
