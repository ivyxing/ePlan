//
//  Person.m
//  TaskTag
//
//  Created by Min Xing on 11/7/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "Person.h"
#import "Event.h"
#import "Task.h"

#define safeSet(d,k,v) if (v) d[k] = v;

@implementation Person

@dynamic fbProfilePictureID;
@dynamic firstName;
@dynamic isCurrentUser;
@dynamic name;
@dynamic taggedForEvent;
@dynamic taggedForTask;
@dynamic serverID;
@dynamic parentEvent;
@dynamic parentTask;

- (void) updateWithDictionary:(NSDictionary*)dictionary {
    self.fbProfilePictureID = dictionary[@"fbProfilePictureID"];
    self.firstName = dictionary[@"firstName"];
    self.isCurrentUser = dictionary[@"isCurrentUser"];
    self.name = dictionary[@"name"];
    self.taggedForEvent = dictionary[@"taggedForEvent"];
    self.taggedForTask = dictionary[@"taggedForTask"];
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* jsonable = [NSMutableDictionary dictionary];
    safeSet(jsonable, @"fbProfilePictureID", self.fbProfilePictureID);
    safeSet(jsonable, @"firstName", self.firstName);
    safeSet(jsonable, @"isCurrentUser", self.isCurrentUser);
    safeSet(jsonable, @"name", self.name);
    safeSet(jsonable, @"taggedForEvent", self.taggedForEvent);
    safeSet(jsonable, @"taggedForTask", self.taggedForTask);
    return jsonable;
}

@end
