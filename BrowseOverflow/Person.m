//
//  Person.m
//  BrowseOverflow
//
//  Created by Marcin Olek on 16.07.2014.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "Person.h"

@implementation Person

- (instancetype)initWithName:(NSString *)newName avatarLocation:(NSString *)avatarLocation
{
    if((self = [super init])) {
        _avatarURL = [NSURL URLWithString:avatarLocation];
        _name = [newName copy];
    }
    return self;
}

@end
