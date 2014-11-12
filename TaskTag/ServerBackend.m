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
#import "AppDelegate.h"

static NSString* const kBaseURL = @"https://tasktag.herokuapp.com/";
static NSString* const kEvents = @"events";
static NSString* const kPersons = @"persons";

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
            [self parseAndAddEvents:responseArray];
        }
    }];
    
    [dataTask resume];
}

// Push event to server.
- (void)persistEvent:(Event *)event {
    if (!event || event.title == nil || event.title.length == 0) {
        return; //input safety check
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
            //TODO: Assign serverID here - is this right??
            if (responseArray) {
                for (NSDictionary *jsonDictionary in responseArray) {
                    event.serverID = jsonDictionary[@"id"];
                    NSLog(@"Event serverID: %@", event.serverID);
                    NSLog(@"Event title: %@", event.title);
                }
            }
        }
    }];
    
    [dataTask resume];
}

// Parse json dictionary into events objects.
- (void)parseAndAddEvents:(NSArray *)jsonEventsArray {
    // Get access to the managed object context.
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    // Create a new object using the entity description.
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
//    request setPredicate:<#(NSPredicate *)#>
    
    // Create an error variable to pass to the execute method.
    NSError *error;
    // Retrieve results.
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (array == nil) {
        // Error handling, e.g. display error to user.
    }
    
    // Parsing events - either update an existing event or create a new event.
    for (NSDictionary *jsonEventDictionary in jsonEventsArray) {
        Event *event;
        BOOL matchesExistingEvent = NO;
        for (Event *existingEvent in array) {
            if ([[existingEvent valueForKey:@"serverID"] isEqualToString:jsonEventDictionary[@"serverID"]]) {
                event = existingEvent;
                matchesExistingEvent = YES;
                NSLog(@"Existing Event");
            }
        }
        if (!matchesExistingEvent) {
            // Create new event.
            event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
            NSLog(@"New Event");
        }
        [event updateWithDictionary:jsonEventDictionary];
        NSLog(@"Pulling from server - event: %@", event.title);
    }
}

@end
