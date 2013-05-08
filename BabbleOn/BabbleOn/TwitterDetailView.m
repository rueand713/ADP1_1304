//
//  TwitterDetailView.m
//  BabbleOn
//
//  Created by Rueben Anderson on 4/24/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import "TwitterDetailView.h"
#import "UserDetailsView.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "UserTimelineView.h"
#import "TwitterPostingView.h"

typedef enum
{
    RETWEET = 0,
    USERDETAILS,
    USERTIMELINE,
    REPLY
}detailButtons;

@implementation TwitterDetailView
@synthesize userData, hideTimelineButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // set the null text
        nameLabel.text = @"";
        tweetText.text = @"";
        
        // set the title
        self.title = @"Tweet Details";
        
        // init the alert class
        alertBlock = [[UserAlerts alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    // load the defaults
    [self loadDefaults];
    
    // set the defaults data
    [self setDefaults];
    
    if (hideTimelineButton)
    {
        // hide the timeline button
        timelineButton.hidden = YES;
    }
    
    // set the navbar tintColor
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:cellRed green:cellGreen blue:cellBlue alpha:1.0f];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    // set the objects with their text data
    nameLabel.text = [[userData objectForKey:@"user"] objectForKey:@"screen_name"];
    tweetText.text = [userData objectForKey:@"text"];
    
    // set the font size to the user name only
    nameLabel.font = [UIFont fontWithName:@"Optima" size:fontSize];
    
    // set the defaults data
    [self setDefaults];

    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDefaults
{
    // set the color data
    nameLabel.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    tweetText.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    tweetText.backgroundColor = [UIColor colorWithRed:tableRed green:tableGreen blue:tableBlue alpha:1.0f];
    colorLabel.backgroundColor = [UIColor colorWithRed:cellRed green:cellGreen blue:cellBlue alpha:(alphaValue/100.0f)];
    self.view.backgroundColor = [UIColor colorWithRed:tableRed green:tableGreen blue:tableBlue alpha:1.0f];
    
    // set the navbar tintColor
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:cellRed green:cellGreen blue:cellBlue alpha:1.0f];
}

- (IBAction)onClick:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    
    if (btn)
    {
        if (btn.tag == RETWEET)
        {
            NSString *tweetId = [userData objectForKey:@"id_str"];
            retweetUrl = [NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/retweet/%@.json", tweetId];
            
            // reTweet the message
            [self postTweet];
        }
        else if (btn.tag == USERDETAILS)
        {
            UserDetailsView *detailsView = [[UserDetailsView alloc] initWithNibName:@"UserDetailsView" bundle:nil];
            
            if (detailsView)
            {
                // pass in the twitter user data object
                detailsView.twitterData = userData;
                
                // push the details view on the stack
                [self.navigationController pushViewController:detailsView animated:YES];
            }
        }
        else if (btn.tag == USERTIMELINE)
        {
            UserTimelineView *usertimeline = [[UserTimelineView alloc] initWithNibName:@"UserTimelineView" bundle:nil];
            
            if (usertimeline)
            {
                // pass in the user data object
                usertimeline.userData = userData;
                
                // push the view on the stack
                [self.navigationController pushViewController:usertimeline animated:YES];
            }
        }
        else if (btn.tag == REPLY)
        {
            TwitterPostingView *replyPost = [[TwitterPostingView alloc] initWithNibName:@"TwitterPostingView" bundle:nil];
            
            if (replyPost)
            {
                // pass in reply details
                replyPost.postIsInReply = YES;
                replyPost.replyToID = [userData objectForKey:@"in_reply_to_user_id_str"];
                replyPost.replyToUsername = [[userData objectForKey:@"user"] objectForKey:@"screen_name"];
                
                // push the view on to the stack
                [self.navigationController pushViewController:replyPost animated:YES];
            }
        }
    }
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
    
    // load up the font size
    fontSize = (int) [UserDefaults getNumber:@"FontSize"];
    
    // reset the default font size
    if (fontSize <= 0)
    {
        fontSize = 17.0f;
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
                        NSURL *url = [NSURL URLWithString:retweetUrl];
                        //NSString *tweet = postText.text;
                        NSMutableDictionary *twitterDictionary = [[NSMutableDictionary alloc] init];
                       // [twitterDictionary setObject:[userData objectForKey:@"id_str"] forKey:@"id"];
                        
                        // setup the dictionary
                        //[twitterDictionary setObject:tweet forKey:@"status"];
                        
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
                                        
                                        // show success alert
                                        alertBlock.makeShowAlert(@"SUCCESS", @"Tweet posted to your account.", @"OK", nil, YES, self, 0);
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
                                    
                                    // show error alert
                                    alertBlock.makeShowAlert(@"ERROR", @"Your account did not authenticate or you reached your RT quota.", @"OK", nil, YES, self, 0);
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


@end
