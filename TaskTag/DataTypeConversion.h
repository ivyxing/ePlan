//
//  DataTypeConversion.h
//  TaskTag
//
//  Created by Min Xing on 11/11/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Event, Task, Person;

@interface DataTypeConversion : NSObject

// Core Date type conversions.
+ (NSArray *)eventsDictionaryArrayFromEventsObjectSet:(NSSet *)eventsSet;
+ (NSSet *)eventObjectSetFromEventsDictionaryArray:(NSArray *)eventsDictionaryArray;
+ (Event *)eventObjectFromEventServerID:(NSString *)eventServerID update:(NSDictionary *)dictionary;
+ (NSArray *)eventsServerIDsArrayFromEventsObjectSet:(NSSet *)eventsSet;

+ (NSArray *)tasksObjectSortedArrayFromTasksObjectSet:(NSSet*)tasksSet;
+ (NSArray *)tasksDictionaryArrayFromTasksObjectSet:(NSSet *)tasksSet;
+ (NSSet *)tasksObjectSetFromTasksDictionaryArray:(NSArray *)tasksDictionarysArray;
+ (Task *)taskObjectFromTaskServerID:(NSString *)taskServerID updateWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)personsServerIDsArrayFromPersonsObjectSet:(NSSet *)personsSet;
+ (NSSet *)personsObjectSetFromPersonsServerIDsArray:(NSArray *)personsServerIDsArray;
+ (Person *)personObjectFromPersonServerID:(NSString *)personServerID;

// NSDate type conversions.
+ (NSString *)dateToString:(NSDate *)date;
+ (NSDate *)stringToDate:(NSString *)dateStr;
+ (NSDateFormatter *)standardizedShortStyleDateFormatter;

@end
