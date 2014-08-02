//
//  TopicTests.m
//  BrowseOverflow
//
//  Created by Marcin Olek on 15.07.2014.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Topic.h"
#import "Question.h"

@interface TopicTests : XCTestCase {
    Topic *topic;
}
@end

@implementation TopicTests

- (void)setUp
{
    [super setUp];
    topic = [[Topic alloc] initWithName:@"iPhone" tag:@"iPhone"];
}

- (void)tearDown
{
    topic = nil;
    [super tearDown];
}

- (void)testThatTopicExists
{
    XCTAssertNotNil(topic, @"should be able to create a Topic instance");
}

- (void)testThatTopicCanBeNamed
{
    XCTAssertEqualObjects(topic.name, @"iPhone", @"the Topic should have the name I gave it");
}

- (void)testThatTopicHasATag
{
    XCTAssertEqualObjects(topic.tag, @"iPhone", @"Topics need to have tags");
}

- (void)testForAListOfQuestions
{
    XCTAssertTrue([[topic recentQuestions] isKindOfClass:[NSArray class]], @"Topics should provide a list of recent questions");
}

- (void)testForInitiallyEmptyQuestionList
{
    XCTAssertEqual([[topic recentQuestions] count], (NSUInteger) 0, @"No questions added yet, count should be zero");
}

- (void)testAddingAQuestionToTheList
{
    Question *question = [[Question alloc] init];
    question.questionID = 1;
    [topic addQuestion:question];
    XCTAssertEqual([[topic recentQuestions] count], (NSUInteger)1, @"Add a question and the count of questions should go up");
}

- (void)testQuestionsAreListedChronologically
{
    Question *q1 = [[Question alloc] init];
    q1.questionID = 1;
    q1.date = [NSDate distantPast];
    Question *q2 = [[Question alloc] init];
    q2.questionID = 2;
    q2.date = [NSDate distantFuture];
    [topic addQuestion:q1];
    [topic addQuestion:q2];
    NSArray *questions = [topic recentQuestions];
    
    Question *listedFirst = questions[0];
    Question *listedSecond = questions[1];
    XCTAssertEqualObjects([listedFirst.date laterDate:listedSecond.date], listedFirst.date, @"The later question should appear first in the list");
}

- (void)testLimitOfTwentyQuestions
{
    Question *q1 = [[Question alloc] init];
    q1.questionID = 99;
    for(NSInteger i = 0; i < 25; i++) {
        [topic addQuestion:q1];
    }
    XCTAssertTrue([topic.recentQuestions count] < 21, @"There should never be more than twenty questions");
}



@end
