//
//  PersonsTests.m
//  BrowseOverflow
//
//  Created by Marcin Olek on 16.07.2014.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Person.h"

@interface PersonsTests : XCTestCase {
    Person *person;
}
@end

@implementation PersonsTests

- (void)setUp
{
    person = [[Person alloc] initWithName: @"Graham Lee" avatarLocation: @"http://example.com/avatar.png"];
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    person = nil;
    [super tearDown];
}

- (void)testThatPersonHasTheRightName
{
    XCTAssertEqualObjects(person.name, @"Graham Lee", @"expecting a person to provide its name");
}

- (void)testThatPersonHasAnAvatarURL {
    NSURL *url = person.avatarURL;
    XCTAssertEqualObjects([url absoluteString], @"http://example.com/avatar.png", @"The Person's avatar should be represented by URL");
}

@end
