//
//  CustomSliderCell.h
//  BabbleOn
//
//  Created by Rueben Anderson on 4/15/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSliderCell : UITableViewCell
{
    IBOutlet UILabel *cellTitle;
    IBOutlet UILabel *sliderLabel;
    IBOutlet UISlider *sliderA;
    IBOutlet UISlider *sliderB;
    IBOutlet UISlider *sliderC;
    IBOutlet UIButton *saveBtn;
    
    int sliderID;
    float sliderRed;
    float sliderBlue;
    float sliderGreen;
}

@property (nonatomic, strong) UILabel *cellTitle;
@property (nonatomic, strong) UILabel *sliderLabel;
@property int sliderID;
@property (nonatomic, strong) UISlider *sliderA;
@property (nonatomic, strong) UISlider *sliderB;
@property (nonatomic, strong) UISlider *sliderC;

- (IBAction)onChange:(id)sender;
- (IBAction)onClick:(id)sender;
@end
