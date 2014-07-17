//
//  Question.m
//  BrowseOverflow
//
//  Created by Marcin Olek on 15.07.2014.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "Question.h"
#import "Answer.h"

@interface Question () {
    NSMutableSet *answerSet;
}

@property (readonly) NSArray *answers;

- (void)addAnswer:(Answer *)answer;

@end

@implementation Question

- (instancetype)init
{
    if((self = [super init])) {
        answerSet = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)addAnswer:(Answer *)answer
{
    [answerSet addObject:answer];
}

- (NSArray *)answers
{
    return [[answerSet allObjects] sortedArrayUsingSelector:@selector(compare:)];
}

@end
