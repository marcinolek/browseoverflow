//
//  QuestionBuilder.h
//  BrowseOverflow
//
//  Created by jata on 22/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionBuilder : NSObject

@property (copy) NSString *JSON;
@property (copy) NSArray *arrayToReturn;
@property (copy) NSError *errorToSet;

- (NSArray *)questionsFromJSON:(NSString *)objectNotation error:(NSError **)error;

@end

extern NSString *QuestionBuilderErrorDomain;

enum {
    QuestionBuilderInvalidJSONError,
    QuestionBuilderMissingDataError
};
