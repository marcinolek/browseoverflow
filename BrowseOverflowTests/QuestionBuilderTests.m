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

@interface QuestionBuilderTests : XCTestCase {
    QuestionBuilder *questionBuilder;
    Question *question;
}

@end

@implementation QuestionBuilderTests


static NSString *questionJSON = @"{\"items\":[{\"tags\":[\"iphone\",\"objective-c\",\"orientation\"],\"owner\":{\"reputation\":49,\"user_id\":3723298,\"user_type\":\"registered\",\"accept_rate\":80,\"profile_image\":\"https://www.gravatar.com/avatar/385dcd0e8e0d43057df27c2bcabf35d7?s=128&d=identicon&r=PG&f=1\",\"display_name\":\"turboc\",\"link\":\"http://stackoverflow.com/users/3723298/turboc\"},\"is_answered\":false,\"view_count\":7,\"answer_count\":0,\"score\":0,\"last_activity_date\":1406059927,\"creation_date\":1406059927,\"question_id\":24896953,\"link\":\"http://stackoverflow.com/questions/24896953/portrait-mode-on-one-view-controller\",\"title\":\"portrait mode on one view controller\"}],\"has_more\":true,\"quota_max\":300,\"quota_remaining\":288}";


- (void)setUp
{
    [super setUp];
    question = [questionBuilder questionsFromJSON:questionJSON error:NULL][0];
    questionBuilder = [[QuestionBuilder alloc] init];
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

@end
