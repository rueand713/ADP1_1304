//
//  UserNotification.m
//  BabbleOn
//
//  Created by Rueben Anderson on 5/2/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import "UserNotification.h"

@implementation UserNotification
@synthesize notifcation;

- (id)init
{
    self = [super init];
    
    if (self)
    {

    }
    
    return self;
}

- (UILocalNotification *)createNotification:(NSString *)bodyText notificationAction:(NSString *)action notificationDate:(NSDate *)date notificationTimezone:(NSTimeZone *)timezone repeatInterval:(NSCalendarUnit *)repeat
{
    notification = [[UILocalNotification alloc] init];
    
    if (notification)
    {
        // check if an action text is supplied, if so set the hasAction to true
        if (action)
        {
            notification.hasAction = YES;
            notification.alertAction = action;
        }
        
        // set-up the notification body and firing date
        notification.alertBody = bodyText;
        notification.fireDate = date;
    }
    
    return notifcation;
}

+ (void)setupNotification:(NSString *)bodyText notificationAction:(NSString *)action notificationDate:(NSDate *)date notificationTimezone:(NSTimeZone *)timezone repeatInterval:(NSCalendarUnit *)repeat
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    if (notification)
    {
        // check if an action text is supplied, if so set the hasAction to true
        if (action)
        {
            notification.hasAction = YES;
            notification.alertAction = action;
        }
        
        // set-up the notification body and firing date
        notification.alertBody = bodyText;
        notification.fireDate = date;
        
        // schedule the notification
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

+ (void)startNotification:(UILocalNotification *)notification
{
    // schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

+ (void)cancelNotifications:(UILocalNotification *)notification
{
    if (!notification)
    {
        // no target notification supplied, cancel all notifications
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    else
    {
        // cancel only the supplied notification
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    }
}

@end
