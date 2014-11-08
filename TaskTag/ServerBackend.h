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

- (void) import;
- (void) persistEvent:(Event *)event;

+ (id)sharedServerBackend;

@end


