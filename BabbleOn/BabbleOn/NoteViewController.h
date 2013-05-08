//
//  NoteViewController.h
//  BabbleOn
//
//  Created by Rueben Anderson on 5/2/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAlerts.h"
#import "UserSystem.h"
#import "UserDefaults.h"

@interface NoteViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, NSFileManagerDelegate>
{
    IBOutlet UILabel *colorLabel;
    IBOutlet UITextField *fileName;
    IBOutlet UITextView *noteText;
    IBOutlet UITableView *fileTable;
    
    UserAlerts *alertBlock;
    
    NSArray *notesArray;
    NSString *currentFile;
    
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
}

- (IBAction)onClick:(id)sender;
- (void)loadFiles;
@end
