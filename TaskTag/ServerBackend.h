//
//  Events.h
//  TaskTag
//
//  Created by Min Xing on 11/6/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Event;

@interface ServerBackend : NSObject

@property (strong, nonatomic) NSArray *serverEvents;

- (void) import;
- (void) persistEvent:(Event *)event;

@end


