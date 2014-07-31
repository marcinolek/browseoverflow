//
//  Question+Copyable.m
//  BrowseOverflow
//
//  Created by Marcin Olek on 31.07.2014.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "Question+Copyable.h"

@implementation Question (Copyable)
- (id)copyWithZone:(NSZone *)zone
{
    Question *copy = [[[self class] alloc] init];
    if(copy) {
        copy.title = self.title;
        copy.body = self.body;
        copy.score = self.score;
        copy.asker = self.asker;
        copy.date = self.date;
        copy.questionID = self.questionID;
        for (Answer *answer in self.answers) {
            [copy addAnswer:answer];
        }
    }
    return copy;
}
@end
