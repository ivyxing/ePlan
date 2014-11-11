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
    self.dueDate = [DataTypeConversion stringToDate:dictionary[@"dueDate"]];
    self.name = dictionary[@"name"];
    self.timeStamp = [DataTypeConversion stringToDate:dictionary[@"timeStamp"]];
    self.alert = dictionary[@"alert"];
    self.persons = [NSSet setWithArray:dictionary[@"persons"]];
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* jsonable = [NSMutableDictionary dictionary];
    safeSet(jsonable, @"dueDate", [DataTypeConversion dateToString:self.dueDate]);
    safeSet(jsonable, @"name", self.name);
    safeSet(jsonable, @"timeStamp", [DataTypeConversion dateToString:self.timeStamp]);
    safeSet(jsonable, @"alert", self.alert);
    safeSet(jsonable, @"persons", [DataTypeConversion extractPersonsServerIDs:self.persons]);
    return jsonable;
}

@end
