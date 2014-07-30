//
//  AnswerTests.m
//  BrowseOverflow
//
//  Created by Marcin Olek on 17.07.2014.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Person.h"
#import "Answer.h"

@interface AnswerTests : XCTestCase {
    Answer *answer;
    Answer *otherAnswer;
}

@end

@implementation AnswerTests

- (void)setUp
{
    [super setUp];
    answer = [[Answer alloc] init];
    answer.text = @"The answer is 42";
    answer.person = [[Person alloc] initWithName:@"Marcin Olek" avatarLocation:@"http://example.com/avatar.png"];
    answer.score = 42;
    otherAnswer = [[Answer alloc] init];
    otherAnswer.text = @"I have the answer you need";
    otherAnswer.score = 42;
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    answer = nil;
    [super tearDown];
}

- (void)testAnswerHasSomeText
{
    XCTAssertEqualObjects(answer.text, @"The answer is 42", @"Answers need to contain some text");
}

- (void)testSomeoneProvidedTheAnswer
{
    XCTAssertTrue([answer.person isKindOfClass:[Person class]], @"A person gave this answer");
}

- (void)testAnswerNotAccetedByDefault
{
    XCTAssertFalse(answer.accepted, @"Answer not accepted by default");
}

- (void)testAnswerCanBeAccepted
{
    XCTAssertNoThrow(answer.accepted = YES, @"It is posible to accept an answer");
}

- (void)testAnswerHasAScore
{
    XCTAssertTrue(answer.score == 42, @"Answer's score can be retrieved");
}

- (void)testAcceptedAnswerComesBeforeUnaccepted
{
    otherAnswer.accepted = YES;
    otherAnswer.score = answer.score + 10;
    XCTAssertEqual([answer compare:otherAnswer], NSOrderedDescending, @"Accepted answer should come firts");
    XCTAssertEqual([otherAnswer compare:answer], NSOrderedAscending, @"Unaccepted aswer should come last");
}

- (void)testAnswersWithEqualScoresCompareEqually
{
    XCTAssertEqual([answer compare:otherAnswer], NSOrderedSame, @"Both answers of equal rank");
    XCTAssertEqual([otherAnswer compare:answer], NSOrderedSame, @"Each answer has the same rank");
}

- (void)testLowerScoringAnswerComesAfterHigher
{
    otherAnswer.score = answer.score + 10;
    XCTAssertEqual([answer compare:otherAnswer], NSOrderedDescending, @"Higher score comes first");
    XCTAssertEqual([otherAnswer compare:answer], NSOrderedAscending, @"Lower score come last");
}


@end
