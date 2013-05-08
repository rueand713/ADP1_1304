//
//  TwitterSetupView.m
//  BabbleOn
//
//  Created by Rueben Anderson on 4/25/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import "TwitterSetupView.h"
#import "CustomMainCell.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@implementation TwitterSetupView
@synthesize twitterAccounts;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // set the title
        self.title = @"Twitter Accounts";

        alertBlock = [[UserAlerts alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    // load defaults
    [self loadDefaults];
    
    if (firstRun)
    {
        alertBlock.makeShowAlert(@"TIP", @"To make use of Twitter functionality please select your default account. You can come back and change this anytime!", @"Ok", nil, YES, self, 0);
        
        [UserDefaults setItem:@"NO" forKey:@"TwitterSetupView"];
        
        firstRun = NO;
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    // reload the table
    [accountTable reloadData];
    
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // load defaults
    [self loadDefaults];
    
    // set the table, view and navbar colors
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:cellRed green:cellGreen blue:cellBlue alpha:1.0f];
    self.view.backgroundColor = [UIColor colorWithRed:tableRed green:tableGreen blue:tableBlue alpha:1.0f];
    accountTable.backgroundColor = [UIColor colorWithRed:tableRed green:tableGreen blue:tableBlue alpha:1.0f];
    accountTable.separatorColor = [UIColor colorWithRed:tableRed green:tableGreen blue:tableBlue alpha:1.0f];
    
    // determine how many rows to create
    if (twitterAccounts)
    {
        return [twitterAccounts count];
    }
    else
    {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // set the account name
    NSString *accountName = [twitterAccounts objectAtIndex:indexPath.row];
    
    // save the current selection and pop back to the root
    [UserDefaults setItem:accountName forKey:@"TwitterAccount"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"cell";
    
    CustomMainCell *cell = [accountTable dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        NSArray *myBundle = [[NSBundle mainBundle] loadNibNamed:@"CustomMainCell" owner:self options:nil];
        
        cell = (CustomMainCell *) [myBundle objectAtIndex:0];
    }
    
    cell.mediaText.text = [twitterAccounts objectAtIndex:indexPath.row];
    cell.description.text = @"A Twitter Account";
    cell.cellImage.image = [UIImage imageNamed:@"twitbird.png"];
    
    // set the color data
    cell.mediaText.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    cell.description.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    cell.cellColor.backgroundColor = [UIColor colorWithRed:cellRed green:cellGreen blue:cellBlue alpha:(alphaValue/100.0f)];
    
    // set the font size of the main label
    cell.mediaText.font = [UIFont fontWithName:@"Optima" size:fontSize];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Choose an Account";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
    if ([[UserDefaults getItem:@"TwitterSetupView"] isEqual:@"NO"])
    {
        firstRun = NO;
    }
    else
    {
        firstRun = YES;
    }
}

@end
