//
//  DateFormatter.h
//  BabbleOn
//
//  Created by Rueben Anderson on 4/18/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateFormatter : NSObject
{
    NSDate* (^formatDate)(NSDate*, NSString*);
}

@property (nonatomic, strong) NSDate* (^formatDate)(NSDate*, NSString*);

@end
