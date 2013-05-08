//
//  UserDetailsView.m
//  BabbleOn
//
//  Created by Rueben Anderson on 4/24/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import "UserDetailsView.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface UserDetailsView ()

@end

@implementation UserDetailsView
@synthesize twitterData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // set the null values
        aboutText.text = @"";
        followersLabel.text = @"";
        followingLabel.text = @"";
        tweetsLabel.text = @"";
        locationLabel.text = @"";
        nameLabel.text = @"";
        
        // set null
        connectionData = nil;
        
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
    
    // set the title
    self.title = [[twitterData objectForKey:@"user"] objectForKey:@"screen_name"];
    
    // get the image link
    imageURL = [[twitterData objectForKey:@"user"] objectForKey:@"profile_image_url_https"];
    
    // fetch the user image
    [self fetchImage];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    // retrieve the numerical value data 
    id followers = [[twitterData objectForKey:@"user"] objectForKey:@"followers_count"];
    id following =  [[twitterData objectForKey:@"user"] objectForKey:@"friends_count"];
    id tweets = [[twitterData objectForKey:@"user"] objectForKey:@"statuses_count"];
    
    // set the label text
    aboutText.text = [[twitterData objectForKey:@"user"] objectForKey:@"description"];
    followersLabel.text = [NSString stringWithFormat:@"%@", followers];
    followingLabel.text = [NSString stringWithFormat:@"%@", following];
    tweetsLabel.text = [NSString stringWithFormat:@"%@", tweets];
    locationLabel.text = [[twitterData objectForKey:@"user"] objectForKey:@"location"];
    nameLabel.text = [[twitterData objectForKey:@"user"] objectForKey:@"name"];
    
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
    aboutText.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    aboutText.backgroundColor = [UIColor colorWithRed:tableRed green:tableGreen blue:tableBlue alpha:1.0f];
    followersLabel.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    followingLabel.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    tweetsLabel.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    followerHeader.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    followingHeader.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    tweetsHeader.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    locationLabel.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    nameLabel.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    colorLabel.backgroundColor = [UIColor colorWithRed:cellRed green:cellGreen blue:cellBlue alpha:(alphaValue/100.0f)];
    self.view.backgroundColor = [UIColor colorWithRed:tableRed green:tableGreen blue:tableBlue alpha:1.0f];
    
    // set the navbar tintColor
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:cellRed green:cellGreen blue:cellBlue alpha:1.0f];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connectionData == nil)
    {
        // initialize the connectionData object with the first bit of data recieved
        connectionData = (NSMutableData *)[data mutableCopy];
    }
    else
    {
        // append the data to the existing data
        [connectionData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    userImage = [UIImage imageWithData:connectionData scale:5.0f];
    
    if (userImage)
    {
        // set the profile image to the new downloaded image
        profileImage.image = userImage;
    }
}

- (void)fetchImage
{
    if (connection)
    {
        // stop a connection that is in progress
        [connection cancel];
    }
    
    // set the url
    NSURL *url = [NSURL URLWithString:imageURL];
    
    if (url)
    {
        // set the request object with the url
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        if (request)
        {
            // create the connection
            connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            if (connection)
            {
                // begin the connection
                [connection start];
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
    
    // load up the opacity
    alphaValue = [UserDefaults getNumber:@"AlphaValue"];
    
    // reset the default opacity
    if (alphaValue <= 0)
    {
        alphaValue = 85.0f;
    }
}

@end
