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
#import "AvatarStore.h"
#import "AvatarStore+TestingExtensions.h"

@interface BrowseOverflowConfigurationObjectTests : XCTestCase

@end

@implementation BrowseOverflowConfigurationObjectTests
{
    BrowseOverflowConfigurationObject *configuration;
}
- (void)setUp
{
    [super setUp];
    configuration = [[BrowseOverflowConfigurationObject alloc] init];

    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    configuration = nil;
    [super tearDown];
}

- (void)testConfigurationOfCreatedStackOverflowManager
{
    StackOverflowManager *manager = [configuration stackOverflowManager];
    XCTAssertNotNil(manager, @"The stackoverflow manager should exist");
    XCTAssertNotNil(manager.communicator, @"Manager should have a Stackoverflow communicatior");
    XCTAssertNotNil(manager.questionBuilder, @"Manager should have a question builder");
    XCTAssertNotNil(manager.answerBuilder, @"Manager should have an answer builder");
    XCTAssertEqualObjects(manager.communicator.delegate, manager, @"The manager is the communicator's delegate");
}

- (void)testConfigurationOfCreatedAvatarStore
{
    AvatarStore *store = [configuration avatarStore];
    XCTAssertEqualObjects([store notificationCenter], [NSNotificationCenter defaultCenter], @"Configured AvatarStore posts notifications to the default center");
}

- (void)testSameAvatarStoreIsAlwaysReturned
{
    AvatarStore *store1 = [configuration avatarStore];
    AvatarStore *store2 = [configuration avatarStore];
    XCTAssertEqualObjects(store1, store2, @"The same store should always be used");
}

@end
