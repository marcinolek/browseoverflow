//
//  QuestionTests.m
//  BrowseOverflow
//
//  Created by Marcin Olek on 15.07.2014.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Question.h"
#import "Answer.h"
#import "Person.h"

@interface QuestionTests : XCTestCase {
    Question *question;
    Answer *lowScore;
    Answer *highScore;
    Person *asker;
}

@end

@implementation QuestionTests

- (void)setUp
{
    question = [[Question alloc] init];
    question.date = [NSDate distantPast];
    question.title = @"Do iPhones also dream of electric sheep?";
    question.score = 42;
    question.questionID = 1;
    Answer *accepted = [[Answer alloc] init];
    accepted.answerId = 1;
    accepted.score = 1;
    accepted.accepted = YES;
    [question addAnswer:accepted];
    
    lowScore = [[Answer alloc] init];
    lowScore.score = -4;
    lowScore.answerId = 2;
    [question addAnswer:lowScore];
    
    highScore = [[Answer alloc] init];
    highScore.score = 4;
    highScore.answerId = 3;
    [question addAnswer:highScore];
    asker = [[Person alloc] initWithName:@"Marcin Olek" avatarLocation:@"http://example.com/avatar.png"];
    question.asker = asker;
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    question = nil;
    highScore = nil;
    lowScore = nil;
    asker = nil;
    [super tearDown];
}

- (void)testThatQuestionHasADate
{
    
    NSDate *testDate = [NSDate distantPast];
    question.date = testDate;
    XCTAssertEqualObjects(question.date, testDate, @"Question needs to provide its date");
}

- (void)testQuestionsKeepScore
{
    XCTAssertEqual(question.score, 42, @"Questions need a numeric score");
}

- (void)testQuestionHasATitle
{
    XCTAssertEqualObjects(question.title, @"Do iPhones also dream of electric sheep?", @"Question should know its title");
}

- (void)testQuestionCanHaveAnswersAdded
{
    Answer *myAnswer = [[Answer alloc] init];
    myAnswer.answerId = 1;
    XCTAssertNoThrow([question addAnswer:myAnswer ], @"Must be able to add answers");
}

- (void)testAcceptedAnswerIsFirst
{
    XCTAssertTrue([question.answers[0] isAccepted], @"Accepted answer comes first");
}

- (void)testHighScoreAnswerBeforeLow
{
    NSArray *answers = question.answers;
    NSInteger highIndex = [answers indexOfObject:highScore];
    NSInteger lowIndex = [answers indexOfObject:lowScore];
    XCTAssertTrue(highIndex < lowIndex, @"High-scoring answer comes first");
}

- (void)testQuestionWasAskedBySomeone
{
    XCTAssertEqualObjects(question.asker, asker, @"Question should keep track of who asked it.");
}

@end
