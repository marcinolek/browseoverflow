//
//  AnswerBuilder.m
//  BrowseOverflow
//
//  Created by jata on 24/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "AnswerBuilder.h"
#import "Question.h"
#import "Answer.h"
#import "Person.h"

@implementation AnswerBuilder
- (BOOL)addAnswersToQuestion:(Question *)question fromJSON:(NSString *)objectNotation error:(NSError **)error
{
    NSParameterAssert(question);
    NSParameterAssert(objectNotation);
    
    NSData *unicodeNotation = [objectNotation dataUsingEncoding:NSUTF8StringEncoding];
    NSError *localError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:unicodeNotation options:0 error:&localError];
    NSDictionary *parsedObject = jsonObject;
    if(!parsedObject) {
        if(error != NULL) {
            *error = [NSError errorWithDomain:AnswerBuilderErrorDomain code:AnswerBuilderInvalidJSONError userInfo:nil];
        }
        return NO;
    }
    
    NSArray *items = parsedObject[@"items"];
    if(!items) {
        if(error != NULL) {
            *error = [NSError errorWithDomain:AnswerBuilderErrorDomain code:AnswerBuilderMissingDataError userInfo:nil];
        }
        return NO;
    }
    
    for(NSDictionary *dict in items) {
        Answer *answer = [[Answer alloc] init];
        answer.score = [dict[@"score"] integerValue];
        answer.accepted = [dict[@"is_accepted"] boolValue];
        answer.text = dict[@"body"];
        answer.answerId = [dict[@"answer_id"] integerValue];
        NSDictionary *owner = dict[@"owner"];
        NSString *answererName = owner[@"display_name"];
        NSString *answererAvatarLocation = owner[@"profile_image"];
        Person *answerer = [[Person alloc] initWithName:answererName avatarLocation:answererAvatarLocation];
        answer.person = answerer;
        [question addAnswer:answer];
        
    }
    
    
    return YES;
}

@end

NSString *AnswerBuilderErrorDomain = @"NSString *AnswerBuilderErrorDomain";
