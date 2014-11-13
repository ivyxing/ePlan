//
//  Person.h
//  TaskTag
//
//  Created by Min Xing on 11/13/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Task;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * fbProfilePictureID;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * isCurrentUser;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * serverID;
@property (nonatomic, retain) NSNumber * taggedForEvent;
@property (nonatomic, retain) NSNumber * taggedForTask;
@property (nonatomic, retain) NSSet *parentEvents;
@property (nonatomic, retain) NSSet *parentTasks;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addParentEventsObject:(Event *)value;
- (void)removeParentEventsObject:(Event *)value;
- (void)addParentEvents:(NSSet *)values;
- (void)removeParentEvents:(NSSet *)values;

- (void)addParentTasksObject:(Task *)value;
- (void)removeParentTasksObject:(Task *)value;
- (void)addParentTasks:(NSSet *)values;
- (void)removeParentTasks:(NSSet *)values;

@end

@interface Person (CustomAccessors)

- (void) updateWithDictionary:(NSDictionary*)dictionary;
- (NSDictionary*) toDictionary;

@end