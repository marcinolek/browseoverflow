//
//  Answer.h
//  BrowseOverflow
//
//  Created by Marcin Olek on 17.07.2014.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Person;
@interface Answer : NSObject
@property (nonatomic, copy) NSString *text;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger answerId;
@property (nonatomic, strong) Person *person;
@property (nonatomic, getter=isAccepted) BOOL accepted;

- (NSComparisonResult)compare:(Answer *)otherAnswer;
@end
