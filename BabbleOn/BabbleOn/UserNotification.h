//
//  UserNotification.h
//  BabbleOn
//
//  Created by Rueben Anderson on 5/2/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserNotification : NSObject
{
    UILocalNotification *notification;
}
@property (nonatomic, strong) UILocalNotification *notifcation;

- (id)init;
+ (void)setupNotification:(NSString *)bodyText notificationAction:(NSString *)action notificationDate:(NSDate *)date notificationTimezone:(NSTimeZone *)timezone repeatInterval:(NSCalendarUnit *)repeat;
+ (void)startNotification:(UILocalNotification *)notification;
+ (void)cancelNotifications:(UILocalNotification *)notification;

@end
