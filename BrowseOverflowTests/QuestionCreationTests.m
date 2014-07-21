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

@interface QuestionCreationTests : XCTestCase

@end

@implementation QuestionCreationTests
{
@private
    StackOverflowManager *mgr;
}

- (void)setUp
{
    [super setUp];
    mgr = [[StackOverflowManager alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    mgr = nil;
    [super tearDown];
}

- (void)testNonConformingObjectCannotBeDelegate
{
    XCTAssertThrows(mgr.delegate = (id <StackOverflowManagerDelegate>)[NSNull null], @"NSNull should not be used as the delegate"
                    @" as doesn't conform to the delegate protocol");
}

- (void)testConfirmingObjectCanBeDelegate
{
    id<StackOverflowManagerDelegate> delegate = [[MockStackOverflowManagerDelegate alloc] init];
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
    MockStackOverflowManagerDelegate *delegate = [[MockStackOverflowManagerDelegate alloc] init];
    mgr.delegate = delegate;
    NSError *underlyingError = [NSError errorWithDomain:@"Test domain" code:0 userInfo:nil];
    [mgr searchingForQuestionsFailedWithError:underlyingError];
    XCTAssertFalse(underlyingError == [delegate fetchError],@"Error should be at the correct level of abstraction" );
    
}

- (void)testErrorReturnedToDelegateDocumentsUnderlyingError
{
    MockStackOverflowManagerDelegate *delegate = [[MockStackOverflowManagerDelegate alloc] init];
    mgr.delegate = delegate;
    NSError *underlyingError = [NSError errorWithDomain:@"Test domain" code:0 userInfo:nil];
    [mgr searchingForQuestionsFailedWithError:underlyingError];
    XCTAssertEqualObjects([[[delegate fetchError] userInfo]objectForKey:NSUnderlyingErrorKey], underlyingError, @"The underlying error should be available to client code");
}

@end
