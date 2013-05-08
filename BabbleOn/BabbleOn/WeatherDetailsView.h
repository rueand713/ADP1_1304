//
//  WeatherDetailsView.h
//  BabbleOn
//
//  Created by Rueben Anderson on 4/29/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "UserAlerts.h"
#import "UserDefaults.h"

@interface WeatherDetailsView : UIViewController <NSXMLParserDelegate, NSURLConnectionDataDelegate>
{
    NSMutableData *weatherData;
    NSMutableData *imageData;
    UIImage *imageFromData;
    NSString *element;
    NSMutableDictionary *weatherReport;
    NSURLConnection *connXN;
    NSString *currentZip;
    
    NSURLRequest *xmlRequest;
    NSURLRequest *imageRequest;

    
    // Weather Outlets
    IBOutlet UIImageView *condtionImage;
    IBOutlet UILabel *cityState;
    IBOutlet UILabel *condition;
    IBOutlet UILabel *dewPoint;
    IBOutlet UILabel *humidity;
    IBOutlet UILabel *rain;
    IBOutlet UILabel *gustSpeed;
    IBOutlet UILabel *gustDirection;
    IBOutlet UILabel *windSpeed;
    IBOutlet UILabel *windDirection;
    IBOutlet UILabel *pressure;
    IBOutlet UILabel *temperature;
    IBOutlet UILabel *feelsLike;
    IBOutlet UILabel *colorLabel;
    IBOutlet UILabel *dewVal;
    IBOutlet UILabel *humVal;
    IBOutlet UILabel *rainVal;
    IBOutlet UILabel *gSpdVal;
    IBOutlet UILabel *gDirVal;
    IBOutlet UILabel *wdSpdVal;
    IBOutlet UILabel *wdDirVal;
    IBOutlet UILabel *preVal;
    IBOutlet UILabel *feLikVal;
    
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
    UIAlertView *progressMeter;
    NSString *defaultTwitter;
    
}

@property (nonatomic, strong) NSString *currentZip;
- (void)startXMLConnection;
- (void)startImageConnection;
- (void)setDefaults;
- (void)postTweet;
- (IBAction)onClick:(id)sender;
@end
