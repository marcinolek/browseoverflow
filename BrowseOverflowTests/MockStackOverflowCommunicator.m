//
//  MockStackOverflowCommunicator.m
//  BrowseOverflow
//
//  Created by jata on 21/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "MockStackOverflowCommunicator.h"


@implementation MockStackOverflowCommunicator {
    BOOL wasAskedToFetchQuestions;
}

- (void)searchForQuestionsWithTag:(NSString *)tag
{
    wasAskedToFetchQuestions = YES;
}

- (BOOL)wasAskedToFetchQuestions
{
    return wasAskedToFetchQuestions;
}

@end
