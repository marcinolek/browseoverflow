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

extern NSString *StackOverFlowManagerError;
extern NSString *StackOverflowManagerSearchFailedError;
enum {
    StackOverflowManagerErrorQuestionSearchCode
};


@protocol StackOverflowManagerDelegate <NSObject>
- (void)fetchingQuestionsFailedWithError:(NSError *)error;
- (void)didReceiveQuestions:(NSArray *)questions;
@end

@interface StackOverflowManager : NSObject
@property (strong) StackOverflowCommunicator *communicator;
@property (nonatomic, weak) id<StackOverflowManagerDelegate> delegate;
@property (strong) QuestionBuilder *questionBuilder;

- (void)fetchQuestionsOnTopic:(Topic *)topic;
- (void)searchingForQuestionsFailedWithError:(NSError *)error;
- (void)receivedQuestionsJSON:(NSString *)objectNotation;

- (void)fetchBodyForQuestion:(Question*)questionToFetch;
- (void)fetchingQuestionBodyFailedWithError:(NSError *)underlyingError;
- (void)receivedQuestionBodyJSON:(NSString *)objectNotation;

@end
