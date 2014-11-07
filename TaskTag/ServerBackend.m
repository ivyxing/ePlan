//
//  Events.m
//  TaskTag
//
//  Created by Min Xing on 11/6/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "ServerBackend.h"
#import "Event.h"
#import "Task.h"
#import "Person.h"

static NSString* const kBaseURL = @"http://polar-refuge-5597.herokuapp.com/";
static NSString* const kEvents = @"events";

@interface ServerBackend ()

@end

@implementation ServerBackend

- (void)import {
    NSURL* url = [NSURL URLWithString:[kBaseURL stringByAppendingPathComponent:kEvents]];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSArray* responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            self.serverEvents = responseArray;
        }
    }];
    
    [dataTask resume];
}

- (void)persistEvent:(Event *)event {
    if (!event || event.title == nil || event.title.length == 0) {
        return; //input safety check
    }
    NSString *events = [kBaseURL stringByAppendingPathComponent:kEvents];
    BOOL isExistingEvent = event.serverID != nil;
    NSURL* url = isExistingEvent ? [NSURL URLWithString:[events stringByAppendingPathComponent:event.serverID]] :
    [NSURL URLWithString:events];

    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    request.HTTPMethod = isExistingEvent ? @"PUT" : @"POST";

    // Convert dictionary to NSData.
    NSData* data = [NSJSONSerialization dataWithJSONObject:[event toDictionary] options:0 error:NULL];
    request.HTTPBody = data;
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];

    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSArray* responseArray = @[[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]];
            self.serverEvents = responseArray;
        }
    }];
    
    [dataTask resume];
}

@end
