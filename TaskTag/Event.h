//
//  Event.h
//  TaskTag
//
//  Created by Min Xing on 11/7/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Person, Task;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * serverID;
@property (nonatomic, retain) NSSet *persons;
@property (nonatomic, retain) NSSet *tasks;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addPersonsObject:(Person *)value;
- (void)removePersonsObject:(Person *)value;
- (void)addPersons:(NSSet *)values;
- (void)removePersons:(NSSet *)values;

- (void)addTasksObject:(Task *)value;
- (void)removeTasksObject:(Task *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;

@end

@interface Event (CustomAccessors)

- (void) updateWithDictionary:(NSDictionary*)dictionary;
- (NSDictionary*) toDictionary;
- (NSString *)convertDateToString:(NSDate *)date;
- (NSDate *)convertStringToDate:(NSString *)dateStr;
- (NSDateFormatter *)standardizedDateFormatter;

@end
