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
    self.startTime = [self convertStringToDate:dictionary[@"startTime"]];
    self.endTime = [self convertStringToDate:dictionary[@"endTime"]];
    self.location = dictionary[@"location"];
    self.summary = dictionary[@"summary"];
    self.title = dictionary[@"title"];
    self.persons = [NSSet setWithArray:dictionary[@"persons"]];
    self.tasks = [NSSet setWithArray:dictionary[@"tasks"]];
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* jsonable = [NSMutableDictionary dictionary];
    safeSet(jsonable, @"startTime", [self convertDateToString:self.startTime]);
    safeSet(jsonable, @"endTime", [self convertDateToString:self.endTime]);
    safeSet(jsonable, @"location", self.location);
    safeSet(jsonable, @"summary", self.summary);
    safeSet(jsonable, @"title", self.title);
    safeSet(jsonable, @"persons", [self convertPersons]);
    safeSet(jsonable, @"tasks", [self convertTasks]);
    return jsonable;
}

- (NSMutableArray *)convertTasks {
    NSMutableArray *tasksDictionaryArray = [NSMutableArray array];
    for (Task *task in self.tasks) {
        NSDictionary *taskDictionary = [task toDictionary];
        [tasksDictionaryArray addObject:taskDictionary];
    }
    return tasksDictionaryArray;
}

- (NSMutableArray *)convertPersons {
    NSMutableArray *personsDictionaryArray = [NSMutableArray array];
    for (Person *person in self.persons) {
        NSDictionary *personDictionary = [person toDictionary];
        [personsDictionaryArray addObject:personDictionary];
    }
    return personsDictionaryArray;
}

- (NSString *)convertDateToString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [self standardizedDateFormatter];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

- (NSDate *)convertStringToDate:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [self standardizedDateFormatter];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    return date;
}

- (NSDateFormatter *)standardizedDateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    return dateFormatter;
}

@end
