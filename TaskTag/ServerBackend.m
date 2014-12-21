//
//  Events.m
//  TaskTag
//
//  Created by Min Xing on 11/6/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "ServerBackend.h"
#import "DataTypeConversion.h"
#import "Event.h"
#import "Task.h"
#import "Person.h"
#import "AppDelegate.h"
#import "TaskDetailViewController.h"
#import "Message.h"

static NSString* const kBaseURL = @"https://tasktag.herokuapp.com/";
static NSString* const kEvents = @"events";
static NSString* const kTasks = @"tasks";
static NSString* const kPersons = @"persons";
static NSString* const kTaskCommentsTemp = @"commentsTemp";


@interface ServerBackend ()

@end

@implementation ServerBackend

+ (id)sharedServerBackend {
    static ServerBackend *sharedServerBackend = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedServerBackend = [[self alloc] init];
    });
    return sharedServerBackend;
}

// Pull all events from server.
- (void)import {
    NSURL* url = [NSURL URLWithString:[kBaseURL stringByAppendingString:kEvents]];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSArray* responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            [DataTypeConversion eventObjectSetFromEventsDictionaryArray:responseArray];
        }
    }];
    
    [dataTask resume];
}

// Push event to server.
- (void)persistEvent:(Event *)event {
    // Safety check.
    if (!event || event.title == nil || event.title.length == 0) {
        return;
    }
    
    NSString *eventsStr = [kBaseURL stringByAppendingPathComponent:kEvents];
    BOOL isExistingEvent = event.serverID != nil;
    NSURL* url = isExistingEvent ? [NSURL URLWithString:[eventsStr stringByAppendingPathComponent:event.serverID]] :
    [NSURL URLWithString:eventsStr];

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
            NSArray* responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            if (responseArray && responseArray.count > 0 && !event.serverID) {
                for (NSDictionary *jsonDictionary in responseArray) {
                    NSArray* tasksArray = jsonDictionary[@"tasks"];
                    for (Task *task in tasksArray) {
                        [self persistTask:task];
                    }
                    event.serverID = jsonDictionary[@"_id"];
                    NSLog(@"Event serverID: %@", event.serverID);
                    NSLog(@"Event title: %@", event.title);
                }
            }
        }
    }];
    
    [dataTask resume];
}

// Push task to the server.
- (void)persistTask:(Task *)task {
    if (!task || task.name == nil || task.name.length == 0) {
        return; //Safety check.
    }
    
    NSString *tasksStr = [kBaseURL stringByAppendingPathComponent:kTasks];
    BOOL isExistingTask = task.serverID != nil;
    NSURL* url = isExistingTask ? [NSURL URLWithString:[tasksStr stringByAppendingPathComponent:task.serverID]] :
    [NSURL URLWithString:tasksStr];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    request.HTTPMethod = isExistingTask ? @"PUT" : @"POST";
    
    // Convert dictionary to NSData.
    NSData* data = [NSJSONSerialization dataWithJSONObject:[task toDictionary] options:0 error:NULL];
    request.HTTPBody = data;
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSArray* responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            if (responseArray && !task.serverID) {
                for (NSDictionary *jsonDictionary in responseArray) {
                    task.serverID = jsonDictionary[@"_id"];
                    NSLog(@"Task serverID: %@", task.serverID);
                    NSLog(@"Task name: %@", task.name);
                }
            }
        }
    }];
    
    [dataTask resume];
}

#pragma mark - Messages

//- (void)sendCommentToServer:(NSDictionary*)dictionary {
//    NSURL* url = [NSURL URLWithString:[kBaseURL stringByAppendingString:kTaskCommentsTemp]];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
//    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setHTTPMethod:@"POST"];
//    
//    // Convert dictionary to NSData.
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
//    
//    [request setHTTPBody:jsonData];
//    
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config];
//    
//    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
//        NSInteger responseStatusCode = [httpResponse statusCode];
//        if (responseStatusCode == 200 && data) {
//            NSArray *downloadedJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//            [self addToArrayJSONDictionary:downloadedJSON];
//        } else {
//            // error handling
//        }
//    }];
//    
//    [dataTask resume];
//}

//- (void)getComments {
//    NSURL* url = [NSURL URLWithString:[kBaseURL stringByAppendingString:kTaskCommentsTemp]];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
//    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setHTTPMethod:@"GET"];
//    
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config];
//
//    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
//        NSInteger responseStatusCode = [httpResponse statusCode];
//        if (responseStatusCode == 200 && data) {
//            NSArray *downloadedJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//            // TODO: Replace this with Core Data.
//            [self addToArrayJSONDictionary:downloadedJSON];
//        } else {
//            // error handling
//        }
//    }];
//    
//    [dataTask resume];
//}

//- (void)addToArrayJSONDictionary:(NSArray *)msgArray {
//    for (NSDictionary *jsonMsg in msgArray) {
//        Message *msg = [Message messageWithJSONDictionary:jsonMsg];
//        [self.comments insertObject:msg atIndex:0];
//    }
//}

@end
