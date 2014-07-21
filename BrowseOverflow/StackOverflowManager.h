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

extern NSString *StackOverFlowManagerError;

enum {
    StackOverflowManagerErrorQuestionSearchCode
};


@protocol StackOverflowManagerDelegate <NSObject>
- (void)fetchingQuestionsFailedWithError:(NSError *)error;
@end

@interface StackOverflowManager : NSObject
@property (strong) StackOverflowCommunicator *communicator;
@property (nonatomic, weak) id<StackOverflowManagerDelegate> delegate;

- (void)fetchQuestionsOnTopic:(Topic *)topic;
- (void)searchingForQuestionsFailedWithError:(NSError *)error;

@end
