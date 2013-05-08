//
//  UserTimelineView.m
//  BabbleOn
//
//  Created by Rueben Anderson on 4/30/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import "UserTimelineView.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "CustomTweetCell.h"
#import "TwitterDetailView.h"

@interface UserTimelineView ()

@end

@implementation UserTimelineView
@synthesize userData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // init the alert class
        alertBlock = [[UserAlerts alloc] init];
        
        userTimeline = @"https://api.twitter.com/1.1/statuses/user_timeline.json";
    }
    return self;
}

- (void)viewDidLoad
{
    // load up the defaults
    [self loadDefaults];
    
    // set the title
    self.title = [[userData objectForKey:@"user"] objectForKey:@"screen_name"];
    
    if (firstRun)
    {
        alertBlock.makeShowAlert(@"TIP", @"This is the User timeline view. From here you may view your friends' timeline.", @"Ok", nil, YES, self, 0);
        
        [UserDefaults setItem:@"NO" forKey:@"UserTimelineView"];
        
        firstRun = NO;
    }
    
    // call method to fetch tweets
    [self fetchTwitterData];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchTwitterData
{
    // create the progress meter with the alertBlock class
    progressMeter = alertBlock.makeShowActivity(@"Please Wait", @"Loading your user timeline...", NO, self);
    
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
                    
                    // if the account exists
                    if (account)
                    {
                        
                        NSString *username = [[userData objectForKey:@"user"] objectForKey:@"screen_name"];
                        NSURL *url = [NSURL URLWithString:userTimeline];
                        NSArray *dictKeys = @[@"screen_name"];
                        NSArray *dictValues = @[username];
                        NSDictionary *twitterDictionary = [[NSDictionary alloc] initWithObjects:dictValues forKeys:dictKeys];
                        
                        // set the SLRequest object properties
                        SLRequest *twitterRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:twitterDictionary];
                        
                        // set the SLRequest account
                        twitterRequest.account = account;
                        
                        // perform the request
                        [twitterRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                            
                            if (responseData)
                            {
                                if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300)
                                {
                                    NSError *jErr;
                                    NSArray *twiJSON = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jErr];
                                    
                                    if (twiJSON)
                                    {
                                        // set the twitter data for use in the table
                                        twitterFeed = twiJSON;
                                        
                                        // reload the table
                                        [userTable reloadData];
                                        
                                        if (progressMeter)
                                        {
                                            // dismiss the view
                                            [progressMeter dismissWithClickedButtonIndex:0 animated:YES];
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
                                        alertBlock.makeShowAlert(@"OOPS", @"An unexpected error occurred.", @"OK", nil, YES, self, 0);
                                        
                                        // log json error data
                                        NSLog(@"%@", [jErr localizedDescription]);
                                    }
                                }
                                else
                                {
                                    if (progressMeter)
                                    {
                                        // dismiss the view
                                        [progressMeter dismissWithClickedButtonIndex:0 animated:YES];
                                    }
                                    
                                    alertBlock.makeShowAlert(@"OOPS", @"Failed to retrieve Tweets from server.", @"Ok", nil, YES, self, 0);
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
                                alertBlock.makeShowAlert(@"ERROR", @"Your account did not authenticate.", @"OK", nil, YES, self, 0);
                                
                                // log request error data
                                NSLog(@"%@", [error localizedDescription]);
                            }
                        }];
                    }
                    else if (account == nil)
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // load up the defaults
    [self loadDefaults];
    
    // set the navbar tintColor
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:cellRed green:cellGreen blue:cellBlue alpha:1.0f];
    
    // set the view color
    self.view.backgroundColor = [UIColor colorWithRed:tableRed green:tableGreen blue:tableBlue alpha:1.0f];
    
    // set the table color
    userTable.backgroundColor = [UIColor colorWithRed:tableRed green:tableGreen blue:tableBlue alpha:1.0f];

    if (twitterFeed)
    {
        // if twitter data exists return that count of the array
        return [twitterFeed count];
    }
    else
    {
        // no data available return 0
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"tweet";
    
    CustomTweetCell *cell = [userTable dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        // load the custom tweet cell from the bundle
        NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"CustomTweetCell" owner:self options:nil];
        
        if (bundle)
        {
            // set the cell from the bundle
            cell = (CustomTweetCell *) [bundle objectAtIndex:0];
        }
    }
    
    // set the cell & table data
    userTable.separatorColor = [UIColor colorWithRed:tableRed green:tableGreen blue:tableBlue alpha:1.0f];
    cell.tweetLabel.text = [[twitterFeed objectAtIndex:indexPath.row] objectForKey:@"text"];
    cell.dateLabel.text = [[twitterFeed objectAtIndex:indexPath.row] objectForKey:@"created_at"];
    cell.tweetLabel.font = [UIFont fontWithName:@"Optima" size:fontSize];
    cell.tweetLabel.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    cell.dateLabel.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    cell.cellColor.backgroundColor = [UIColor colorWithRed:cellRed green:cellGreen blue:cellBlue alpha:(alphaValue/100.0f)];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TwitterDetailView *detailView = [[TwitterDetailView alloc] initWithNibName:@"TwitterDetailView" bundle:nil];
    
    if (detailView)
    {
        // pass in the userdata dictionary
        detailView.userData = [twitterFeed objectAtIndex:indexPath.row];
        
        // hide the timeline button to prevent an endless drill down
        detailView.hideTimelineButton = YES;
        
        // push the view on to the stack
        [self.navigationController pushViewController:detailView animated:YES];
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
        NSLog(@"%@", defaultTwitter);
    }
    
    // load up the font size
    fontSize = (int) [UserDefaults getNumber:@"FontSize"];
    
    // reset the default font size
    if (fontSize <= 0)
    {
        fontSize = 17.0f;
    }
    
    // load up the first run data
    if ([[UserDefaults getItem:@"UserTimelineView"] isEqual:@"NO"])
    {
        firstRun = NO;
    }
    else
    {
        firstRun = YES;
    }
}



@end
