//
//  CustomTweetCell.h
//  BabbleOn
//
//  Created by Rueben Anderson on 4/24/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTweetCell : UITableViewCell
{
    IBOutlet UILabel *tweetLabel;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *cellColor;
}

@property (nonatomic, strong) UILabel *tweetLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *cellColor;

@end
