//
//  DataTypeConversion.h
//  TaskTag
//
//  Created by Min Xing on 11/11/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Event;

@interface DataTypeConversion : NSObject

// Core data object type conversions.
+ (Event *)eventObjectFromEventServerID:(NSString *)eventServerID;
+ (NSSet *)eventObjectSetFromEventServerIDsArray:(NSArray *)eventServerID;
+ (NSArray *)eventsServerIDsArrayFromEventsObjectSet:(NSSet *)eventsSet;

+ (NSArray *)tasksObjectSortedArrayFromTasksObjectSet:(NSSet*)tasksSet;
+ (NSMutableArray *)tasksDictionaryArrayFromTasksObjectSet:(NSSet *)tasksSet;
+ (NSSet *)tasksObjectSetFromTasksDictionaryArray:(NSArray *)tasksDictionaryArray;
+ (NSArray *)tasksServerIDsArrayFromTasksObjectSet:(NSSet *)tasksSet;
+ (NSSet *) taskObjectFromTaskServerID:(NSString *)taskServerID;
+ (NSSet *)tasksObjectSetFromTasksServerIDsArray:(NSArray *)tasksServerIDsArray;
    
+ (NSMutableArray *)personsServerIDsArrayFromPersonsObjectSet:(NSSet *)personsSet;
+ (NSSet *)personObjectFromPersonServerID:(NSString *)personServerID;
+ (NSSet *)personsObjectSetFromPersonsServerIDsArray:(NSArray *)personsServerIDsArray;

// NSDate type conversions.
+ (NSString *)dateToString:(NSDate *)date;
+ (NSDate *)stringToDate:(NSString *)dateStr;
+ (NSDateFormatter *)standardizedShortStyleDateFormatter;

@end
