//
//  CustomSliderCell.m
//  BabbleOn
//
//  Created by Rueben Anderson on 4/15/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import "CustomSliderCell.h"
#import "UserDefaults.h"

typedef enum
{
    CELLCOLOR = 0,
    OVERLAYCOLOR,
    FONTCOLOR = 4
}sliderTypes;

typedef enum
{
    RED = 0,
    GREEN,
    BLUE
}colordefs;

@implementation CustomSliderCell
@synthesize cellTitle, sliderID, sliderLabel, sliderA, sliderB, sliderC;

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
    UISlider *slider = (UISlider *)sender;
    
    if (slider)
    {
        sliderRed = sliderA.value/255;
        sliderBlue = sliderC.value/255;
        sliderGreen = sliderB.value/255;
        
        // show the save button
        saveBtn.hidden = NO;
        
        // set the display label color for user viewing
        sliderLabel.backgroundColor = [UIColor colorWithRed:sliderRed green:sliderGreen blue:sliderBlue alpha:1.0f];
    }
}

- (IBAction)onClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if (btn)
    {
        // determine what stepper data is being saved
        if (sliderID == CELLCOLOR)
        {
            [UserDefaults setNumber:sliderRed forKey:@"CellRed"];
            [UserDefaults setNumber:sliderBlue forKey:@"CellBlue"];
            [UserDefaults setNumber:sliderGreen forKey:@"CellGreen"];

        }
        else if (sliderID == OVERLAYCOLOR)
        {
            [UserDefaults setNumber:sliderRed forKey:@"TableRed"];
            [UserDefaults setNumber:sliderBlue forKey:@"TableBlue"];
            [UserDefaults setNumber:sliderGreen forKey:@"TableGreen"];
        }
        else if (sliderID == FONTCOLOR)
        {
            [UserDefaults setNumber:sliderRed forKey:@"FontRed"];
            [UserDefaults setNumber:sliderBlue forKey:@"FontBlue"];
            [UserDefaults setNumber:sliderGreen forKey:@"FontGreen"];
        }
        
        // hide the save button
        saveBtn.hidden = YES;
    }
}

@end
