//
//  Event.m
//  TaskTag
//
//  Created by Min Xing on 11/7/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "Event.h"
#import "Person.h"
#import "Task.h"
#import "DataTypeConversion.h"

#define safeSet(d,k,v) if (v) d[k] = v;

@implementation Event

@dynamic endTime;
@dynamic location;
@dynamic startTime;
@dynamic summary;
@dynamic title;
@dynamic serverID;
@dynamic persons;
@dynamic tasks;

- (void) updateWithDictionary:(NSDictionary*)dictionary {
    self.endTime = [DataTypeConversion stringToDate:dictionary[@"endTime"]];
    self.location = dictionary[@"location"];
    self.startTime = [DataTypeConversion stringToDate:dictionary[@"startTime"]];
    self.summary = dictionary[@"summary"];
    self.title = dictionary[@"title"];
    //TODO: Fix add persons
    [self addPersons:[DataTypeConversion personsObjectSetFromPersonsServerIDsArray:dictionary[@"persons"]]];
//    [self addTasks:[DataTypeConversion tasksObjectSetFromTasksDictionaryArray:dictionary[@"tasks"]]];
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* jsonable = [NSMutableDictionary dictionary];
    safeSet(jsonable, @"startTime", [DataTypeConversion dateToString:self.startTime]);
    safeSet(jsonable, @"endTime", [DataTypeConversion dateToString:self.endTime]);
    safeSet(jsonable, @"location", self.location);
    safeSet(jsonable, @"summary", self.summary);
    safeSet(jsonable, @"title", self.title);
    safeSet(jsonable, @"persons", [DataTypeConversion personsServerIDsArrayFromPersonsObjectSet:self.persons]);
//    safeSet(jsonable, @"tasks", [DataTypeConversion tasksDictionaryArrayFromTasksObjectSet:self.tasks]);
    return jsonable;
}

@end
