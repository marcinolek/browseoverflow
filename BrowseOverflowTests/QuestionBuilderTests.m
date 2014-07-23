//
//  QuestionBuilderTests.m
//  BrowseOverflow
//
//  Created by jata on 22/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "QuestionBuilder.h"
#import "Question.h"
#import "Person.h"

@interface QuestionBuilderTests : XCTestCase {
    QuestionBuilder *questionBuilder;
    Question *question;
}

@end

@implementation QuestionBuilderTests


static NSString *questionJSON = @"{\"items\":[{\"tags\":[\"iphone\",\"objective-c\",\"orientation\"],\"owner\":{\"reputation\":49,\"user_id\":3723298,\"user_type\":\"registered\",\"accept_rate\":80,\"profile_image\":\"https://www.gravatar.com/avatar/385dcd0e8e0d43057df27c2bcabf35d7?s=128&d=identicon&r=PG&f=1\",\"display_name\":\"turboc\",\"link\":\"http://stackoverflow.com/users/3723298/turboc\"},\"is_answered\":false,\"view_count\":7,\"answer_count\":0,\"score\":3,\"last_activity_date\":1406059927,\"creation_date\":1406059927,\"question_id\":24896953,\"link\":\"http://stackoverflow.com/questions/24896953/portrait-mode-on-one-view-controller\",\"title\":\"portrait mode on one view controller\"}],\"has_more\":true,\"quota_max\":300,\"quota_remaining\":288}";


- (void)setUp
{
    [super setUp];
    questionBuilder = [[QuestionBuilder alloc] init];
    question = [questionBuilder questionsFromJSON:questionJSON error:NULL][0];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    questionBuilder = nil;
    [super tearDown];
}

- (void)testThatNilIsNotAcceptableParameter
{
    XCTAssertThrows([questionBuilder questionsFromJSON:nil error:NULL], @"Lack of data should have been handled elsewhere");
}

- (void)testNilReturnedWhenStringIsNotJSON
{
    XCTAssertNil([questionBuilder questionsFromJSON:@"Not JSON" error:NULL], @"This parameter should not be parseable");
}

- (void)testErrorSetWhenStringIsNotJSON
{
    NSError *error = nil;
    [questionBuilder questionsFromJSON:@"Not JSON" error:&error];
    XCTAssertNotNil(error, @"An error occured, we should be told");
}

- (void)testPassingNullErrorDoesNotCauseCrash
{
    XCTAssertNoThrow([questionBuilder questionsFromJSON:@"Not JSON" error:NULL], @"Using a NULL error parameter should not be a problem");
}

- (void)testRealJSONWithoutQuestionsArrayIsError
{
    NSString *jsonString = @"{ \"noitems\": true }";
    XCTAssertNil([questionBuilder questionsFromJSON:jsonString error:NULL], @"No questions to pass in this JSON");
}

- (void)testRealJSONWithoutQuestionsReturnsMissingDataError
{
    NSString *jsonString = @"{ \"noitems\": true }";
    NSError *error = nil;
    [questionBuilder questionsFromJSON:jsonString error:&error];
    XCTAssertEqual([error code], QuestionBuilderMissingDataError, @"This case should not an invalid JSON error");
}

- (void)testJSONWithOneQuestionReturnsOneQuestionObject
{
    NSError *error = nil;
    NSArray *questions = [questionBuilder questionsFromJSON:questionJSON error:&error];
    XCTAssertEqual([questions count], (NSInteger)1, @"The builder should have created a question");
}

- (void)testQustionCreatedFromJSONHasPropertiesPresentedInJSON
{
    XCTAssertEqual(question.questionID, (NSUInteger)24896953, @"The question ID should match data we sent");
    XCTAssertEqual([question.date timeIntervalSince1970], (NSTimeInterval)1406059927,@"The date of the question should match the data");
    XCTAssertEqualObjects(question.title, @"portrait mode on one view controller", @"Title should match the provided data");
    XCTAssertEqual(question.score, 3, @"Score should match the data");
    Person *asker = question.asker;
    XCTAssertEqualObjects(asker.name, @"turboc", @"Looks like turboc should have asked this question");
    XCTAssertEqualObjects([asker.avatarURL absoluteString], @"https://www.gravatar.com/avatar/385dcd0e8e0d43057df27c2bcabf35d7?s=128&d=identicon&r=PG&f=1", @"The avatar URL should be based on the supplied email hash");
}

- (void)testQuestionCreatedFromEmptyObjectIsStillValidObject
{
    NSString *emptyQuestion = @"{ \"items\" : [ { } ] }";
    NSArray *questions = [questionBuilder questionsFromJSON:emptyQuestion error:NULL];
    XCTAssertEqual([questions count], (NSUInteger)0, @"QuestionBuilder must handle partial input");
}

- (void)testBuildingQuestionBodyWithNoDataCannotBeTried
{
    XCTAssertThrows([questionBuilder fillInDetailsForQuestion:question fromJSON:nil], @"Not receiving data should have been handled earlier");
}

- (void)testBuildingQuestionBodyWithNoQuestionCannotBeTried
{
    XCTAssertThrows([questionBuilder fillInDetailsForQuestion:nil fromJSON:questionJSON], @"Not receiving data should have been handled earlier");
}

- (void)testNonJSONDataDoesNotCauseABodyToBeAddedToAQuestion
{
    [questionBuilder fillInDetailsForQuestion:question fromJSON:stringIsNotJSON];
    XCTAssertNil(question.body, @"Body should not have been added");
}

- (void)testJSONWhichDoesNotContainABodyDoesNotCauseBodyToBeAdded
{
    [questionBuilder fillInDetailsForQuestion:question fromJSON:noQuestionsJSONSTring];
    XCTAssertNil(question.body, @"There as no body to add");
}

- (void)testBodyContainedInJSONIsAddedToQuestion
{
    XCTAssertEqualObjects(question.body, @"<p>I've been trying to use persistent keychain references</p>", @"The correct question body is added");
}



@end
