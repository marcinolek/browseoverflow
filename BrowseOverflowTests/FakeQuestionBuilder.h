//
//  FakeQuestionBuilder.h
//  BrowseOverflow
//
//  Created by jata on 22/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "QuestionBuilder.h"

@interface FakeQuestionBuilder : QuestionBuilder
@property (copy) NSString *JSON;
@property (copy) NSArray *arrayToReturn;
@property (copy) NSError *errorToSet;
@end
