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
#import "AppDelegate.h"

@implementation DataTypeConversion

#pragma mark - Event

+ (Event *)eventObjectFromEventServerID:(NSString *)eventServerID {
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Event.serverID like %@", eventServerID];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    return (array == nil) ? nil : array[0];
}

+ (NSSet *)eventObjectSetFromEventServerIDsArray:(NSArray *)eventServerIDs {
    NSMutableSet *eventsObjectSet = [NSMutableSet set];
    for (NSString *eventServerID in eventServerIDs) {
        [eventsObjectSet addObject:[self eventObjectFromEventServerID:eventServerID]];
    }
    return eventsObjectSet;
}

+ (NSArray *)eventsServerIDsArrayFromEventsObjectSet:(NSSet *)eventsSet {
    NSMutableArray *eventsServerIDsArray = [NSMutableArray array];
    for (Event * event in eventsSet) {
        [eventsServerIDsArray addObject:event.serverID];
    }
    return eventsServerIDsArray;
}

#pragma mark - Task

+ (NSArray *)tasksObjectSortedArrayFromTasksObjectSet:(NSSet*)tasksSet {
    NSArray *tasksArray = [tasksSet allObjects];
    NSArray *sortedArray = [tasksArray sortedArrayUsingComparator:^NSComparisonResult(Task* a, Task* b) {
        return [a.timeStamp compare:b.timeStamp];
    }];
    return sortedArray;
}

+ (NSArray *)tasksDictionaryArrayFromTasksObjectSet:(NSSet *)tasksSet {
    NSMutableArray *tasksDictionaryArray = [NSMutableArray array];
    for (Task *task in tasksSet) {
        NSDictionary *taskDictionary = [task toDictionary];
        [tasksDictionaryArray addObject:taskDictionary];
    }
    return tasksDictionaryArray;
}

+ (NSArray *)tasksServerIDsArrayFromTasksObjectSet:(NSSet *)tasksSet {
    NSMutableArray *tasksServerIDsArray = [NSMutableArray array];
    for (Task *task in tasksSet) {
        [tasksServerIDsArray addObject:task.serverID];
    }
    return tasksServerIDsArray;
}

+ (Task *)taskObjectFromTaskServerID:(NSString *)taskServerID {
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Task.serverID like %@", taskServerID];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    return (array == nil) ? nil : array[0];
}

+ (NSSet *)tasksObjectSetFromTasksServerIDsArray:(NSArray *)tasksServerIDsArray {
    NSMutableSet *tasksObjectSet = [NSMutableSet set];
    for (NSString *taskServerID in tasksServerIDsArray) {
        [tasksObjectSet addObject:[self taskObjectFromTaskServerID:taskServerID]];
    }
    return tasksObjectSet;
}

+ (NSSet *)tasksObjectSetFromTasksDictionaryArray:(NSArray *)tasksDictionaryArray {
    NSMutableSet *tasksObjectSet = [NSMutableSet set];
    for (NSDictionary *taskDictionary in tasksDictionaryArray) {
        Task *task = [[Task alloc] init];
        task.alert = taskDictionary[@"alert"];
        task.dueDate = taskDictionary[@"dueDate"];
        task.name = taskDictionary[@"name"];
        task.timeStamp = taskDictionary[@"timeStamp"];
        task.commentsArray = taskDictionary[@"commentsArray"];
        task.serverID = taskDictionary[@"serverID"];
        task.parentEvent.serverID = taskDictionary[@"parentEventServerID"];
        task.persons = [self personsObjectSetFromPersonsServerIDsArray:taskDictionary[@"personsServerIDs"]];
        [tasksObjectSet addObject:task];
    }
    return tasksObjectSet;
}

#pragma mark - Person

+ (NSArray *)personsServerIDsArrayFromPersonsObjectSet:(NSSet *)personsSet {
    NSMutableArray *personsServerIDsArray = [NSMutableArray array];
    for (Person *person in personsSet) {
        if (person.serverID) {
            [personsServerIDsArray addObject:person.serverID];
        }
    }
    return personsServerIDsArray;
}

+ (Person *)personObjectFromPersonServerID:(NSString *)personServerID {
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Person.serverID like %@", personServerID];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    return (array == nil) ? nil : array[0];
}

+ (NSSet *)personsObjectSetFromPersonsServerIDsArray:(NSArray *)personsServerIDsArray {
    NSMutableSet *personsObjectSet = [NSMutableSet set];
    for (NSString *personServerID in personsServerIDsArray) {
        [personsObjectSet addObject:[self personObjectFromPersonServerID:personServerID]];
    }
    return personsObjectSet;
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
