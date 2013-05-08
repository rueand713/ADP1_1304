//
//  TwitterPostingView.h
//  BabbleOn
//
//  Created by Rueben Anderson on 4/25/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "UserAlerts.h"
#import "UserDefaults.h"

@interface TwitterPostingView : UIViewController <UIGestureRecognizerDelegate, UITextViewDelegate, CLLocationManagerDelegate>
{
    IBOutlet UITextView *postText;
    IBOutlet UILabel *tapLabel;
    IBOutlet UILabel *colorLabel;
    
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
    
    NSString *replyToID;
    NSString *replyToUsername;
    NSString *postURL;
    NSString *defaultTwitter;
    UserAlerts *alertBlock;
    UIAlertView *progressMeter;
    
    CLLocationManager *locationManager;
    
    float lon;
    float lat;
    
    BOOL geolocation;
    BOOL postIsInReply;
}

@property (nonatomic, strong) UITextView *postText;
@property (nonatomic, strong) NSString *replyToID;
@property (nonatomic, strong) NSString *replyToUsername;
@property BOOL postIsInReply;

- (IBAction)onClick:(id)sender;
- (void)onTap:(UITapGestureRecognizer *)recognizer;
- (void)postTweet;
- (void)loadDefaults;
- (void)setDefaults;

@end
