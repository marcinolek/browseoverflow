//
//  TopicTableViewDataSource.m
//  BrowseOverflow
//
//  Created by Marcin Olek on 29.07.2014.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TopicTableDataSource.h"
#import "Topic.h"

@interface TopicTableDataSourceTests : XCTestCase {
    TopicTableDataSource *dataSource;
    NSArray *topicsList;
}
@end

@implementation TopicTableDataSourceTests

- (void)setUp
{
    [super setUp];
    dataSource = [[TopicTableDataSource alloc] init];
    Topic *topic = [[Topic alloc] initWithName:@"Sample topic" tag:@"ios"];
    topicsList = [NSArray arrayWithObject:topic];
    [dataSource setTopics:topicsList];
}

- (void)tearDown
{
    dataSource = nil;
    topicsList = nil;
    [super tearDown];
}

- (void)testThatTopicDataSourceCanReceiveAListOfTopics
{
       XCTAssertNoThrow([dataSource setTopics:topicsList], @"The data source needs a list of topics");
}

- (void)testOneTableRowPerOneTopic
{
    XCTAssertEqual((NSInteger)topicsList.count, [dataSource tableView:nil numberOfRowsInSection:0], @"As there's one topic, there should be one row in the table");
}

- (void)testTwoTableRowsPerTwoTopic
{
    Topic *otherTopic = [[Topic alloc] initWithName:@"Other topic" tag:@"ios"];
    NSArray *listOfTwoTopics = [topicsList arrayByAddingObject:otherTopic];
    [dataSource setTopics:listOfTwoTopics];
    XCTAssertEqual((NSInteger)listOfTwoTopics.count, [dataSource tableView:nil numberOfRowsInSection:0], @"Two topics in table means two rows in table view");

}

- (void)testOneSectionInTheTableView
{
    XCTAssertThrows([dataSource tableView:nil numberOfRowsInSection:1], @"Data source doesn't allow asking about additional secitons");
}

- (void)testDataSourceCellCreationExpectsOneSection
{
    NSIndexPath *secondSection = [NSIndexPath indexPathForRow:0 inSection:1];
    XCTAssertThrows([dataSource tableView:nil cellForRowAtIndexPath:secondSection], @"Data source will not prepare cells for unexpected secions");
}

- (void)testDataSourceCellCreationWillNotCreateMoreRowsThenItHasTopics
{
    NSIndexPath *afterLastTopic = [NSIndexPath indexPathForRow:topicsList.count inSection:0];
    XCTAssertThrows([dataSource tableView:nil cellForRowAtIndexPath:afterLastTopic], @"Data source will not prepare more cells than there are topics");
}

- (void)testCellCreatedByDataSourceContainsTopicTitleAsTextLabel
{
    NSIndexPath *firstTopic = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *firstCell = [dataSource tableView:nil cellForRowAtIndexPath:firstTopic];
    XCTAssertEqualObjects(@"Sample topic",firstCell.textLabel.text, @"Cell's title should be equal to the topic's title");
}

@end
