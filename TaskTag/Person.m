//
//  Person.m
//  TaskTag
//
//  Created by Min Xing on 11/13/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "Person.h"
#import "Event.h"
#import "Task.h"
#import "DataTypeConversion.h"

#define safeSet(d,k,v) if (v) d[k] = v;

@implementation Person

@dynamic fbProfilePictureID;
@dynamic firstName;
@dynamic isCurrentUser;
@dynamic name;
@dynamic serverID;
@dynamic taggedForEvent;
@dynamic taggedForTask;
@dynamic parentEvents;
@dynamic parentTasks;

- (void) updateWithDictionary:(NSDictionary*)dictionary {
    self.fbProfilePictureID = dictionary[@"fbProfilePictureID"];
    self.firstName = dictionary[@"firstName"];
    self.isCurrentUser = dictionary[@"isCurrentUser"];
    self.name = dictionary[@"name"];
    self.taggedForEvent = dictionary[@"taggedForEvent"];
    self.taggedForTask = dictionary[@"taggedForTask"];
    [self addParentEvents:[DataTypeConversion eventObjectSetFromEventServerIDsArray:dictionary[@"parentEvents"]]];
    [self addParentTasks:[DataTypeConversion tasksObjectSetFromTasksServerIDsArray:dictionary[@"parentTasks"]]];
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* jsonable = [NSMutableDictionary dictionary];
    safeSet(jsonable, @"fbProfilePictureID", self.fbProfilePictureID);
    safeSet(jsonable, @"firstName", self.firstName);
    safeSet(jsonable, @"isCurrentUser", self.isCurrentUser);
    safeSet(jsonable, @"name", self.name);
    safeSet(jsonable, @"taggedForEvent", self.taggedForEvent);
    safeSet(jsonable, @"taggedForTask", self.taggedForTask);
    safeSet(jsonable, @"parentEvents", [DataTypeConversion eventsServerIDsArrayFromEventsObjectSet:self.parentEvents]);
    safeSet(jsonable, @"parentTasks", [DataTypeConversion tasksServerIDsArrayFromTasksObjectSet:self.parentTasks]);
    return jsonable;
}

@end