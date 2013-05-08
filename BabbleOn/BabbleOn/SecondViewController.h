//
//  SecondViewController.h
//  BabbleOn
//
//  Created by Rueben Anderson on 4/8/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAlerts.h"
#import "UserDefaults.h"

@interface SecondViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *optionsTable;
    NSMutableArray *tableItems;
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
    NSString *defaultTwitter;
    
    BOOL geolocation;
    BOOL firstRun;
    
    UserAlerts *alertBlock;
}

@property (nonatomic, strong) NSArray *twitterAccounts;

- (void)loadDefaults;

@end
