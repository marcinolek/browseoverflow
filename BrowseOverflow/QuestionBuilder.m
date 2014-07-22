//
//  QuestionBuilder.m
//  BrowseOverflow
//
//  Created by jata on 22/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "QuestionBuilder.h"

@implementation QuestionBuilder

- (NSArray *)questionsFromJSON:(NSString *)objectNotation error:(NSError *__autoreleasing *)error
{
    
    NSParameterAssert(objectNotation != nil);
    
    NSData *unicodeNotation = [objectNotation dataUsingEncoding:NSUTF8StringEncoding];
    NSError *localError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:unicodeNotation options:0 error:&localError];
    NSDictionary *parsedObject = jsonObject;
    if(parsedObject == nil) {
        if(error != NULL) {
            *error = [NSError errorWithDomain:QuestionBuilderErrorDomain code:QuestionBuilderInvalidJSONError userInfo:nil];
        }
        return nil;
    }
    
    NSArray *items = [parsedObject objectForKey:@"items"];
    if(items == nil) {
        if(error != NULL) {
            *error = [NSError errorWithDomain:QuestionBuilderErrorDomain code:QuestionBuilderMissingDataError userInfo:nil];
        }
        return nil;
    }
    
    return nil;
}

@end

NSString *QuestionBuilderErrorDomain = @"QuestionBuilderErrorDomain";
