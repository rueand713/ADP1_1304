//
//  TwitterPostingView.m
//  BabbleOn
//
//  Created by Rueben Anderson on 4/25/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import "TwitterPostingView.h"

typedef enum
{
    CANCEL = 0,
    POST
}buttonTags;

@implementation TwitterPostingView
@synthesize postText, replyToID, replyToUsername, postIsInReply;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // set the posting URL
        postURL = @"https://api.twitter.com/1.1/statuses/update.json";
        
        // initialize the alerts class
        alertBlock = [[UserAlerts alloc] init];
        
       // set the title
        self.title = @"Compose Tweet";
    }
    return self;
}

- (void)viewDidLoad
{
    // load the defaults data
    [self loadDefaults];
    
    // instantiate the location manager
    locationManager = [[CLLocationManager alloc] init];
    
    if (locationManager)
    {
        // set the accuracy of the location object
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        
        // set up the delegate
        locationManager.delegate = self;
        
        // only begins updating if the user elected to use geo
       if (geolocation)
       {
           // begin the location updates
           [locationManager startUpdatingLocation];
       }
    }
    
    // setup the tap gesture
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    
    if (tap)
    {
        tap.numberOfTapsRequired = 1;
        [tapLabel addGestureRecognizer:tap];
    }
    
    // if this post is a reply post
    if (postIsInReply)
    {
        // set the post text to include the @username format
        postText.text = [NSString stringWithFormat:@"@%@ ", replyToUsername];
    }
    
    // set the defaults data
    [self setDefaults];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    // load and set the defaults data
    [self loadDefaults];
    [self setDefaults];
    
    [super viewDidAppear:animated];
}

- (void)setDefaults
{
    // set the color data
    postText.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    postText.backgroundColor = [UIColor colorWithRed:tableRed green:tableGreen blue:tableBlue alpha:1.0f];
    colorLabel.backgroundColor = [UIColor colorWithRed:cellRed green:cellGreen blue:cellBlue alpha:(alphaValue/100.0f)];
    self.view.backgroundColor = [UIColor colorWithRed:tableRed green:tableGreen blue:tableBlue alpha:1.0f];
    
    // set the navbar tintColor
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:cellRed green:cellGreen blue:cellBlue alpha:1.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClick:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    
    if (btn)
    {
        if (btn.tag == CANCEL)
        {
            [self dismissViewControllerAnimated:YES completion:^{
                
                // set up an alert message to be shown
                alertBlock.makeShowAlert(@"ALERT", @"Twitter post cancelled.", @"OK", nil, YES, self, 0);
            }];
        }
        else if (btn.tag == POST)
        {
            // try to post the tweet
            [self postTweet];
        }
    }
}

- (void)postTweet
{
    // create the progress meter with the alertBlock class
    progressMeter = alertBlock.makeShowActivity(@"Please Wait", @"Posting your tweet...", NO, self);
    
    if (progressMeter)
    {
        // show the alert
        [progressMeter show];
    }
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    if (accountStore)
    {
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        if (accountType)
        {
            [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
                
                if (granted)
                {
                    NSArray *twitterAccounts = [accountStore accountsWithAccountType:accountType];
                    
                    // set up a nil account
                    ACAccount *account = nil;
                    
                    // iterate through the list of accounts for the default account
                    for (int i = 0; i < [twitterAccounts count]; i++)
                    {
                        // temp ACAccount
                        ACAccount *tempAccount = [twitterAccounts objectAtIndex:i];
                        
                        // temp strings
                        NSString *extractedName = [tempAccount.username lowercaseString];
                        NSString *accountName = [defaultTwitter lowercaseString];
                        
                        // if the account is found set the account otherwise leave it nil
                        if ([extractedName isEqualToString:accountName])
                        {
                            account = [twitterAccounts objectAtIndex:i];
                            break;
                        }
                    }
                    
                    if (account)
                    {
                        NSURL *url = [NSURL URLWithString:postURL];
                        NSString *tweet = postText.text;
                        NSMutableDictionary *twitterDictionary = [[NSMutableDictionary alloc] init];
                        
                        // setup the dictionary
                        [twitterDictionary setObject:tweet forKey:@"status"];
                        
                        // if this is a reply to post
                        if (postIsInReply)
                        {
                            // set the in reply to attribute
                            [twitterDictionary setObject:replyToID forKey:@"in_reply_to_status_id"];
                        }
                        
                        if (geolocation)
                        {
                            // string up the lat and lon
                            NSString *tempLat = [NSString stringWithFormat:@"%f", lat];
                            NSString *tempLon = [NSString stringWithFormat:@"%f", lon];
                            
                            // add the coordinate data to the dictionary
                            [twitterDictionary setObject:tempLat forKey:@"lat"];
                            [twitterDictionary setObject:tempLon forKey:@"lon"];
                        }
                        
                        
                        // set the SLRequest object properties
                        SLRequest *twitterRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:url parameters:twitterDictionary];
                        
                        // set the SLRequest account
                        twitterRequest.account = account;
                        
                        // perform the request
                        [twitterRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                            
                            if (responseData)
                            {
                                if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300)
                                {
                                    if (progressMeter)
                                    {
                                        // dismiss the view
                                        [progressMeter dismissWithClickedButtonIndex:0 animated:YES];
                                    }
                                    
                                    [self dismissViewControllerAnimated:YES completion:^{
                                       
                                        // show success alert
                                        alertBlock.makeShowAlert(@"SUCCESS", @"Tweet posted to your account.", @"OK", nil, YES, self, 0);
                                        
                                    }];
                                }
                                else
                                {
                                    if (progressMeter)
                                    {
                                        // dismiss the view
                                        [progressMeter dismissWithClickedButtonIndex:0 animated:YES];
                                    }
                                    
                                    // show error alert
                                    alertBlock.makeShowAlert(@"ERROR", @"Your tweet failed to post. Please try again.", @"OK", nil, YES, self, 0);
                                }
                            }
                            else
                            {
                                if (progressMeter)
                                {
                                    // dismiss the view
                                    [progressMeter dismissWithClickedButtonIndex:0 animated:YES];
                                }
                                
                                [self dismissViewControllerAnimated:YES completion:^{
                                    
                                    // show error alert
                                    alertBlock.makeShowAlert(@"ERROR", @"Your account did not authenticate.", @"OK", nil, YES, self, 0);
                                    
                                }];
                            }
                        }];
                    }
                    else
                    {
                        if (progressMeter)
                        {
                            // dismiss the view
                            [progressMeter dismissWithClickedButtonIndex:0 animated:YES];
                        }
                        
                        // show an alert inform the user no account found
                        alertBlock.makeShowAlert(@"ALERT", @"No Account found or you have not selected an account in settings.", @"OK", nil, YES, self, 0);
                    }
                }
                else
                {
                    // no access granted
                    if (progressMeter)
                    {
                        // dismiss the view
                        [progressMeter dismissWithClickedButtonIndex:0 animated:YES];
                    }
                    
                    // show error alert
                    alertBlock.makeShowAlert(@"ERROR", @"Access to device account is denied.", @"OK", nil, YES, self, 0);
                }
            }];
        }
    }
}

