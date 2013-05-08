//
//  AppDelegate.m
//  BabbleOn
//
//  Created by Rueben Anderson on 4/8/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import "AppDelegate.h"

#import "FirstViewController.h"

#import "SecondViewController.h"

#import "UserNotification.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    FirstViewController *viewController1 = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    SecondViewController *viewController2 = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
    
    // set up the navigation controllers for the tabbed views
    UINavigationController *navControl1 = [[UINavigationController alloc] initWithRootViewController:viewController1];
    UINavigationController *navControl2 = [[UINavigationController alloc] initWithRootViewController:viewController2];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    if (accountStore != nil)
    {
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        if (accountType != nil)
        {
            [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
                
                if (granted)
                {
                    NSArray *twitterAccounts = [accountStore accountsWithAccountType:accountType];
                    
                    // temp array of twitter usernames
                    NSMutableArray *twitterUsernames = nil;
                    
                    if (twitterAccounts)
                    {
                        for (int i = 0; i < [twitterAccounts count]; i++)
                        {
                            ACAccount *thisAccount = [twitterAccounts objectAtIndex:i];
                            
                            if (thisAccount)
                            {
                                
                                if (twitterUsernames != nil)
                                {
                                    NSString *username = thisAccount.username;
                                
                                    // insert the account username in the twitterUsernames array
                                    [twitterUsernames insertObject:username atIndex:[twitterUsernames count]];
                                }
                                else
                                {
                                    NSString *username = thisAccount.username;
                                
                                    // initialize the twitterUsernames array with its first object
                                    twitterUsernames = [[NSMutableArray alloc] initWithObjects:username, nil];
                                }
                            }
                        }
                    }
                    
                    // pass in the twitter account data
                    viewController1.twitterAccounts = twitterAccounts;
                    viewController2.twitterAccounts = twitterUsernames;
                }
            }];
        }
    }

    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[navControl1, navControl2];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // create a date 10 seconds from now
    NSDate *targetDate = [[NSDate alloc] initWithTimeIntervalSinceNow:30];
    
    // create a notification
    [UserNotification setupNotification:@"Don't be gone too long or you will miss out on all of the action!" notificationAction:nil notificationDate:targetDate notificationTimezone:[NSTimeZone localTimeZone] repeatInterval:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // cancel the notifications
    [UserNotification cancelNotifications:nil];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
