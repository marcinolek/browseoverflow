//
//  StackOverflowManager.h
//  BrowseOverflow
//
//  Created by jata on 21/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackOverflowCommunicator.h"

@class Topic;
@class QuestionBuilder;
@class Question;
@class AnswerBuilder;

extern NSString *StackOverflowManagerError;

enum {
    StackOverflowManagerErrorQuestionSearchCode,
    StackOverflowManagerErrorQuestionBodyCode,
    StackOverflowManagerErrorAnswerCode
};


@protocol StackOverflowManagerDelegate <NSObject>
- (void)fetchingQuestionsFailedWithError:(NSError *)error;
- (void)didReceiveQuestions:(NSArray *)questions;
- (void)fetchingAnswersFailedWithError:(NSError *)error;
- (void)answersReceivedForQuestion: (Question *)question;
- (void)bodyReceivedForQuestion: (Question *)question;
@end

@interface StackOverflowManager : NSObject <StackOverflowCommunicatorDelegate>
@property (strong) StackOverflowCommunicator *communicator;
@property (strong) StackOverflowCommunicator *bodyCommunicator;
@property (nonatomic, weak) id<StackOverflowManagerDelegate> delegate;
@property (strong) QuestionBuilder *questionBuilder;
@property (nonatomic, strong) AnswerBuilder *answerBuilder;
@property (nonatomic, strong) Question *questionNeedingBody;
@property (nonatomic, strong) Question *questionToFill;

- (void)fetchQuestionsOnTopic:(Topic *)topic;
- (void)searchingForQuestionsFailedWithError:(NSError *)error;
- (void)receivedQuestionsJSON:(NSString *)objectNotation;

- (void)fetchBodyForQuestion:(Question*)questionToFetch;
- (void)fetchAnswersForQuestion:(Question *)question;
- (void)fetchingQuestionBodyFailedWithError:(NSError *)error;
- (void)receivedQuestionBodyJSON:(NSString *)objectNotation;

@end
