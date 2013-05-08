//
//  CustomStepperCell.h
//  BabbleOn
//
//  Created by Rueben Anderson on 4/15/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomStepperCell : UITableViewCell
{
    // outlets
    IBOutlet UILabel *cellTitle;
    IBOutlet UILabel *stepVal;
    IBOutlet UIStepper *stepper;
    IBOutlet UIButton *saveBtn;
    
    // stepper data handler. since this object will be reused for multiple cells with steppers the stepperID will be set
    // to the NSIndexPath.row of the stepper parent cell
    int stepperID;
    
    // stepper value
    int stepperValue;
}

@property (nonatomic, strong) UILabel *cellTitle;
@property (nonatomic, strong) UILabel *stepVal;
@property (nonatomic, strong) UIStepper *stepper;
@property int stepperID;

- (IBAction)onChange:(id)sender;
-(IBAction)onClick:(id)sender;
@end
