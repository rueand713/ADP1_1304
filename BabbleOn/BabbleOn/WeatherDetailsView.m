//
//  WeatherDetailsView.m
//  BabbleOn
//
//  Created by Rueben Anderson on 4/29/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import "WeatherDetailsView.h"

@interface WeatherDetailsView ()

@end

@implementation WeatherDetailsView
@synthesize currentZip;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // set the title
        self.title = @"Weather";
        
        // init the weatherReport dictionary
        weatherReport = [[NSMutableDictionary alloc] init];
        
        // init the alertblock
        alertBlock = [[UserAlerts alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    // load defaults
    [self loadDefaults];
    
    // set the defaults
    [self setDefaults];
    
    // retrieve the weather xml
    [self startXMLConnection];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startXMLConnection
{
    // end any ongoing connection
    if (connXN)
    {
        [connXN cancel];
    }
    
    NSString *weatherURL = [[NSString alloc] initWithFormat:@"http://api.wxbug.net/getLiveWeatherRSS.aspx?ACode=A4441074484&zipcode=%@&unittype=0", currentZip];
    
    NSURL *url = [[NSURL alloc] initWithString:weatherURL];
    
    if (url)
    {
         xmlRequest = [[NSURLRequest alloc] initWithURL:url];
        
        if (xmlRequest)
        {
            connXN = [[NSURLConnection alloc] initWithRequest:xmlRequest delegate:self];
            
            if (connXN)
            {
                [connXN start];
            }
        }
    }
}

- (void)startImageConnection
{
    // end any ongoing connection
    if (connXN)
    {
        [connXN cancel];
    }
    
    NSString *imageURL = [weatherReport objectForKey:@"conditionImage"];
    
    NSURL *url = [[NSURL alloc] initWithString:imageURL];
    
    if (url)
    {
        imageRequest = [[NSURLRequest alloc] initWithURL:url];
        
        if (imageRequest)
        {
            connXN = [[NSURLConnection alloc] initWithRequest:imageRequest delegate:self];
            
            if (connXN)
            {
                [connXN start];
            }
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if ([[connection currentRequest] isEqual:xmlRequest])
    {
        if (weatherData)
        {
            // add the new data
            [weatherData appendData:data];
        }
        else
        {
            // initialize the weatherData object
            weatherData = [data mutableCopy];
        }
    }
    else if ([[connection currentRequest] isEqual:imageRequest])
    {
        if (imageData)
        {
            // add the new data
            [imageData appendData:data];
        }
        else
        {
            // initialize the imageData object
            imageData = [data mutableCopy];
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if ([[connection currentRequest] isEqual:xmlRequest])
    {
        // initialize the xml object
        NSXMLParser *xml = [[NSXMLParser alloc] initWithData:weatherData];
        
        if (xml)
        {
            // set the delegate
            xml.delegate = self;
            
            // begin parsing the xml data
            [xml parse];
            
            // begin downloading the image
            [self startImageConnection];
        }
    }
    else if ([[connection currentRequest] isEqual:imageRequest])
    {
        // create the UIImage from the data
        imageFromData = [UIImage imageWithData:imageData scale:3.0f];
        
        // set the image to the imageView
        condtionImage.image = imageFromData;
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // set global reference for comparing within foundCharacters method
    element = elementName;
    
    // when the element is the current-condition store the provided imageURL in the weatherReport dictionary
    if ([elementName isEqualToString:@"aws:current-condition"])
    {
        NSString *conditionImage = [attributeDict objectForKey:@"icon"];
        [weatherReport setObject:conditionImage forKey:@"conditionImage"];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([element isEqualToString:@"aws:city-state"])
    {
        [weatherReport setObject:string forKey:element];
    }
    else if ([element isEqualToString:@"aws:current-condition"])
    {
        [weatherReport setObject:string forKey:element];
    }
    else if ([element isEqualToString:@"aws:dew-point"])
    {
        [weatherReport setObject:string forKey:element];
    }
    else if ([element isEqualToString:@"aws:feels-like"])
    {
        [weatherReport setObject:string forKey:element];
    }
    else if ([element isEqualToString:@"aws:gust-direction"])
    {
        [weatherReport setObject:string forKey:element];
    }
    else if ([element isEqualToString:@"aws:gust-speed"])
    {
        [weatherReport setObject:string forKey:element];
    }
    else if ([element isEqualToString:@"aws:humidity"])
    {
        [weatherReport setObject:string forKey:element];
    }
    else if ([element isEqualToString:@"aws:pressure"])
    {
        [weatherReport setObject:string forKey:element];
    }
    else if ([element isEqualToString:@"aws:rain-today"])
    {
        [weatherReport setObject:string forKey:element];
    }
    else if ([element isEqualToString:@"aws:temp"])
    {
        [weatherReport setObject:string forKey:element];
    }
    else if ([element isEqualToString:@"aws:wind-speed"])
    {
        [weatherReport setObject:string forKey:element];
    }
    else if ([element isEqualToString:@"aws:wind-direction"])
    {
        [weatherReport setObject:string forKey:element];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    // set the label values
    cityState.text = [weatherReport objectForKey:@"aws:city-state"];
    condition.text = [weatherReport objectForKey:@"aws:current-condition"];
    dewVal.text = [[NSString alloc] initWithFormat:@"%@ F", [weatherReport objectForKey:@"aws:dew-point"]];
    humVal.text = [[NSString alloc] initWithFormat:@"%@%%", [weatherReport objectForKey:@"aws:humidity"]];
    rainVal.text = [[NSString alloc] initWithFormat:@"%@\"", [weatherReport objectForKey:@"aws:rain-today"]];
    gDirVal.text = [weatherReport objectForKey:@"aws:gust-direction"];
    gSpdVal.text = [[NSString alloc] initWithFormat:@"%@ mph", [weatherReport objectForKey:@"aws:gust-speed"]];
    wdDirVal.text = [weatherReport objectForKey:@"aws:wind-direction"];
    wdSpdVal.text = [[NSString alloc] initWithFormat:@"%@ mph", [weatherReport objectForKey:@"aws:wind-speed"]];
    preVal.text = [[NSString alloc] initWithFormat:@"%@\"", [weatherReport objectForKey:@"aws:pressure"]];
    feLikVal.text = [[NSString alloc] initWithFormat:@"%@ F", [weatherReport objectForKey:@"aws:feels-like"]];
    temperature.text = [[NSString alloc] initWithFormat:@"%@ F", [weatherReport objectForKey:@"aws:temp"]];
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
}

- (void)setDefaults
{
    // set the color data
    cityState.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    condition.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    dewPoint.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    humidity.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    rain.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    gustSpeed.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    gustDirection.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    windDirection.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    windSpeed.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    pressure.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    temperature.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    feelsLike.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    dewVal.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    humVal.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    rainVal.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    gSpdVal.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    gDirVal.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    wdSpdVal.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    wdDirVal.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    preVal.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    feLikVal.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    
    colorLabel.backgroundColor = [UIColor colorWithRed:cellRed green:cellGreen blue:cellBlue alpha:(alphaValue/100.0f)];
    self.view.backgroundColor = [UIColor colorWithRed:tableRed green:tableGreen blue:tableBlue alpha:1.0f];
    
    // set the navbar tintColor
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:cellRed green:cellGreen blue:cellBlue alpha:1.0f];
}

- (IBAction)onClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
     if (btn)
     {
         // call method to share the weather details
         [self postTweet];
     }
}

- (void)postTweet
{
    // create the progress meter with the alertBlock class
    progressMeter = alertBlock.makeShowActivity(@"Please Wait", @"Posting Tweet...", NO, self);
    
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
                        NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"];
                        NSString *tweet = [[NSString alloc] initWithFormat:@"%@\nTemp: %@ - %@\nHumidity: %@\nPressure: %@\nDewPoint: %@\nWind: %@ %@\nGust: %@ %@", cityState.text, temperature.text, condition.text, humVal.text, preVal.text, dewVal.text, wdSpdVal.text, wdDirVal.text, gSpdVal.text, gDirVal.text];
                        
                        NSMutableDictionary *twitterDictionary = [[NSMutableDictionary alloc] init];
                        
                        // setup the dictionary
                        [twitterDictionary setObject:tweet forKey:@"status"];
                        
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

@end
