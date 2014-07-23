//
//  QuestionBuilder.m
//  BrowseOverflow
//
//  Created by jata on 22/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "QuestionBuilder.h"
#import "Question.h"
#import "Person.h"

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
    NSMutableArray *questionsArray = [[NSMutableArray alloc] initWithCapacity:items.count];
    for(NSDictionary *dict in items) {
        Question *q = [[Question alloc] init];
        q.questionID = [dict[@"question_id"] unsignedIntegerValue];
        q.date = [NSDate dateWithTimeIntervalSince1970:[dict[@"creation_date"] doubleValue]];
        q.title = dict[@"title"];
        q.score = [[dict objectForKey:@"score"] integerValue];
        NSDictionary *owner = dict[@"owner"];
        NSString *name = owner[@"display_name"];
        NSString *avatarLocation = owner[@"profile_image"];
        Person *asker = [[Person alloc] initWithName:name avatarLocation:avatarLocation];
        q.asker = asker;
        [questionsArray addObject:q];
        
        
    }
    
    return questionsArray;
}

- (void)fillInDetailsForQuestion:(Question *)question fromJSON:(NSString *)objectNotation
{
    NSParameterAssert(question!=nil);
    NSParameterAssert(objectNotation!=nil);
    NSData *unicodeNotation = [objectNotation dataUsingEncoding:NSUTF8StringEncoding];
    //TODO: details error handling
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:unicodeNotation options:0 error:NULL];
    NSDictionary *questionObject = [jsonObject[@"items"] lastObject];
    NSString *body = questionObject[@"body"];
    question.body = body;
}

@end

NSString *QuestionBuilderErrorDomain = @"QuestionBuilderErrorDomain";
