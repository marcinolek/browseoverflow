//
//  Question.h
//  BrowseOverflow
//
//  Created by Marcin Olek on 15.07.2014.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Answer;
@class Person;
@interface Question : NSObject
@property (nonatomic, strong) NSDate *date;
@property (nonatomic) NSUInteger questionID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic) NSInteger score;
@property (nonatomic, strong) Person *asker;
- (NSArray *)answers;
- (void)addAnswer:(Answer *)answer;

@end
