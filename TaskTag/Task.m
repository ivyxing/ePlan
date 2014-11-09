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
    self.dueDate = [self.parentEvent convertStringToDate:dictionary[@"dueDate"]];
    self.name = dictionary[@"name"];
    self.timeStamp = [self.parentEvent convertStringToDate:dictionary[@"timeStamp"]];
    self.alert = dictionary[@"alert"];
    self.persons = [NSSet setWithArray:dictionary[@"persons"]];
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* jsonable = [NSMutableDictionary dictionary];
    safeSet(jsonable, @"dueDate", [self.parentEvent convertDateToString:self.dueDate]);
    safeSet(jsonable, @"name", self.name);
    safeSet(jsonable, @"timeStamp", [self.parentEvent convertDateToString:self.timeStamp]);
    safeSet(jsonable, @"alert", self.alert);
    safeSet(jsonable, @"persons", [self convertPersons]);
    return jsonable;
}

- (NSMutableArray *)convertPersons {
    NSMutableArray *personsDictionaryArray = [NSMutableArray array];
    for (Person *person in self.persons) {
        NSDictionary *personDictionary = [person toDictionary];
        [personsDictionaryArray addObject:personDictionary];
    }
    return personsDictionaryArray;
}

@end
