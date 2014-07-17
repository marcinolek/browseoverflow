//
//  Question.h
//  BrowseOverflow
//
//  Created by Marcin Olek on 15.07.2014.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Answer;

@interface Question : NSObject
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *title;
@property (nonatomic) NSInteger score;
- (NSArray *)answers;
- (void)addAnswer:(Answer *)answer;

@end
