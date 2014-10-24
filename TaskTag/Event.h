//
//  Event.h
//  TaskTag
//
//  Created by Min Xing on 10/9/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Person, Task;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSData * image;
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