- (void)onTap:(UITapGestureRecognizer *)recognizer
{
        // hide the label
        tapLabel.hidden = YES;
        tapLabel.enabled = NO;
        
        // close the keyboard
        [postText resignFirstResponder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    // unhide the tap label
    tapLabel.hidden = NO;
    tapLabel.enabled = YES;
}

- (void)loadDefaults
{
    //load up the table pallete
    tableRed = [UserDefaults getNumber:@"TableRed"];
    tableBlue = [UserDefaults getNumber:@"TableBlue"];
    tableGreen = [UserDefaults getNumber:@"TableGreen"];
    
    // check the see if default table colors need to be reset
    if (tableRed <= 0)
    {
        // set the default red value
        tableRed = 50.0f/255;
    }
    
    if (tableBlue <= 0)
    {
        // set the default blue value
        tableBlue = 50.0f/255;
    }
    
    if (tableGreen <= 0)
    {
        // set the default green value
        tableGreen = 50.0f/255;
    }
    
    // load up the font pallete
    fontRed = [UserDefaults getNumber:@"FontRed"];
    fontBlue = [UserDefaults getNumber:@"FontBlue"];
    fontGreen = [UserDefaults getNumber:@"FontGreen"];
    
    // check to verify if default font colors need to be reset
    if (fontRed <= 0)
    {
        // set the default red value
        fontRed = 1.0f;
    }
    
    if (fontBlue <= 0)
    {
        // set the default blue value
        fontBlue = 1.0f;
    }
    
    if (fontGreen <= 0)
    {
        // set the default green value
        fontGreen = 1.0f;
    }
    
    // load up the cell pallete
    cellRed = [UserDefaults getNumber:@"CellRed"];
    cellBlue = [UserDefaults getNumber:@"CellBlue"];
    cellGreen = [UserDefaults getNumber:@"CellGreen"];
    
    if (cellRed <= 0)
    {
        // set the default red value
        cellRed = 69.0f/255;
    }
    
    if (cellBlue <= 0)
    {
        // set the default blue value
        cellBlue = 165.0f/255;
    }
    
    if (cellGreen <= 0)
    {
        // set the default green value
        cellGreen = 127.0f/255;
    }
    
    // load up the opacity
    alphaValue = [UserDefaults getNumber:@"AlphaValue"];
    
    // reset the default opacity
    if (alphaValue <= 0)
    {
        alphaValue = 85.0f;
    }
    
    // load up the default twitter account
    defaultTwitter = [UserDefaults getItem:@"TwitterAccount"];
    
    if (defaultTwitter == nil)
    {
        defaultTwitter = @"No Account";
    }
    
    // load up the geolocation data
    if ([[UserDefaults getItem:@"UseLocation"] isEqual:@"YES"])
    {
        geolocation = YES;
    }
    else
    {
        geolocation = NO;
    }
}

- (void)locationManager:(CLLocationManager *)manager
didUpdateToLocation:(CLLocation *)newLocation
fromLocation:(CLLocation *)oldLocation __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_6, __MAC_NA, __IPHONE_2_0, __IPHONE_6_0)
{
    // grab the updated location coordinate data
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    
    lat = coordinate.latitude;
    lon = coordinate.longitude;
}

@end
