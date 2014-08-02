//
//  MockStackOverflowManagerDelegate.m
//  BrowseOverflow
//
//  Created by jata on 21/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "MockStackOverflowManagerDelegate.h"

@implementation MockStackOverflowManagerDelegate

- (void)fetchingQuestionsFailedWithError:(NSError *)error
{
    self.fetchError = error;
}

- (void)didReceiveQuestions:(NSArray *)questions
{
    self.receivedQuestions = questions;
}

- (void)answersReceivedForQuestion:(Question *)question
{
    self.successQuestion = question;
}

- (void)fetchingAnswersFailedWithError:(NSError *)error
{
    self.fetchError = error;
}

- (void)bodyReceivedForQuestion:(Question *)question
{
    self.bodyQuestion = question;
}


@end
