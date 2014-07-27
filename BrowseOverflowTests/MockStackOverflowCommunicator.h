//
//  MockStackOverflowCommunicator.h
//  BrowseOverflow
//
//  Created by jata on 21/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "StackOverflowCommunicator.h"

@interface MockStackOverflowCommunicator : StackOverflowCommunicator
- (BOOL)wasAskedToFetchQuestions;
- (BOOL)wasAskedToFetchBody;

@end
