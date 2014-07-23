//
//  FakeQuestionBuilder.m
//  BrowseOverflow
//
//  Created by jata on 22/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "FakeQuestionBuilder.h"

@implementation FakeQuestionBuilder
- (NSArray *)questionsFromJSON:(NSString *)objectNotation error:(NSError *__autoreleasing *)error
{
    self.JSON = objectNotation;
    if (error) {
        *error = self.errorToSet;
    }
    return self.arrayToReturn;
}

- (void)fillInDetailsForQuestion:(Question *)question fromJSON:(NSString *)objectNotation {
    self.JSON = objectNotation;
    self.questionToFill = question;
}

@end

