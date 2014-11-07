//
//  Person.h
//  TaskTag
//
//  Created by Min Xing on 11/7/14.
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
@property (nonatomic, retain) NSNumber * taggedForEvent;
@property (nonatomic, retain) NSNumber * taggedForTask;
@property (nonatomic, retain) NSString * serverID;
@property (nonatomic, retain) NSSet *parentEvent;
@property (nonatomic, retain) NSSet *parentTask;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addParentEventObject:(Event *)value;
- (void)removeParentEventObject:(Event *)value;
- (void)addParentEvent:(NSSet *)values;
- (void)removeParentEvent:(NSSet *)values;

- (void)addParentTaskObject:(Task *)value;
- (void)removeParentTaskObject:(Task *)value;
- (void)addParentTask:(NSSet *)values;
- (void)removeParentTask:(NSSet *)values;

@end


@interface Person (CustomAccessors)

- (void) updateWithDictionary:(NSDictionary*)dictionary;
- (NSDictionary*) toDictionary;

@end
