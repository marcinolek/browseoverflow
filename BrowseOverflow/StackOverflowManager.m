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
#import "AnswerBuilder.h"

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
    NSError *reportableError = [NSError errorWithDomain:StackOverflowManagerError code:StackOverflowManagerErrorQuestionSearchCode userInfo:errorInfo];
    [self.delegate fetchingQuestionsFailedWithError:reportableError];

}

- (void)tellDelegateAboutQuestionBodyRetrievalError:(NSError *)error
{
    NSDictionary *errorInfo = nil;
    if(error) {
        errorInfo = [NSDictionary dictionaryWithObject:error forKey:NSUnderlyingErrorKey];
    }
    NSError *reportableError = [NSError errorWithDomain:StackOverflowManagerError code:StackOverflowManagerErrorQuestionBodyCode userInfo:errorInfo];
    [self.delegate fetchingQuestionsFailedWithError:reportableError];

}

- (void)fetchBodyForQuestion:(Question*)questionToFetch
{
    self.questionNeedingBody = questionToFetch;
    [self.communicator fetchBodyForQuestion:[questionToFetch questionID]];
}

- (void)fetchingQuestionBodyFailedWithError:(NSError *)error
{
    [self tellDelegateAboutQuestionBodyRetrievalError:error];
}

- (void)receivedQuestionBodyJSON:(NSString *)objectNotation
{
    [self.questionBuilder fillInDetailsForQuestion:self.questionNeedingBody fromJSON: objectNotation];
    self.questionNeedingBody = nil;
}

- (void)fetchAnswersForQuestion:(Question *)question
{
    self.questionToFill = question;
    [self.communicator downloadAnswersToQuestionWithID:[question questionID]];
}

- (void)fetchingAnswersFailedWithError:(NSError *)error
{
    NSDictionary *errorInfo = nil;
    if(error) {
        errorInfo = [NSDictionary dictionaryWithObject:error forKey:NSUnderlyingErrorKey];
    }
    NSError *reportableError = [NSError errorWithDomain:StackOverflowManagerError code:StackOverflowManagerErrorAnswerCode userInfo:errorInfo];
    [self.delegate fetchingAnswersFailedWithError:reportableError];
}

- (void)receivedAnswerListJSON: (NSString *)objectNotation {
    NSError *error = nil;
    if ([self.answerBuilder addAnswersToQuestion: self.questionToFill fromJSON: objectNotation error: &error]) {
        [self.delegate answersReceivedForQuestion: self.questionToFill];
        self.questionToFill = nil;
    }
    else {
        [self fetchingAnswersFailedWithError: error];
    }
}

@end

NSString *StackOverflowManagerError = @"StackOverFlowManagerError";
