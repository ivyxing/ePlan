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

#define safeInput(v,d,k) if (d[k]) v = d[k];

@implementation DataTypeConversion

#pragma mark - Event

+ (NSArray *)eventsDictionaryArrayFromEventsObjectSet:(NSSet *)eventsSet {
    NSMutableArray *eventsDictionaryArray = [NSMutableArray array];
    for (Event *event in eventsSet) {
        NSDictionary *eventDictionary = [event toDictionary];
        [eventsDictionaryArray addObject:eventDictionary];
    }
    return eventsDictionaryArray;
}

+ (NSSet *)eventObjectSetFromEventsDictionaryArray:(NSArray *)eventsDictionaryArray {
    NSMutableSet *eventsObjectSet = [NSMutableSet set];
    for (NSDictionary *eventDictionary in eventsDictionaryArray) {
        Event *event = [self eventObjectFromEventServerID:eventDictionary[@"_id"] update:eventDictionary];
        if (event) {
            [eventsObjectSet addObject:event];
        }
    }
    return eventsObjectSet;
}

+ (Event *)eventObjectFromEventServerID:(NSString *)eventServerID update:(NSDictionary *)dictionary{
    if (eventServerID == nil) {
        return nil;
    }
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY serverID like %@", eventServerID];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    Event *event = (array == nil || array.count == 0) ?  [self createEvent] : array[0];
    [event updateWithDictionary:dictionary];
    return event;
}

+ (Event *)createEvent {
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    Event *event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
    NSLog(@"New Event");
    return event;
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

+ (NSSet *)tasksObjectSetFromTasksDictionaryArray:(NSArray *)tasksDictionarysArray {
    NSMutableSet *tasksObjectSet = [NSMutableSet set];
    for (NSDictionary *taskDictionary in tasksDictionarysArray) {
        [tasksObjectSet addObject:[self taskObjectFromTaskServerID:taskDictionary[@"_id"]
             updateWithDictionary:taskDictionary]];
    }
    return tasksObjectSet;
}

+ (Task *)taskObjectFromTaskServerID:(NSString *)taskServerID updateWithDictionary:(NSDictionary *)dictionary {
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"serverID like %@", taskServerID];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    Task *task = (array == nil) ? [self createTask] : array[0];
    [task updateWithDictionary:dictionary];
    return task;
}

+ (Task *)createTask {
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    Task *task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:context];
    NSLog(@"New Task");
    return task;
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

+ (NSSet *)personsObjectSetFromPersonsServerIDsArray:(NSArray *)personsServerIDsArray {
    NSMutableSet *personsObjectSet = [NSMutableSet set];
    for (NSString *personServerID in personsServerIDsArray) {
        [personsObjectSet addObject:[self personObjectFromPersonServerID:personServerID]];
    }
    return personsObjectSet;
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
    return (array == nil) ? [self createPerson] : array[0];
}

+ (Person *)createPerson {
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
    NSLog(@"New Person");
    return person;
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