//
//  Task.h
//  TaskTag
//
//  Created by Min Xing on 11/7/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Person;

@interface Task : NSManagedObject

@property (nonatomic, retain) NSString * alert;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) id commentsArray;
@property (nonatomic, retain) NSString * serverID;
@property (nonatomic, retain) Event *parentEvent;
@property (nonatomic, retain) NSSet *persons;
@end

@interface Task (CoreDataGeneratedAccessors)

- (void)addPersonsObject:(Person *)value;
- (void)removePersonsObject:(Person *)value;
- (void)addPersons:(NSSet *)values;
- (void)removePersons:(NSSet *)values;

@end

@interface Task (CustomAccessors)

- (void) updateWithDictionary:(NSDictionary*)dictionary;
- (NSDictionary*) toDictionary;

@end
