//
//  WeatherViewController.h
//  BabbleOn
//
//  Created by Rueben Anderson on 4/29/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAlerts.h"
#import "UserDefaults.h"
#import "CustomLocationCell.h"

@interface WeatherViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, swipeTrigger>
{
    IBOutlet UITableView *locationTable;
    IBOutlet UITextField *locationsField;
    IBOutlet UILabel *headerLabel;
    
    NSMutableArray *locations;
    NSMutableData *weatherData;
    NSString *element;
    NSMutableDictionary *weatherReport;
    
    NSFileManager *fileSystem;
    
    UserAlerts *alertBlock;
    
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
    
    BOOL firstRun;
}

- (IBAction)onClick:(id)sender;
- (void)loadDefaults;
@end
