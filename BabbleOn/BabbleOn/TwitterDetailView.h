//
//  TwitterDetailView.h
//  BabbleOn
//
//  Created by Rueben Anderson on 4/24/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDefaults.h"
#import "UserAlerts.h"

@interface TwitterDetailView : UIViewController
{
    IBOutlet UILabel *nameLabel;
    IBOutlet UITextView *tweetText;
    IBOutlet UILabel *colorLabel;
    IBOutlet UIButton *timelineButton;
    
    BOOL hideTimelineButton;
    
    NSDictionary *userData;
    NSString *defaultTwitter;
    NSString *retweetUrl;
    
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
}

@property (nonatomic, strong) NSDictionary *userData;
@property BOOL hideTimelineButton;

- (IBAction)onClick:(id)sender;
- (void)loadDefaults;
- (void)setDefaults;

@end
