//
//  QuestionCreationTests.m
//  BrowseOverflow
//
//  Created by jata on 21/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StackOverflowManager.h"
#import "MockStackOverflowManagerDelegate.h"
#import "MockStackOverflowCommunicator.h"
#import "Topic.h"
#import "FakeQuestionBuilder.h"

@interface QuestionCreationTests : XCTestCase

@end

@implementation QuestionCreationTests
{
@private
    StackOverflowManager *mgr;
    MockStackOverflowManagerDelegate *delegate;
    NSError *underlyingError;
    NSArray *questionArray;
    FakeQuestionBuilder *questionBuilder;
}

- (void)setUp
{
    [super setUp];
    mgr = [[StackOverflowManager alloc] init];
    delegate = [[MockStackOverflowManagerDelegate alloc] init];
    mgr.delegate = delegate;
    underlyingError = [NSError errorWithDomain:@"Test domain" code:0 userInfo:nil];
    Question *question = [[Question alloc] init];
    questionArray = [NSArray arrayWithObject:question];
    questionBuilder = [[FakeQuestionBuilder alloc] init];
    mgr.questionBuilder = questionBuilder;
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    mgr = nil;
    delegate = nil;
    underlyingError = nil;
    questionArray = nil;
    questionBuilder = nil;
    [super tearDown];
}

- (void)testNonConformingObjectCannotBeDelegate
{
    XCTAssertThrows(mgr.delegate = (id <StackOverflowManagerDelegate>)[NSNull null], @"NSNull should not be used as the delegate"
                    @" as doesn't conform to the delegate protocol");
}

- (void)testConfirmingObjectCanBeDelegate
{
    XCTAssertNoThrow(mgr.delegate = delegate, @"Object conforming to the delegate protocol should be used"
                     @" as the delegate");
}

- (void)testManagerAcceptsNilAsADelegate
{
    XCTAssertNoThrow(mgr.delegate = nil, @"It should be acceptable to use nil as an object's delegate");
}

- (void)testAskingForQuestionMeansRequestingData
{
    MockStackOverflowCommunicator *communicatior = [[MockStackOverflowCommunicator alloc] init];
    mgr.communicator = communicatior;
    Topic *topic = [[Topic alloc] initWithName:@"iPhone" tag:@"iPhone"];
    [mgr fetchQuestionsOnTopic:topic];
    XCTAssertTrue([communicatior wasAskedToFetchQuestions], @"The communicator should need to fetch data");
}

- (void)testErrorReturnedToDelegateIsNotErrorNotifiedByCommunicator
{
    mgr.delegate = delegate;
    [mgr searchingForQuestionsFailedWithError:underlyingError];
    XCTAssertFalse(underlyingError == [delegate fetchError],@"Error should be at the correct level of abstraction" );
    
}

- (void)testErrorReturnedToDelegateDocumentsUnderlyingError
{
    [mgr searchingForQuestionsFailedWithError:underlyingError];
    XCTAssertEqualObjects([[[delegate fetchError] userInfo]objectForKey:NSUnderlyingErrorKey], underlyingError, @"The underlying error should be available to client code");
}

- (void)testQuestionJSONIsPassedToQuestionBuilder
{
    [mgr receivedQuestionsJSON:@"Fake JSON"];
    XCTAssertEqualObjects(questionBuilder.JSON, @"Fake JSON",@"Downloaded JSON is sent to question builder");
}

- (void)testDelegateNotifiedOfErrorWhenQuestionBuilderFails
{
    questionBuilder.arrayToReturn = nil;
    questionBuilder.errorToSet = underlyingError;
    [mgr receivedQuestionsJSON:@"Fake JSON"];
    XCTAssertNotNil([[[delegate fetchError] userInfo] objectForKey:NSUnderlyingErrorKey], @"The delegate should have found about the error");
}

- (void)testDelegateNotToldAboutErrorWhenQuestionsReceived
{
    questionBuilder.arrayToReturn = questionArray;
    [mgr receivedQuestionsJSON:@"Fake JSON"];
    XCTAssertNil([delegate fetchError], @"No error should be received on success");
}

- (void)testDelegateReceivesTheQuestionsDiscoveredByManager
{
    questionBuilder.arrayToReturn = questionArray;
    [mgr receivedQuestionsJSON:@"Fake JSON"];
    XCTAssertEqualObjects([delegate receivedQuestions], questionArray,@"The manager should have sent its questions to the delegate");
}

- (void)testEmptyArrayIsPassedToDelegate
{
    questionBuilder.arrayToReturn = [[NSArray alloc] init];
    [mgr receivedQuestionsJSON:@"Fake JSON"];
    XCTAssertEqualObjects([delegate receivedQuestions], [NSArray array], @"Returning empty array is not an error");
}

@end
