//
//  Topic.m
//  BrowseOverflow
//
//  Created by Marcin Olek on 15.07.2014.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "Topic.h"

@implementation Topic

- (id)initWithName:(NSString *)newName tag:(NSString *)newTag {
    if((self = [super init])) {
        _name = newName;
        _tag = newTag;
    }
    return self;
}

- (NSArray *)recentQuestions {
    return [NSArray array];
}

@end
