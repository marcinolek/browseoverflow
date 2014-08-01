//
//  BrowseOverflowObjectConfiguration.m
//  BrowseOverflow
//
//  Created by jata on 01/08/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "BrowseOverflowConfigurationObject.h"
#import "StackOverflowManager.h"
#import "StackOverflowCommunicator.h"
#import "QuestionBuilder.h"
#import "AnswerBuilder.h"

@implementation BrowseOverflowConfigurationObject

- (StackOverflowManager *)stackOverflowManager
{
    StackOverflowManager *manager = [[StackOverflowManager alloc] init];
    manager.communicator = [[StackOverflowCommunicator alloc] init];
    manager.communicator.delegate = manager;
    manager.questionBuilder = [[QuestionBuilder alloc] init];
    manager.answerBuilder = [[AnswerBuilder alloc] init];
    return manager;
}

@end
