//
//  Task.m
//  TaskTag
//
//  Created by Min Xing on 11/7/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "Task.h"
#import "Event.h"
#import "Person.h"
#import "DataTypeConversion.h"

#define safeSet(d,k,v) if (v) d[k] = v;

@implementation Task

@dynamic alert;
@dynamic dueDate;
@dynamic name;
@dynamic timeStamp;
@dynamic commentsArray;
@dynamic serverID;
@dynamic parentEvent;
@dynamic persons;

- (void) updateWithDictionary:(NSDictionary*)dictionary {
    self.alert = dictionary[@"alert"];
    self.dueDate = [DataTypeConversion stringToDate:dictionary[@"dueDate"]];
    self.name = dictionary[@"name"];
    self.timeStamp = [DataTypeConversion stringToDate:dictionary[@"timeStamp"]];
    NSString *parentEventServerID = [dictionary[@"parentEvent"] valueForKey:@"serverID"];
    self.parentEvent = [DataTypeConversion eventObjectFromEventServerID:parentEventServerID update:dictionary[@"parentEvent"]];
    [self addPersons:[DataTypeConversion personsObjectSetFromPersonsServerIDsArray:dictionary[@"persons"]]];
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* jsonable = [NSMutableDictionary dictionary];
    safeSet(jsonable, @"alert", self.alert);
    safeSet(jsonable, @"dueDate", [DataTypeConversion dateToString:self.dueDate]);
    safeSet(jsonable, @"name", self.name);
    safeSet(jsonable, @"timeStamp", [DataTypeConversion dateToString:self.timeStamp]);
    safeSet(jsonable, @"parentEvent", [self.parentEvent toDictionary]);
    safeSet(jsonable, @"persons", [DataTypeConversion personsServerIDsArrayFromPersonsObjectSet:self.persons]);
    return jsonable;
}

@end
