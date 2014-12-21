//
//  Events.h
//  TaskTag
//
//  Created by Min Xing on 11/6/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Event;

@interface ServerBackend : NSObject

//Temp. Fix later
@property (strong, nonatomic) NSMutableArray *comments;


- (void) import;
- (void) persistEvent:(Event *)event;

- (void)getComments;
- (void)sendCommentToServer:(NSDictionary*)dictionary;

+ (id)sharedServerBackend;

@end


