//
//  DataTypeConversion.m
//  TaskTag
//
//  Created by Min Xing on 11/11/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "DataTypeConversion.h"
#import "Person.h"
#import "Task.h"
#import "Event.h"

@implementation DataTypeConversion

#pragma mark - Task

+ (NSMutableArray *)tasksToDictionary:(NSSet *)tasksSet {
    NSMutableArray *tasksDictionaryArray = [NSMutableArray array];
    for (Task *task in tasksSet) {
        NSDictionary *taskDictionary = [task toDictionary];
        [tasksDictionaryArray addObject:taskDictionary];
    }
    return tasksDictionaryArray;
}

+ (NSArray*)tasksSetToSortedArray:(NSSet*)tasksSet {
    NSArray *tasksArray = [tasksSet allObjects];
    NSArray *sortedArray = [tasksArray sortedArrayUsingComparator:^NSComparisonResult(Task* a, Task* b) {
        return [a.timeStamp compare:b.timeStamp];
    }];
    return sortedArray;
}

#pragma mark - Person

+ (NSMutableArray *)extractPersonsServerIDs:(NSSet *)personsSet {
    NSMutableArray *personsServerIDsDictionaryArray = [NSMutableArray array];
    for (Person *person in personsSet) {
        [personsServerIDsDictionaryArray addObject:person.serverID];
    }
    return personsServerIDsDictionaryArray;
}

#pragma mark - Date

+ (NSString *)dateToString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [self standardizedShortStyleDateFormatter];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSDate *)stringToDate:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [self standardizedShortStyleDateFormatter];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    return date;
}

+ (NSDateFormatter *)standardizedShortStyleDateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    return dateFormatter;
}

@end
