//
//  MockStackOverflowManagerDelegate.h
//  BrowseOverflow
//
//  Created by jata on 21/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackOverflowManager.h"

@class Question;

@interface MockStackOverflowManagerDelegate : NSObject <StackOverflowManagerDelegate>
@property (strong) NSError *fetchError;
@property (copy) NSArray *receivedQuestions;
@property (strong) Question *successQuestion;
@property (strong) Question *bodyQuestion;

- (void)didReceiveQuestions:(NSArray *)questions;
@end
