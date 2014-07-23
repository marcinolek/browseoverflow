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
    BOOL wasAskedToFetchBody;
}

- (void)searchForQuestionsWithTag:(NSString *)tag
{
    wasAskedToFetchQuestions = YES;
}

- (BOOL)wasAskedToFetchQuestions
{
    return wasAskedToFetchQuestions;
}

- (BOOL)wasAskedToFetchBody
{
    return wasAskedToFetchBody;
}

- (void)fetchBodyForQuestion:(NSUInteger)questionID {
    wasAskedToFetchBody = YES;
}

@end
