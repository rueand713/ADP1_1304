//
//  CustomLocationCell.h
//  BabbleOn
//
//  Created by Rueben Anderson on 4/30/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol swipeTrigger <NSObject>

@required
- (void)onSwipe:(NSIndexPath *)indexPath didSwipeLeft:(BOOL)leftSwipe;

@end

@interface CustomLocationCell : UITableViewCell <UIAlertViewDelegate>
{
    IBOutlet UILabel *colorLabel;
    IBOutlet UILabel *zipText;
    IBOutlet UILabel *weatherText;
    IBOutlet UILabel *removeText;
    
    UISwipeGestureRecognizer *swipeLeft;
    UISwipeGestureRecognizer *swipeRight;
    
    UITableView *tableViewReference;
    NSIndexPath *indexPathReference;
    
    id<swipeTrigger> delegate;
}

@property (nonatomic, strong) UILabel *zipText;
@property (nonatomic, strong) UILabel *removeText;
@property (nonatomic, strong) UILabel *weatherText;
@property (nonatomic, strong) UILabel *colorLabel;
@property (nonatomic, strong) UITableView *tableViewReference;
@property (nonatomic, strong) NSIndexPath *indexPathReference;
@property (nonatomic, strong) id<swipeTrigger> delegate;

- (IBAction)onSwipe:(UISwipeGestureRecognizer *)recognizer;

@end
