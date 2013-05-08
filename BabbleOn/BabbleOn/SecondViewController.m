//
//  SecondViewController.m
//  BabbleOn
//
//  Created by Rueben Anderson on 4/8/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import "SecondViewController.h"
#import "CustomStepperCell.h"
#import "CustomSliderCell.h"
#import "CustomSwitchCell.h"
#import "DefaultSettingsCell.h"
#import "TwitterSetupView.h"

@interface SecondViewController ()

@end

@implementation SecondViewController
@synthesize twitterAccounts;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Settings", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
        
        // init the alert class
        alertBlock = [[UserAlerts alloc] init];
    }
    return self;
}
							
- (void)viewDidLoad
{
    // load the defaults
    [self loadDefaults];
    
    if (firstRun)
    {
        alertBlock.makeShowAlert(@"TIP", @"This is the settings view. You can customize the look, choose to use geo-location and set-up your default Twitter account.", @"Ok", nil, YES, self, 0);
        
        [UserDefaults setItem:@"NO" forKey:@"SecondViewController"];
        
        firstRun = NO;
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    tableItems = [NSMutableArray arrayWithObjects:@"Table Cell Color", @"Table Color", @"Cell Opacity", @"Font Size", @"Font Color", @"Use Location", @"No Account", nil];
    
   /* for (int i = 0; i < [twitterAccounts count]; i++)
    {
        NSString *accountName = [twitterAccounts objectAtIndex:i];
        
        [tableItems insertObject:accountName atIndex:[tableItems count]];
    }*/
    
    // set the initial default
    if (twitterAccounts)
    {
        defaultTwitter = [twitterAccounts objectAtIndex:0];
    }
    else
    {
        defaultTwitter = @"No Account";
    }
    
    // reload the table
    [optionsTable reloadData];
    
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int customSections = 0;
    
    // sets the customSections int to the number of rows for each section using the section parameter
    if (section == 0)
    {
        // returns 3 for the number of rows in the 'UI Cusomizations'
        customSections = 3;
    }
    else if (section == 1)
    {
        // returns 2 for the number of rows in the 'Font Styling'
        customSections = 2;
    }
    else if (section == 2)
    {
        // return 1 for the single location object
        customSections = 1;
    }
    else if (section == 3)
    {
        // return 1 for the default twitter account
        customSections = 1;
    }
    
    // set the navbar tintColor
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:cellRed green:cellGreen blue:cellBlue alpha:1.0f];
    
    // set the view color
    self.view.backgroundColor = [UIColor colorWithRed:tableRed green:tableGreen blue:tableBlue alpha:1.0f];
    
    return customSections;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // load the defaults
    [self loadDefaults];
    
    NSString *cellId = @"settingCell";
    
    // to keep track of the cells in the section
    int sectionCount = 0;
    
    if (indexPath.section < 2)
    {
        // equation to programatically set the proper cells in the table for the first two sections
        sectionCount = indexPath.row + (indexPath.section * 3);
    }
    else if (indexPath.section == 2)
    {
        sectionCount = indexPath.section + 3;
    }
    else if (indexPath.section == 3)
    {
        // equation to programatically set the proper cells in the table for the last section
        sectionCount = indexPath.row + (indexPath.section * 2);
    }
    
    // a nil cell that should never be returned
    UITableViewCell *cell;
    
    // load a previous created cell
    if (sectionCount == 2 || sectionCount == 3)
    {
        CustomStepperCell *cellA = [optionsTable dequeueReusableCellWithIdentifier:cellId];
        
        // no previous cells found create one from the bundle
        if (cellA == nil)
        {
            NSArray *myBundle = [[NSBundle mainBundle] loadNibNamed:@"CustomStepperCell" owner:self options:nil];
            
            // cast the returned nib to the proper object type
            cellA = (CustomStepperCell *) [myBundle objectAtIndex:0];
            
            // set the cell label text
            cellA.cellTitle.text = [tableItems objectAtIndex:sectionCount];
            
            if (sectionCount == 2)
            {
                // set the stepper defaults for changing the opacity
                cellA.stepper.minimumValue = 5.0f;
                cellA.stepper.maximumValue = 100.0f;
                cellA.stepper.stepValue = 5.0f;
                cellA.stepper.value = alphaValue;
                
                // set the current stepVal label text for the opacity
                cellA.stepVal.text = [NSString stringWithFormat:@"%i%%", (int)(alphaValue)];
            }
            else if (sectionCount == 3)
            {
                // set the current stepVal label text for the font size
                cellA.stepVal.text = [NSString stringWithFormat:@"%ipt", (int)fontSize];
                cellA.stepper.value = fontSize;
            }
            
            // set the cell stepperID
            cellA.stepperID = sectionCount;
            
            return cellA;
        }
    }
    else if (sectionCount < 2 || sectionCount == 4)
    {
        CustomSliderCell *cellB = [optionsTable dequeueReusableCellWithIdentifier:cellId];
        
        // no previous cells found create one from the bundle
        if (cellB == nil)
        {
            NSArray *myBundle = [[NSBundle mainBundle] loadNibNamed:@"CustomSliderCell" owner:self options:nil];
            
            // cast the returned nib to the proper object type
            cellB = (CustomSliderCell *) [myBundle objectAtIndex:0];
            
            // set the cell label text
            cellB.cellTitle.text = [tableItems objectAtIndex:sectionCount];
            
            // set the cell sliderID
            cellB.sliderID = sectionCount;
            
            if (sectionCount == 0)
            {
                // update the sliders
                cellB.sliderA.value = (cellRed * 255);
                cellB.sliderB.value = (cellGreen * 255);
                cellB.sliderC.value = (cellBlue * 255);
                
                // table cell color label
                cellB.sliderLabel.backgroundColor = [UIColor colorWithRed:cellRed green:cellGreen blue:cellBlue alpha:1.0f];
            }
            else if (sectionCount == 1)
            {
                // update the sliders
                cellB.sliderA.value = (tableRed * 255);
                cellB.sliderB.value = (tableGreen * 255);
                cellB.sliderC.value = (tableBlue * 255);
                
                // overlay color label
                cellB.sliderLabel.backgroundColor = [UIColor colorWithRed:tableRed green:tableGreen blue:tableBlue alpha:1.0f];
            }
            else if (sectionCount == 4)
            {
                // update the sliders
                cellB.sliderA.value = (fontRed * 255);
                cellB.sliderB.value = (fontGreen * 255);
                cellB.sliderC.value = (fontBlue * 255);
                
                // font color label
                cellB.sliderLabel.backgroundColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
            }
            
            return cellB;
        }
    }
    else if (sectionCount == 5)
    {
        CustomSwitchCell *cellC = [optionsTable dequeueReusableCellWithIdentifier:cellId];
        
        // no previous cells found, create one from the bundle
        if (cellC == nil)
        {
            NSArray *myBundle = [[NSBundle mainBundle] loadNibNamed:@"CustomSwitchCell" owner:self options:nil];
            
            // cast the returned nib to the proper object type
            cellC = (CustomSwitchCell *) [myBundle objectAtIndex:0];
            
            // set the cell label text
            cellC.cellTitle.text = [tableItems objectAtIndex:sectionCount];
            
            // set the cell switchID
            cellC.switchID = sectionCount;
            
            // set the cell switchValue
            cellC.cellSwitch.on = geolocation;
            
            return cellC;
        }
    }
    else if (sectionCount == 6)
    {
        DefaultSettingsCell *cellD = [optionsTable dequeueReusableCellWithIdentifier:cellId];
        
        // no previous cell found, create one from the bundle
        if (cellD == nil)
        {
            NSArray *myBundle = [[NSBundle mainBundle] loadNibNamed:@"DefaultSettingsCell" owner:self options:nil];
            
            // cast the returned nib to the proper object type
            cellD = (DefaultSettingsCell *) [myBundle objectAtIndex:0];
            
            // set the cell label text
            // if there is a defaultTwitter set-up
            cellD.cellText.text = defaultTwitter;
            
            // set the cell cellID
            cellD.cellID = sectionCount;
            
            return cellD;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3)
    {
        TwitterSetupView *selectTwitter = [[TwitterSetupView alloc] initWithNibName:@"TwitterSetupView" bundle:nil];
        
        if (selectTwitter)
        {
            // pass in the twitter accounts
            selectTwitter.TwitterAccounts = twitterAccounts;
            
            // push the view on the stack
            [self.navigationController pushViewController:selectTwitter animated:YES];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    // set the section titles for each section
    NSString *sectionTitle;
    
    if (section == 0)
    {
        sectionTitle = @"UI Customization";
    }
    else if (section == 1)
    {
        sectionTitle = @"Font Styling";
    }
    else if (section == 2)
    {
        sectionTitle = @"GeoLocation";
    }
    else if (section == 3)
    {
        sectionTitle = @"Twitter";
    }
    
    return sectionTitle;
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
    
    // load up the geolocation data
    if ([[UserDefaults getItem:@"UseLocation"] isEqual:@"YES"])
    {
        geolocation = YES;
    }
    else
    {
        geolocation = NO;
    }
    
    // load up the first run data
    if ([[UserDefaults getItem:@"SecondViewController"] isEqual:@"NO"])
    {
        firstRun = NO;
    }
    else
    {
        firstRun = YES;
    }
}


@end
