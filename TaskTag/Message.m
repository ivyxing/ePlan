//
//  Message.m
//  TaskTag
//
//  Created by Min Xing on 11/17/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "Message.h"

@implementation Message

+ (instancetype)messageWithJSONDictionary:(NSDictionary *)dictionary {
    Message *msg = [Message new];
    msg.username = dictionary[@"username"];
    msg.content = dictionary[@"content"];
    
    return msg;
}

- (NSDictionary*) messageToJSONDictionary {
    NSDictionary* newDictionary = @{@"username":self.username, @"content":self.content};
    return newDictionary;
}

@end
