//
//  Person.h
//  TaskTag
//
//  Created by Min Xing on 10/1/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * editingPermissionLevel;
@property (nonatomic, retain) NSSet *parentEvent;
@property (nonatomic, retain) NSSet *parentTask;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addParentEventObject:(Event *)value;
- (void)removeParentEventObject:(Event *)value;
- (void)addParentEvent:(NSSet *)values;
- (void)removeParentEvent:(NSSet *)values;

- (void)addParentTaskObject:(NSManagedObject *)value;
- (void)removeParentTaskObject:(NSManagedObject *)value;
- (void)addParentTask:(NSSet *)values;
- (void)removeParentTask:(NSSet *)values;

@end
