//
//  StackOVerflowCommunicatorTests.m
//  BrowseOverflow
//
//  Created by jata on 27/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "InspectableStackOverflowCommunicator.h"
#import "NonNetworkedStackOVerflowCommunicator.h"
#import "MockStackOverflowManager.h"
#import "FakeURLResponse.h"

@interface StackOVerflowCommunicatorTests : XCTestCase {
    InspectableStackOverflowCommunicator *communicator;
    NonNetworkedStackOVerflowCommunicator *nnCommunicator;
    MockStackOverflowManager *manager;
    FakeURLResponse *fourOhFourResponse;
    NSData *receivedData;
}

@end

@implementation StackOVerflowCommunicatorTests

- (void)setUp
{
    [super setUp];
    communicator = [[InspectableStackOverflowCommunicator alloc] init];
    nnCommunicator = [[NonNetworkedStackOVerflowCommunicator alloc] init];
    manager = [[MockStackOverflowManager alloc] init];
    nnCommunicator.delegate = manager;
    fourOhFourResponse = [[FakeURLResponse alloc] initWithStatusCode:404];
    receivedData = [@"Result" dataUsingEncoding:NSUTF8StringEncoding];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    communicator = nil;
    nnCommunicator = nil;
    manager = nil;
    fourOhFourResponse = nil;
    receivedData = nil;
    [super tearDown];
}

- (void)testSearchingForQuestionsOnTopicCallsTopicAPI
{
    [communicator searchForQuestionsWithTag:@"ios"];
    XCTAssertEqualObjects([[communicator URLToFetch] absoluteString], @"https://api.stackexchange.com/2.2/search?tagged=ios&pagesize=20&site=stackoverflow", @"Use the search API to find questions with a particular tag");
}

- (void)testFillingInQuestionBodyCallsQuestionAPI
{
    [communicator downloadInformationForQuestionWithID: 12345];
    XCTAssertEqualObjects([[communicator URLToFetch] absoluteString], @"http://api.stackexchange.com/2.2/questions/12345?site=stackoverflow&filter=!9YdnSJBlX", @"Use the question API to get the body for a question");
}

- (void)testFetchingAnswersToQuestionCallsQuestionAPI
{
    [communicator downloadAnswersToQuestionWithID: 12345];
    XCTAssertEqualObjects([[communicator URLToFetch] absoluteString], @"http://api.stackexchange.com/2.2/questions/12345/answers?site=stackoverflow&filter=!9YdnSK0R1", @"Use the question API to get answers on a given question");
}

- (void)testSearchingForQuestionCreatesURLConnection
{
    [communicator searchForQuestionsWithTag:@"ios"];
    XCTAssertNotNil([communicator currentURLConnection], @"There should be a URL connection in-flight now");
    [communicator cancelAndDiscardURLConnection];
}

- (void)testStartingNewSearchThrowsOutOldConnection
{
    [communicator searchForQuestionsWithTag:@"ios"];
    NSURLConnection *firstConnection = [communicator currentURLConnection];
    [communicator searchForQuestionsWithTag:@"cocoa"];
    XCTAssertFalse([[communicator currentURLConnection] isEqual:firstConnection], @"The communicator needs to replace its URL connection to start a new one");
    [communicator cancelAndDiscardURLConnection];
}

- (void)testReceivingResponseDiscardsExistingData
{
    nnCommunicator.receivedData = [@"Hello" dataUsingEncoding:NSUTF8StringEncoding];
    [nnCommunicator searchForQuestionsWithTag:@"ios"];
    [nnCommunicator connection:nil didReceiveResponse:nil];
    XCTAssertEqual([[nnCommunicator receivedData]length], (NSUInteger)0, @"Data should have been discarded");
}

- (void)testReceivingResponseWith404StatusPassesErrorToDelegate
{
    [nnCommunicator searchForQuestionsWithTag:@"ios"];
    [nnCommunicator connection:nil didReceiveResponse:(NSURLResponse *)fourOhFourResponse];
    XCTAssertEqual([manager topicFailureErrorCode], 404, @"Fetch failure was passed through to delegate");
}

- (void)testNoErrorReceivedOn200Status
{
    FakeURLResponse *twoHundredResponse = [[FakeURLResponse alloc] initWithStatusCode:200];
    [nnCommunicator searchForQuestionsWithTag:@"ios"];
    [nnCommunicator connection:nil didReceiveResponse:(NSURLResponse *)twoHundredResponse];
    XCTAssertFalse([manager topicFailureErrorCode] == 200, @"No need for error on 200 response");
}

- (void)testConnectionFailingPassesErrorToDelegate
{
    [nnCommunicator searchForQuestionsWithTag:@"ios"];
    NSError *error = [NSError errorWithDomain:@"Fake domain" code:12345 userInfo:nil];
    [nnCommunicator connection:nil didFailWithError:error];
    XCTAssertEqual([manager topicFailureErrorCode], 12345, @"Failure to connect should get passed to the delegate");
}

- (void)testSuccessfulQuestionSearchPassesDataToDelegate
{
    [nnCommunicator searchForQuestionsWithTag:@"ios"];
    nnCommunicator.receivedData = receivedData;
    [nnCommunicator connectionDidFinishLoading:nil];
    XCTAssertEqualObjects([manager topicSearchString], @"Result", @"The delegate should have received data on success");
}

- (void)testAdditionalDataAppendedToDownload
{
    [nnCommunicator setReceivedData:receivedData];
    NSData *extraData = [@" appended" dataUsingEncoding:NSUTF8StringEncoding];
    [nnCommunicator connection:nil didReceiveData:extraData];
    NSString *combinedString = [[NSString alloc] initWithData:[nnCommunicator receivedData] encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(combinedString, @"Result appended", @"Received data should be appended to download data");
}

@end
