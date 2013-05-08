//
//  UserSystem.h
//  BabbleOn
//
//  Created by Rueben Anderson on 5/2/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSystem : NSObject

+ (void)saveDataToSystem:(NSString *)fileName fileData:(NSData *)data fileAttributes:(NSDictionary *)attributes;
+ (void)saveFileToSystem:(NSString *)fileName fileText:(NSString *)text fileAttributes:(NSDictionary *)attributes;
+ (void)removeFileFromSystem:(NSString *)fileName;
+ (UIImage *)loadImageFromSystem:(NSString *)fileName;
+ (NSString *)loadDocumentFromSystem:(NSString *)fileName;
+ (NSArray *)returnApplicationDirectories;
@end
