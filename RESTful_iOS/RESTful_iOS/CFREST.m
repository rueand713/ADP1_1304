//
//  CFREST.m
//  RESTful_iOS
//
//  Created by Rueben Anderson on 4/27/13.
//  Copyright (c) 2013 Rueben Anderson. All rights reserved.
//

#import "CFREST.h"

@implementation CFREST

- (id)init
{
    self = [super init];
    
    if (self)
    {
        // init code
    }
    
    return self;
}

-(void)HTTPRequestMethodCreate:(NSDictionary *)httpRequestObject
{
    // extract http request data
    NSString *urlLink = [httpRequestObject objectForKey:@"url"];
    NSString *method = [httpRequestObject objectForKey:@"method"];
    NSString *body = [httpRequestObject objectForKey:@"body"];
    NSString *headerName = [httpRequestObject objectForKey:@"headerName"];
    NSString *headerValue = [httpRequestObject objectForKey:@"headerValue"];
    
    // convert NSString objects to c-strings
    const char *cUrl = [urlLink cStringUsingEncoding:kCFStringEncodingUTF8];
    const char *cMethod = [method cStringUsingEncoding:kCFStringEncodingUTF8];
    const char *cBody = [body cStringUsingEncoding:kCFStringEncodingUTF8];
    const char *cHeaderName = [headerName cStringUsingEncoding:kCFStringEncodingUTF8];
    const char *cHeaderValue = [headerValue cStringUsingEncoding:kCFStringEncodingUTF8];

    
    // setup the header
    headerFieldName = CFStringCreateWithCString(kCFAllocatorDefault, cHeaderName, kCFStringEncodingUTF8);
    headerFieldValue = CFStringCreateWithCString(kCFAllocatorDefault, cHeaderValue, kCFStringEncodingUTF8);
    
    // setup the body
    bodyString = CFStringCreateWithCString(kCFAllocatorDefault, cBody, kCFStringEncodingUTF8);
    bodyData = CFStringCreateExternalRepresentation(kCFAllocatorDefault, bodyString, kCFStringEncodingUTF8, 0);
    
    // setup the url
    urlString = CFStringCreateWithCString(kCFAllocatorDefault, cUrl, kCFStringEncodingUTF8);
    URL = CFURLCreateWithString(kCFAllocatorDefault, urlString, NULL);
    
    // setup the request method
    requestMethod = CFStringCreateWithCString(kCFAllocatorDefault, cMethod, kCFStringEncodingUTF8);
    request = CFHTTPMessageCreateRequest(kCFAllocatorDefault, requestMethod, URL, kCFHTTPVersion1_1);
    
    // setup request
    CFHTTPMessageSetBody(request, bodyData);
    CFHTTPMessageSetHeaderFieldValue(request, headerFieldName, headerFieldValue);
    serializedData = CFHTTPMessageCopySerializedMessage(request);
    
    // create the response
    [self HTTPResponseMethodCreate:httpRequestObject];
}

-(void)HTTPResponseMethodCreate:(NSDictionary *)httpRequestObject
{
    // extract http request data
    NSString *urlLink = [httpRequestObject objectForKey:@"url"];
    NSString *method = [httpRequestObject objectForKey:@"method"];
    NSString *body = [httpRequestObject objectForKey:@"body"];
    NSString *headerName = [httpRequestObject objectForKey:@"headerName"];
    NSString *headerValue = [httpRequestObject objectForKey:@"headerValue"];
    
    // convert NSString objects to c-strings
    const char *cUrl = [urlLink cStringUsingEncoding:kCFStringEncodingUTF8];
    const char *cMethod = [method cStringUsingEncoding:kCFStringEncodingUTF8];
    const char *cBody = [body cStringUsingEncoding:kCFStringEncodingUTF8];
    const char *cHeaderName = [headerName cStringUsingEncoding:kCFStringEncodingUTF8];
    const char *cHeaderValue = [headerValue cStringUsingEncoding:kCFStringEncodingUTF8];
    
    
    // setup the header
    headerFieldName = CFStringCreateWithCString(kCFAllocatorDefault, cHeaderName, kCFStringEncodingUTF8);
    headerFieldValue = CFStringCreateWithCString(kCFAllocatorDefault, cHeaderValue, kCFStringEncodingUTF8);
    
    // setup the body
    bodyString = CFStringCreateWithCString(kCFAllocatorDefault, cBody, kCFStringEncodingUTF8);
    bodyData = CFStringCreateExternalRepresentation(kCFAllocatorDefault, bodyString, kCFStringEncodingUTF8, 0);
    
    // setup the url
    urlString = CFStringCreateWithCString(kCFAllocatorDefault, cUrl, kCFStringEncodingUTF8);
    URL = CFURLCreateWithString(kCFAllocatorDefault, urlString, NULL);
    
    // setup the request method
    requestMethod = CFStringCreateWithCString(kCFAllocatorDefault, cMethod, kCFStringEncodingUTF8);
    response = CFHTTPMessageCreateResponse(kCFAllocatorDefault, 200, NULL, kCFHTTPVersion1_1);
    
    // setup request
    CFHTTPMessageSetBody(response, bodyData);
    CFHTTPMessageSetHeaderFieldValue(response, headerFieldName, headerFieldValue);
    serializedData = CFHTTPMessageCopySerializedMessage(response);
}

/*- (void)k
{
    mResponse = CFHTTPMessageCreateEmpty(kCFAllocatorDefault, TRUE);
    
    if (!CFHTTPMessageAppendBytes(response, numBytes)) {
        
        //Handle parsing error
        
    }
    else if ()
    {
        
    }
}*/

@end
