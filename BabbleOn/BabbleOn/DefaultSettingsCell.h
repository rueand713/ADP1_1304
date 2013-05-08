//
//  DefaultSettingsCell.h
//  BabbleOn
//
//  Created by Rueben Anderson on 4/25/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefaultSettingsCell : UITableViewCell
{
    IBOutlet UILabel *cellText;
    IBOutlet UIImageView *imageView;
    
    int cellID;
}

@property int cellID;
@property (nonatomic, strong) UILabel *cellText;
@property (nonatomic, strong) UIImageView *imageView;

@end
