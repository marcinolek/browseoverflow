//
//  MockStackOverflowManager.h
//  BrowseOverflow
//
//  Created by jata on 27/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "StackOverflowManager.h"


@interface MockStackOverflowManager : NSObject<StackOverflowCommunicatorDelegate> {
    NSInteger topicFailureErrorCode;
    NSInteger bodyFailureErrorCode;
    NSInteger answerFailureErrorCode;
    NSString *topicSearchString;
    NSString *questionBodyString;
    NSString *answerListString;
    BOOL wasAskedToFetchQuestions;
    BOOL wasAskedToFetchAnswers;
    BOOL wasAskedToFetchBody;
}

- (NSInteger)topicFailureErrorCode;
- (NSInteger)bodyFailureErrorCode;
- (NSInteger)answerFailureErrorCode;

- (NSString *)topicSearchString;
- (NSString *)questionBodyString;
- (NSString *)answerListString;

- (BOOL)didFetchQuestions;
- (BOOL)didFetchAnswers;
- (BOOL)didFetchQuestionBody;
- (void)fetchQuestionsOnTopic: (Topic *)topic;
- (void)fetchAnswersForQuestion: (Question *)question;
- (void)fetchBodyForQuestion: (Question *)question;

@property (strong) id delegate;

@end
