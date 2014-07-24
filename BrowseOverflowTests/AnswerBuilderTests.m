//
//  AnswerBuilderTests.m
//  BrowseOverflow
//
//  Created by jata on 24/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Answer.h"
#import "AnswerBuilder.h"
#import "Question.h"
#import "Person.h"

@interface AnswerBuilderTests : XCTestCase {
    AnswerBuilder *answerBuilder;
    Question *question;
}
@end

@implementation AnswerBuilderTests

static NSString *answerJSON = @"{\"items\":[{\"owner\":{\"reputation\":5477,\"user_id\":3386109,\"user_type\":\"registered\",\"profile_image\":\"http://i.stack.imgur.com/zt9UL.png?s=128&g=1\",\"display_name\":\"user3386109\",\"link\":\"http://stackoverflow.com/users/3386109/user3386109\"},\"is_accepted\":false,\"score\":1,\"last_activity_date\":1406060994,\"creation_date\":1406060994,\"answer_id\":24897221,\"question_id\":24896953,\"body\":\"<p>The real answer to the question is that good apps fall into one of three categories: portrait-only apps, landscape-only apps, and apps that support both orientations in all view controllers.  </p>\\n\\n<p>The UX design goal: the user controls the app, the app <strong>does not</strong> control the user.</p>\\n\\n<p>An app that has some view controllers that are portrait-only, and some view controllers that support rotation, is an app that is trying to control the user.  Specifically, when the user navigates to the portrait-only view, the app is forcing the user to physically rotate the device in response to the app's whims.</p>\\n\\n<p>In short, given that you have a view controller that only supports portrait, you should design a portrait-only app.  If you don't want a portrait-only app, then you need to figure out how to support rotation on that last view controller.</p>\\n\"}],\"has_more\":false,\"quota_max\":300,\"quota_remaining\":239}";

static NSString *stringIsNotJSON = @"Fake JSON";
static NSString *noAnswersJSONString = @"{ \"noanswers\" : true }";

- (void)setUp
{
    [super setUp];
    answerBuilder = [[AnswerBuilder alloc] init];
    question = [[Question alloc] init];
    question.questionID = 24896953;
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    question = nil;
    answerBuilder = nil;
    [super tearDown];
}

- (void)testThatNilIsNotAcceptableParameter
{
    XCTAssertThrows([answerBuilder addAnswersToQuestion:nil fromJSON:answerJSON error:NULL], @"Lack of data should be handled elsewhere");
}

- (void)testThatNilJSONIsNotAnOption
{
    XCTAssertThrows([answerBuilder addAnswersToQuestion:question fromJSON:nil error:NULL], @"Empty answer's JSON should be dissallowed");
}

- (void)testThatSendingNonJSONIsAnError
{
    NSError *error = nil;
    XCTAssertFalse([answerBuilder addAnswersToQuestion:question fromJSON:stringIsNotJSON error:&error], @"Sending not JSON shouldn't add answers");
    XCTAssertEqualObjects([error domain], AnswerBuilderErrorDomain, @"This should be AnswerBuilderError");
}

- (void)testPassingNullErrorDoesNotCauseCrash
{
    XCTAssertNoThrow([answerBuilder addAnswersToQuestion:question fromJSON:stringIsNotJSON error:NULL], @"NULL error should be acceptable");
}

- (void)testJSONWithIncorrectKeysIsAnError
{
    NSError *error;
    XCTAssertFalse([answerBuilder addAnswersToQuestion:question fromJSON:noAnswersJSONString error:&error], @"JSON with no answers' array is an error");
}

- (void)testJSONWithRealAnswerIsNotError
{
    NSError *error;
    XCTAssertTrue([answerBuilder addAnswersToQuestion:question fromJSON:answerJSON error:&error], @"Answers from valid answer JSON should be added to a question");
    XCTAssertNil(error,@"No error should occur when valid answer JSON was passed");
}

- (void)testNumberOfAnswersAddedMatchNumberInData
{
    [answerBuilder addAnswersToQuestion:question fromJSON:answerJSON error:NULL];
    XCTAssertEqual([question.answers count], (NSUInteger)1, @"Number of answers in question should match the number of answers in JSON");
}

- (void)testAnswerPropertiesMatchThoseFromData
{
    [answerBuilder addAnswersToQuestion:question fromJSON:answerJSON error:NULL];
    Answer *answer = question.answers[0];
    XCTAssertEqual(answer.score, (NSInteger)1, @"Score should equal 1");
    XCTAssertEqual(answer.accepted, NO, @"Answer should be not accepted as in JSON data");
    XCTAssertEqualObjects(answer.text, @"<p>The real answer to the question is that good apps fall into one of three categories: portrait-only apps, landscape-only apps, and apps that support both orientations in all view controllers.  </p>\n\n<p>The UX design goal: the user controls the app, the app <strong>does not</strong> control the user.</p>\n\n<p>An app that has some view controllers that are portrait-only, and some view controllers that support rotation, is an app that is trying to control the user.  Specifically, when the user navigates to the portrait-only view, the app is forcing the user to physically rotate the device in response to the app's whims.</p>\n\n<p>In short, given that you have a view controller that only supports portrait, you should design a portrait-only app.  If you don't want a portrait-only app, then you need to figure out how to support rotation on that last view controller.</p>\n", @"Answer text should match answer's body from JSON data");
}

- (void)testAnswerIsProvidedByExpectedPerson
{
    [answerBuilder addAnswersToQuestion:question fromJSON:answerJSON error:NULL];
    Answer *answer = question.answers[0];
    Person *answerer = answer.person;
    XCTAssertEqualObjects(answerer.name, @"user3386109", @"Answerer name should match JSON data");
    XCTAssertEqualObjects([answerer.avatarURL absoluteString], @"http://i.stack.imgur.com/zt9UL.png?s=128&g=1", @"Answerer avatar URL should match profile image from JSON data");

}


@end
