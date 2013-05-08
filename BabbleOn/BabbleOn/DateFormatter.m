//
//  DateFormatter.m
//  BabbleOn
//
//  Created by Rueben Anderson on 4/18/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import "DateFormatter.h"

@implementation DateFormatter
@synthesize formatDate;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        // block that takes two parameters - an NSDate object an an NSString object. The NSDate parameter will be formatted
        // by NSDateFormatter to the format of the formatString parameter. The new date object will then be returned
        formatDate = ^(NSDate* thisDate, NSString *formatString)
        {
            NSDate *newDate = [[NSDate alloc] init];
            
            if (newDate && thisDate)
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                
                if (formatter)
                {
                    // set the date format
                    [formatter setDateFormat:formatString];
                    
                    // cast the return string to a date object
                    newDate = (NSDate*)[formatter stringFromDate:thisDate];
                }
            }
            
            return newDate;
        };
    }
    
    return self;
}

@end
