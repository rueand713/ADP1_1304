//
//  UserSystem.m
//  BabbleOn
//
//  Created by Rueben Anderson on 5/2/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import "UserSystem.h"

@implementation UserSystem

- (id)init
{
    self = [super init];
    
    if (self)
    {
    
    }
    
    return self;
}

+ (void)saveDataToSystem:(NSString *)fileName fileData:(NSData *)data fileAttributes:(NSDictionary *)attributes
{
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path;
    
    if (directories)
    {
        // select the base directory
        path = (NSString *) [directories objectAtIndex:0];
        
        // create a full path object
        NSString *fullPath = [path stringByAppendingPathComponent:fileName];
        
        if (fullPath)
        {
            // create the file specified within the full path
            [[NSFileManager defaultManager] createFileAtPath:fullPath contents:data attributes:attributes];
        }
    }
}

+ (void)saveFileToSystem:(NSString *)fileName fileText:(NSString *)text fileAttributes:(NSDictionary *)attributes
{
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path;
    
    if (directories)
    {
        
        // select the base directory
        path = (NSString *) [directories objectAtIndex:0];
        
        // create a full path object
        NSString *fullPath = [path stringByAppendingPathComponent:fileName];
        
        BOOL yes = [[NSFileManager defaultManager] isWritableFileAtPath:fullPath];
        
        if (yes)
        {
            NSLog(@"YES");
        }
        
        NSLog(@"Save Path: %@", [fullPath description]);
        
        if (fullPath)
        {
            // create the file specified within the full path
            BOOL success = [text writeToFile:fullPath atomically:YES encoding:NSStringEncodingConversionAllowLossy error:nil];
            NSLog(@"%i", success);
        }
    }
}

+ (void)removeFileFromSystem:(NSString *)fileName
{
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path;
    
    if (directories)
    {
        // select the base directory
        path = (NSString *) [directories objectAtIndex:0];
        
        // create a full path object
        NSString *fullPath = [path stringByAppendingPathComponent:fileName];
        
        if (fullPath)
        {
            // create the file specified within the full path
            [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
        }
    }
}

+ (UIImage *)loadImageFromSystem:(NSString *)fileName
{
    // create a nil image object
    UIImage *image;
    
    NSArray *directory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path;
    
    if (directory)
    {
        // select the base directory
        path = (NSString *) [directory objectAtIndex:0];
        
        // create a full path object
        NSString *fullPath = [path stringByAppendingPathComponent:fileName];
        
        if (fullPath)
        {
            // verify that the file exists
            if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath])
            {
                // create the image from file on system
                image = [UIImage imageWithContentsOfFile:fullPath];
            }
        }
    }
    
    return image;
}

+ (NSString *)loadDocumentFromSystem:(NSString *)fileName
{
    // create a nil string object
    NSString *string;
    
    NSArray *directory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path;
    
    if (directory)
    {
        // select the base directory
        path = (NSString *) [directory objectAtIndex:0];
        
        // create a full path object
        NSString *fullPath = [path stringByAppendingPathComponent:fileName];
         NSLog(@"Load Path: %@", [fullPath description]);
        if (fullPath)
        {
            // verify that the file exists
            if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath])
            {
                // create the image from file on system
                string = [NSString stringWithContentsOfFile:fullPath encoding:NSStringEncodingConversionAllowLossy error:nil];
                NSLog(@"Load String: %@", [string description]);
            }
        }
    }
    
    return string;
}

+ (NSArray *)returnApplicationDirectories
{
    NSArray *directory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = (NSString *) [directory objectAtIndex:0];
    
    NSArray *directories = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    return directories;
}


@end
