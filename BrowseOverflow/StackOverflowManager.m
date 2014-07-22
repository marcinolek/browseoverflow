//
//  StackOverflowManager.m
//  BrowseOverflow
//
//  Created by jata on 21/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "StackOverflowManager.h"
#import "Topic.h"
#import "QuestionBuilder.h"

@implementation StackOverflowManager

- (void)setDelegate:(id<StackOverflowManagerDelegate>)delegate
{
    if(delegate && ![delegate conformsToProtocol:@protocol(StackOverflowManagerDelegate)]) {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"Delegate object does not conform to the delegate protocol" userInfo:nil] raise];
    }
    _delegate = delegate;
}

- (void)fetchQuestionsOnTopic:(Topic *)topic
{
    [self.communicator searchForQuestionsWithTag:[topic tag]];
}

- (void)searchingForQuestionsFailedWithError:(NSError *)error
{
    [self tellDelegateAboutQuestionSearchError:error];
}

- (void)receivedQuestionsJSON:(NSString *)objectNotation
{
    NSError *error = nil;
    NSArray *questions = [self.questionBuilder questionsFromJSON:objectNotation error:&error];
    if(!questions) {
        [self tellDelegateAboutQuestionSearchError:error];
    } else {
        [self.delegate didReceiveQuestions:questions];
    }
    
}

- (void)tellDelegateAboutQuestionSearchError:(NSError *)error
{
    NSDictionary *errorInfo = nil;
    if(error) {
        errorInfo = [NSDictionary dictionaryWithObject:error forKey:NSUnderlyingErrorKey];
    }
    NSError *reportableError = [NSError errorWithDomain:StackOverflowManagerSearchFailedError code:StackOverflowManagerErrorQuestionSearchCode userInfo:errorInfo];
    [self.delegate fetchingQuestionsFailedWithError:reportableError];

}

@end

NSString *StackOverFlowManagerError = @"StackOverFlowManagerSearchFailedError";
NSString *StackOverflowManagerSearchFailedError = @"StackOverflowManagerSearchFailedError";
