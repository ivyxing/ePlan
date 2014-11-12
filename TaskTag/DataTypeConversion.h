//
//  DataTypeConversion.h
//  TaskTag
//
//  Created by Min Xing on 11/11/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataTypeConversion : NSObject

+ (NSMutableArray *)tasksToDictionary:(NSSet *)tasksSet;
+ (NSArray*)tasksSetToSortedArray:(NSSet*)tasksSet;
+ (NSMutableArray *)extractPersonsServerIDs:(NSSet *)personsSet;

+ (NSString *)dateToString:(NSDate *)date;
+ (NSDate *)stringToDate:(NSString *)dateStr;
+ (NSDateFormatter *)standardizedShortStyleDateFormatter;

@end
