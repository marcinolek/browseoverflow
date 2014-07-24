//
//  AnswerBuilder.h
//  BrowseOverflow
//
//  Created by jata on 24/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Question;

extern NSString *AnswerBuilderErrorDomain;

enum {
    AnswerBuilderInvalidJSONError,
    AnswerBuilderMissingDataError
};

@interface AnswerBuilder : NSObject
- (BOOL)addAnswersToQuestion:(Question *)question fromJSON:(NSString *)objectNotation error:(NSError **)error;
@end
