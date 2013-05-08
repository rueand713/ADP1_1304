//
//  CFREST.h
//  RESTful_iOS
//
//  Created by Rueben Anderson on 4/27/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFREST : NSObject
{
    CFStringRef bodyString;
    CFStringRef headerFieldName;
    CFStringRef headerFieldValue;
    CFStringRef urlString;
    CFStringRef requestMethod;
    
    CFURLRef URL;
    
    CFHTTPMessageRef request;
    CFHTTPMessageRef response;
    CFHTTPMessageRef mResponse;
    
    CFDataRef bodyData;
    CFDataRef extBodyData;
    CFDataRef serializedData;
}

-(void)HTTPResponseMethodCreate:(NSDictionary *)httpRequestObject;
-(void)HTTPRequestMethodCreate:(NSDictionary *)httpRequestObject;

@end
