//
//  Answer.m
//  BrowseOverflow
//
//  Created by Marcin Olek on 17.07.2014.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "Answer.h"

@implementation Answer


- (NSComparisonResult)compare:(Answer *)otherAnswer
{

    if(_accepted && !(otherAnswer.accepted)) {
        return NSOrderedAscending;
    } else if(!_accepted && otherAnswer.accepted) {
        return NSOrderedDescending;
    }

    if(_score > otherAnswer.score) {
        return NSOrderedAscending;
    } else if(_score < otherAnswer.score) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

- (BOOL)isEqual:(id)object
{
    Answer *otherAnswer = (Answer *)object;
    return self.answerId == otherAnswer.answerId;
}

@end
