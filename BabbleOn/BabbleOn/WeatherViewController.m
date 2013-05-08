//
//  WeatherViewController.m
//  BabbleOn
//
//  Created by Rueben Anderson on 4/29/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherDetailsView.h"

@interface WeatherViewController ()

@end

@implementation WeatherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // set the title
        self.title = @"My Locations";
        
        // init the alertBlock
        alertBlock = [[UserAlerts alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    // load up the defaults
    [self loadDefaults];
    
    if (firstRun)
    {
        alertBlock.makeShowAlert(@"TIP", @"Swipe left to remove locations. Swipe right to see weather details.", @"Ok", nil, YES, self, 0);
        
        [UserDefaults setItem:@"NO" forKey:@"WeatherViewController"];
        
        firstRun = NO;
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
         
         // close keyboard
         [locationsField resignFirstResponder];

         // add locations
         if (btn.tag == 0)
         {
             NSString *text = locationsField.text;
             
             if ([text length] == 5)
             {
                 // add the value to the locations array
                 if (locations)
                 {
                     // add to locations
                     [locations insertObject:text atIndex:[locations count]];
                 }
                 else
                 {
                     // init the locations
                     locations = [[NSMutableArray alloc] initWithObjects:text, nil];
                 }
                 
                 // reload the data with the new locations
                 [locationTable reloadData];
                 
                 // save the locations
                 [UserDefaults setItem:locations forKey:@"UserLocations"];
             }
             else
             {
                 // alert the user the field requirements
                 alertBlock.makeShowAlert(@"OOPS", @"Please enter a 5-digit U.S zip code.", @"OK", nil, YES, self, 0);
             }
         }
     }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // set the navbar tintColor
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:cellRed green:cellGreen blue:cellBlue alpha:1.0f];
    
    // set the view color
    self.view.backgroundColor = [UIColor colorWithRed:tableRed green:tableGreen blue:tableBlue alpha:1.0f];
    
    // set the headerLabel color
    headerLabel.backgroundColor = [UIColor colorWithRed:cellRed green:cellGreen blue:cellBlue alpha:(alphaValue/100.0f)];
    
    // set the table color
    locationTable.backgroundColor = [UIColor colorWithRed:tableRed green:tableGreen blue:tableBlue alpha:1.0f];
    
    return [locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"zipCell";
    
    CustomLocationCell *cell = [locationTable dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        NSArray *myBundle = [[NSBundle mainBundle] loadNibNamed:@"CustomLocationCell" owner:self options:nil];
        
        cell = (CustomLocationCell *) [myBundle objectAtIndex:0];
    }
    
    // set-up the cell text and color
    cell.zipText.text = [locations objectAtIndex:indexPath.row];
    
    // set-up the references
    cell.delegate = self;
    cell.tableViewReference = locationTable;
    cell.indexPathReference = indexPath;
    
    // set the color data
    locationTable.separatorColor = [UIColor colorWithRed:tableRed green:tableGreen blue:tableBlue alpha:1.0f];
    cell.zipText.font = [UIFont fontWithName:@"Optima" size:fontSize];
    cell.zipText.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    cell.removeText.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    cell.weatherText.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    cell.colorLabel.backgroundColor = [UIColor colorWithRed:cellRed green:cellGreen blue:cellBlue alpha:(alphaValue/100.0f)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    
    // load up the font size
    fontSize = (int) [UserDefaults getNumber:@"FontSize"];
    
    // reset the default font size
    if (fontSize <= 0)
    {
        fontSize = 17.0f;
    }
    
    // load up the first run data
    if ([[UserDefaults getItem:@"WeatherViewController"] isEqual:@"NO"])
    {
        firstRun = NO;
    }
    else
    {
        firstRun = YES;
    }
    
    // load up the opacity
    locations = [UserDefaults getItem:@"UserLocations"];
    
    // reset the default locations object
    if (!locations)
    {
        locations = nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)onSwipe:(NSIndexPath *)indexPath didSwipeLeft:(BOOL)leftSwipe
{
    // user swiped left
    if (leftSwipe)
    {
        CustomLocationCell *view = (CustomLocationCell *) [locationTable cellForRowAtIndexPath:indexPath];
        
        // do animation
        [UIView animateWithDuration:0.7f animations:^{
            
            view.frame = CGRectMake(-320.0f, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
            
        } completion:^(BOOL finished) {
            
            if (finished)
            {
                // remove the item from the locations array and the table
                [locations removeObjectAtIndex:indexPath.row];
                
                [locationTable reloadData];
                
                // save the updated locations
                [UserDefaults setItem:locations forKey:@"UserLocations"];
            }
        }];
    }
    else if (!leftSwipe)
    {
        // user swiped right
        
        // instantiate and present the detail view
        WeatherDetailsView *weatherDetails = [[WeatherDetailsView alloc] initWithNibName:@"WeatherDetailsView" bundle:nil];
        
        if (weatherDetails)
        {
            // pass in the currently selected zip for fetching weather
            weatherDetails.currentZip = [locations objectAtIndex:indexPath.row];
            
            [self.navigationController pushViewController:weatherDetails animated:YES];
        }
    }
}

@end
