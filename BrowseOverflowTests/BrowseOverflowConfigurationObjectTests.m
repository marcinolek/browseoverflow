//
//  BrowseOverflowConfigurationObjectTests.m
//  BrowseOverflow
//
//  Created by jata on 01/08/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BrowseOverflowConfigurationObject.h"
#import "StackOverflowManager.h"

@interface BrowseOverflowConfigurationObjectTests : XCTestCase

@end

@implementation BrowseOverflowConfigurationObjectTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConfigurationOfCreatedStackOverflowManager
{
    BrowseOverflowConfigurationObject *configuration = [[BrowseOverflowConfigurationObject alloc] init];
    StackOverflowManager *manager = [configuration stackOverflowManager];
    XCTAssertNotNil(manager, @"The stackoverflow manager should exist");
    XCTAssertNotNil(manager.communicator, @"Manager should have a Stackoverflow communicatior");
    XCTAssertNotNil(manager.questionBuilder, @"Manager should have a question builder");
    XCTAssertNotNil(manager.answerBuilder, @"Manager should have an answer builder");
    XCTAssertEqualObjects(manager.communicator.delegate, manager, @"The manager is the communicator's delegate");
}

@end
