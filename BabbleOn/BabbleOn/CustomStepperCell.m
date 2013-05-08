//
//  CustomStepperCell.m
//  BabbleOn
//
//  Created by Rueben Anderson on 4/15/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import "CustomStepperCell.h"
#import "UserDefaults.h"

typedef enum
{
    OVERLAYOPACITY = 2,
    FONTSIZE
}stepperTypes;

@implementation CustomStepperCell

@synthesize cellTitle, stepVal, stepperID, stepper;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onChange:(id)sender
{
    UIStepper *stepperIB = (UIStepper *)sender;
    
    if (stepperIB)
    {
        // set the stepper value
        stepperValue = stepperIB.value;
        
        // determine where slider data is to be saved
        if (stepperID == OVERLAYOPACITY)
        {
            // reveal the save button
            saveBtn.hidden = NO;
            
            // set the stepper opacity text
            stepVal.text = [NSString stringWithFormat:@"%i%%", stepperValue];
        }
        else if (stepperID == FONTSIZE)
        {
            // reveal the save button
            saveBtn.hidden = NO;
            
            // set the stepper font text
            stepVal.text = [NSString stringWithFormat:@"%ipt", stepperValue];
        }
    }
}

-(IBAction)onClick:(id)sender
{
    UIButton *button = (UIButton *) sender;
    
    if (button)
    {
        // determine where slider data is to be saved
        if (stepperID == OVERLAYOPACITY)
        {
            // hide the save button
            saveBtn.hidden = YES;
            
            [UserDefaults setNumber:stepperValue forKey:@"AlphaValue"];
        }
        else if (stepperID == FONTSIZE)
        {
            // hide the save button
            saveBtn.hidden = YES;
            
            [UserDefaults setNumber:stepperValue forKey:@"FontSize"];
        }
    }
}

@end
