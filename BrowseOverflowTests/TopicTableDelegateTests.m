//
//  TopicTableDelegateTests.m
//  BrowseOverflow
//
//  Created by jata on 29/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TopicTableDataSource.h"
#import "TopicTableDelegate.h"
#import "Topic.h"

@interface TopicTableDelegateTests : XCTestCase

@end

@implementation TopicTableDelegateTests {
    NSNotification *receivedNotification;
    TopicTableDataSource *dataSource;
    TopicTableDelegate *delegate;
    Topic *iPhoneTopic;
    
}

- (void)setUp
{
    [super setUp];
    delegate = [[TopicTableDelegate alloc] init];
    dataSource = [[TopicTableDataSource alloc] init];
    iPhoneTopic = [[Topic alloc] initWithName:@"iPhone" tag:@"iphone"];
    [dataSource setTopics:@[iPhoneTopic]];
    delegate.tableDataSource = dataSource;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:TopicTableDidSelectTopicNotification object:nil];
}

- (void)didReceiveNotification:(NSNotification *)note
{
    receivedNotification = note;
}

- (void)testDelegatePostsNotificationOnSelectionShowingWhichTopicWasSelected
{
    NSIndexPath *selection = [NSIndexPath indexPathForRow:0 inSection:0];
    [delegate tableView:nil didDeselectRowAtIndexPath:selection];
    XCTAssertEqualObjects([receivedNotification name], TopicTableDidSelectTopicNotification, @"The delegate should notify that a topic was selected");
    XCTAssertEqualObjects([receivedNotification object], iPhoneTopic, @"The notification should indicate which topic was selected");
}

- (void)tearDown
{
    receivedNotification = nil;
    dataSource = nil;
    delegate = nil;
    iPhoneTopic = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TopicTableDidSelectTopicNotification object:nil];
    [super tearDown];
}

@end
