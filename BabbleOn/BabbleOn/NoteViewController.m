//
//  NoteViewController.m
//  BabbleOn
//
//  Created by Rueben Anderson on 5/2/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import "NoteViewController.h"

@interface NoteViewController ()

@end

@implementation NoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"Babble Notes";
        
        // init the alert class
        alertBlock = [[UserAlerts alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    // load the files
    [self loadFiles];
    
    // load defaults
    [self loadDefaults];
    
    colorLabel.backgroundColor = [UIColor colorWithRed:cellRed green:cellGreen blue:cellBlue alpha:(alphaValue/100.0f)];
    fileName.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    noteText.textColor = [UIColor colorWithRed:fontRed green:fontGreen blue:fontBlue alpha:1.0f];
    noteText.backgroundColor = [UIColor colorWithRed:tableRed green:tableGreen blue:tableBlue alpha:1.0f];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:cellRed green:cellGreen blue:cellBlue alpha:1.0f];
    self.view.backgroundColor = [UIColor colorWithRed:tableRed green:tableGreen blue:tableBlue alpha:1.0f];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [notesArray count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"cell";
    
    UITableViewCell *cell = [fileTable dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    // set the cell text
    cell.textLabel.text = [notesArray objectAtIndex: indexPath.row];

    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)onClick:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    
    if (btn.tag == 0)
    {
        if (![fileName.text isEqualToString:@""])
        {
            // save the note
            [UserSystem saveFileToSystem:fileName.text fileText:noteText.text fileAttributes:nil];
            
            // load the files
            [self loadFiles];
        }
    }
    else if (btn.tag == 1)
    {
        if (![fileName.text isEqualToString:@""])
        {
            // delete the note
            [UserSystem removeFileFromSystem:currentFile];
            
            // load the files
            [self loadFiles];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get the current cell title
    currentFile = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
    // load the selected note and the title into proper fields
    noteText.text = [UserSystem loadDocumentFromSystem:currentFile];
    fileName.text = currentFile;
}

- (void)loadFiles
{
    // get the list of files from the directory
    notesArray = [UserSystem returnApplicationDirectories];
    
    // reload the table
    [fileTable reloadData];
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
