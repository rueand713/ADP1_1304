//
//  CustomMainCell.h
//  BabbleOn
//
//  Created by Rueben Anderson on 4/15/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomMainCell : UITableViewCell
{
    IBOutlet UILabel *mediaText;
    IBOutlet UIImageView *cellImage;
    IBOutlet UILabel *cellColor;
    IBOutlet UILabel *description;
}

@property (nonatomic, strong) UILabel *mediaText;
@property (nonatomic, strong) UILabel *description;
@property (nonatomic, strong) UILabel *cellColor;
@property (strong) UIImageView *cellImage;

@end
