//
//  UserDetailsView.h
//  BabbleOn
//
//  Created by Rueben Anderson on 4/24/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDefaults.h"
#import "UserAlerts.h"

@interface UserDetailsView : UIViewController <NSURLConnectionDataDelegate>
{
    IBOutlet UITextView *aboutText;
    IBOutlet UILabel *followersLabel;
    IBOutlet UILabel *followingLabel;
    IBOutlet UILabel *tweetsLabel;
    IBOutlet UILabel *locationLabel;
    IBOutlet UILabel *nameLabel;
    IBOutlet UIImageView *profileImage;
    IBOutlet UILabel *colorLabel;
    IBOutlet UILabel *followingHeader;
    IBOutlet UILabel *followerHeader;
    IBOutlet UILabel *tweetsHeader;
    
    NSURLConnection *connection;
    NSDictionary *twitterData;
    NSString *imageURL;
    UIImage *userImage;
    NSMutableData *connectionData;
    
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
    
    UserAlerts *alertBlock;
}

@property (nonatomic, strong) NSDictionary *twitterData;

- (void)fetchImage;
- (void)loadDefaults;
- (void)setDefaults;

@end
