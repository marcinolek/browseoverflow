//
//  QuestionBuilder.h
//  BrowseOverflow
//
//  Created by jata on 22/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionBuilder : NSObject
- (NSArray *)questionsFromJSON:(NSString *)objectNotation error:(NSError **)error;
@end
