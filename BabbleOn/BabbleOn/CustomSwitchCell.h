//
//  CustomSwitchCell.h
//  BabbleOn
//
//  Created by Rueben Anderson on 4/16/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSwitchCell : UITableViewCell
{
    IBOutlet UILabel *cellTitle;
    IBOutlet UISwitch *cellSwitch;
    
    int switchID;
}

@property int switchID;
@property (nonatomic, strong) UISwitch *cellSwitch;
@property (nonatomic, strong) UILabel *cellTitle;

- (IBAction)onClick:(id)sender;

@end
