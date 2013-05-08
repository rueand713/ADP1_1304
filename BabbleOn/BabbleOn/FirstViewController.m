//
//  FirstViewController.m
//  BabbleOn
//
//  Created by Rueben Anderson on 4/8/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import "FirstViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "CustomMainCell.h"
#import "UserDefaults.h"
#import "TwitterViewController.h"
#import "WeatherViewController.h"
#import "NoteViewController.h"

typedef enum
{
    TWITTER = 0,
    EMAIL,
    NOTES,
    CAMERA,
    CAMCORDER,
    WEATHER
}tableSelections;

typedef enum
{
    PROMPT = 0,
    CANCELLED = 100,
    SENT = 200,
    SAVED = 300,
    FAILED = 500
}alertViews;

@implementation FirstViewController
@synthesize twitterAccounts;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Home", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        tableItems = [[NSArray alloc] initWithObjects:@"Twitter", @"Email", @"Notes", @"Camera", @"Camcorder", @"Weather", nil];
        itemDetails = [[NSArray alloc] initWithObjects:@"Access your timeline.", @"Send an Email.", @"Take a note.", @"Capture a photo.", @"Capture a video.", @"Set-up & view your weather feed.", nil];
        tableImages = [[NSArray alloc] initWithObjects:@"twitbird.png", @"email-icon.png", @"contactbook.png", @"camera.png", @"camcorder.png", @"weather.png", nil];
        
        // instantiate object with the UserAlerts class
        alertBlock = [[UserAlerts alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    // cancel local notifications
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    // load up the defaults
    [self loadDefaults];
    
    if (firstRun)
    {
        alertBlock.makeShowAlert(@"TIP", @"This is the home view. From here you can select and begin a task from the table.", @"Ok", nil, YES, self, 0);
        
        [UserDefaults setItem:@"NO" forKey:@"FirstViewController"];
        
        firstRun = NO;
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    // reload the table
    [mainTable reloadData];
    
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // load the defaults
    [self loadDefaults];
    
    // set the navbar tintColor
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:cellRed green:cellGreen blue:cellBlue alpha:1.0f];
    
    // set the view color
    self.view.backgroundColor = [UIColor colorWithRed:tableRed green:tableGreen blue:tableBlue alpha:1.0f];
    
    // set the table color
    mainTable.backgroundColor = [UIColor colorWithRed:tableRed green:tableGreen blue:tableBlue alpha:1.0f];
    
    return [tableItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"cell";
    
    // load a previous created cell
    CustomMainCell *cell = [mainTable dequeueReusableCellWithIdentifier:cellId];
    
    // no previous cells found create one from the bundle
    if (cell == nil)
    {
        NSArray *myBundle = [[NSBundle mainBundle] loadNibNamed:@"CustomMainCell" owner:self options:nil];
        
        cell = (CustomMainCell *) [myBundle objectAtIndex:0];
        
        // set the cell color
        cell.cellColor.backgroundColor = [UIColor colorWithRed:cellRed green:cellGreen blue:cellBlue alpha:(alphaValue/100.0f)];
        
        // set the font color
        cell.mediaText.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
        cell.description.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
        
        // set the font size
        cell.mediaText.font = [UIFont fontWithName:@"Optima" size:fontSize];
    }
    
    // set the image file
    UIImage *cellImage = [UIImage imageNamed:[tableImages objectAtIndex:indexPath.row]];
    
    // set the cell label text
    cell.mediaText.text = [tableItems objectAtIndex:indexPath.row];
    cell.description.text = [itemDetails objectAtIndex:indexPath.row];
    cell.imageView.image = cellImage;
    
    mainTable.separatorColor = [UIColor colorWithRed:tableRed green:tableGreen blue:tableBlue alpha:1.0f];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

// this method will check for the user defaults. if no defaults are found by receiving a value of 0, then the system defaults will be set in place
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
    
    // load up the font size
    fontSize = (int) [UserDefaults getNumber:@"FontSize"];
    
    // reset the default font size
    if (fontSize <= 0)
    {
        fontSize = 17.0f;
    }
    
    // load up the default twitter account
    defaultTwitter = [UserDefaults getItem:@"TwitterAccount"];
    
    if (defaultTwitter == nil)
    {
        defaultTwitter = @"No Account";
    }
    
    // load up the first run data
    if ([[UserDefaults getItem:@"FirstViewController"] isEqual:@"NO"])
    {
        firstRun = NO;
    }
    else
    {
        firstRun = YES;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == TWITTER)
    {
        TwitterViewController *twitterView = [[TwitterViewController alloc] initWithNibName:@"TwitterViewController" bundle:nil];
        
        if (twitterView)
        {
            // push the twitter view on the stack
            [self.navigationController pushViewController:twitterView animated:YES];
        }
    }
    else if (indexPath.row == CAMERA)
    {
        UIImagePickerController *imageController = [[UIImagePickerController alloc] init];
        
        if (imageController)
        {
            imageController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imageController.allowsEditing = YES;
            imageController.delegate = (id) self;
            
            // present the camera for photo
            [self presentViewController:imageController animated:YES completion:nil];
        }
        
    }
    else if (indexPath.row == CAMCORDER)
    {
        UIImagePickerController *imageController = [[UIImagePickerController alloc] init];
        
        if (imageController)
        {
            imageController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imageController.allowsEditing = NO;
            imageController.videoQuality = UIImagePickerControllerQualityTypeMedium;
            imageController.delegate = (id) self;
            imageController.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, nil];
            
            // present the camera for video
            [self presentViewController:imageController animated:YES completion:nil];
        }
    }
    else if (indexPath.row == EMAIL)
    {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        
        if (mailController)
        {
            // ensure the device can send mail
            if ([MFMailComposeViewController canSendMail])
            {
                // set the delegate
                mailController.mailComposeDelegate = self;
                
                mailController.title = @"Compose Email";
            
                // present the view
                [self presentViewController:mailController animated:YES completion:nil];
            }
        }
    }
    else if (indexPath.row == NOTES)
    {
        NoteViewController *noteView = [[NoteViewController alloc] initWithNibName:@"NoteViewController" bundle:nil];
        
        if (noteView)
        {
            [self.navigationController pushViewController:noteView animated:YES];
        }
    }
    else if (indexPath.row == WEATHER)
    {
        WeatherViewController *weatherView = [[WeatherViewController alloc] initWithNibName:@"WeatherViewController" bundle:nil];
        
        if (weatherView)
        {
            [self.navigationController pushViewController:weatherView animated:YES];
        }
    }
}

// the email tracking delegate method
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    
    if (result == MFMailComposeResultCancelled)
    {
            [self dismissViewControllerAnimated:YES completion:^{
            
            // show alert informing the user the email has been cancelled
            alertBlock.makeShowAlert(@"ALERT", @"The email has been cancelled.", @"OK", nil, YES, self, PROMPT);
        }];
    }
    else if (result == MFMailComposeResultSent)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            
            // should show alert message informing user the email was sent
            alertBlock.makeShowAlert(@"SUCCESS", @"The email has been sent.", @"OK", nil, YES, self, PROMPT);
            
        }];
    }
    else if (result == MFMailComposeResultFailed)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            
            // should show prompt informing user the email was not sent
            alertBlock.makeShowAlert(@"ERROR", @"The email failed to send.", @"OK", nil, YES, self, PROMPT);
        }];
    }
    else if (result == MFMailComposeResultSaved)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            
            // show prompt informing user that the email has been saved
            alertBlock.makeShowAlert(@"SAVED", @"The email has been saved.", @"OK", nil, YES, self, PROMPT);
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        // track the alert button clicks here
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"Select An Option";
    
    return title;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // editing is allowed on the photos but not the video
    if (picker.editing)
    {
        // select the edited image
        UIImage *capturedPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        if (capturedPhoto)
        {
            // save the photo to the album
            UIImageWriteToSavedPhotosAlbum(capturedPhoto, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    else
    {
        NSURL *medURL = [info objectForKey:@"UIImagePickerControllerMediaURL"];
        
        if (medURL)
        {
            // grab the media path
            NSString *videoPath = [medURL path];
            
            if (videoPath)
            {
                // save the movie file
                UISaveVideoAtPathToSavedPhotosAlbum(videoPath, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            }
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
       
        // editing is allowed on the photos but not the video
        if (picker.allowsEditing)
        {
            // inform the user that the capture mode has been cancelled
            alertBlock.makeShowAlert(@"ALERT", @"Photo capture cancelled.", @"OK", nil, YES, self, 0);
        }
        else
        {
            // inform the user that the capture mode has been cancelled
            alertBlock.makeShowAlert(@"ALERT", @"Video capture cancelled.", @"OK", nil, YES, self, 0);
        }
    }];
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (!error)
        {
            // inform the user of the success
            alertBlock.makeShowAlert(@"SUCCESS", @"File saved to device.", @"OK", nil, YES, self, 0);
        }
        else
        {
            // inform the user of the error
            alertBlock.makeShowAlert(@"ERROR", @"An error occurred while saving.", @"OK", nil, YES, self, 0);
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

@end
