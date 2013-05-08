//
//  FirstViewController.h
//  BabbleOn
//
//  Created by Rueben Anderson on 4/8/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <MessageUI/MessageUI.h>
#import "UserAlerts.h"

@interface FirstViewController : UIViewController <UIAlertViewDelegate, MFMailComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate>
{
    IBOutlet UITableView *mainTable;
    NSArray *tableItems;
    NSArray *itemDetails;
    NSArray *twitterAccounts;
    NSArray *tableImages;
    
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
    
    UserAlerts *alertBlock;
    BOOL firstRun;
}

@property (nonatomic, strong) NSArray *twitterAccounts;

- (void)loadDefaults;
@end
