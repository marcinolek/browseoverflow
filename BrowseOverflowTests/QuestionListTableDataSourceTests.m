//
//  QuestionListTableDataSourceTests.m
//  BrowseOverflow
//
//  Created by Marcin Olek on 30.07.2014.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "QuestionListTableDataSource.h"
#import "Topic.h"
#import "Question.h"
#import "Answer.h"
#import "Person.h"

@interface QuestionListTableDataSourceTests : XCTestCase

@end

@implementation QuestionListTableDataSourceTests {
    QuestionListTableDataSource *dataSource;
    Topic *iPhoneTopic;
    NSIndexPath *firstCell;
    Question *question1, *question2;
    Person *asker1;
}

- (void)setUp
{
    [super setUp];
    dataSource = [[QuestionListTableDataSource alloc] init];
    iPhoneTopic = [[Topic alloc] initWithName:@"iPhone" tag:@"iphone"];
    dataSource.topic = iPhoneTopic;
    firstCell = [NSIndexPath indexPathForRow:0 inSection:0];
    question1 = [Question new];
    question1.title = @"Question One";
    question1.score = 2;
    question2 = [Question new];
    question2.title = @"Question Two";
    asker1 = [[Person alloc] initWithName:@"Marcin Olek" avatarLocation:@"http://gravatar.com/userimage/54427651/aa2bea90f6a2bc5307fe12ecc4d697bf.jpg"];
    question1.asker = asker1;
}

- (void)testTopicWithNoQuestionsLeadsToOneRowInTheTable
{
    XCTAssertEqual([dataSource tableView:nil numberOfRowsInSection:0], (NSInteger)1, @"The table view needs a 'no data yet' placeholder cell");
}

- (void)testTopicWithQuestionsResultsInOneRowPerQuestionInTheTable
{
    [iPhoneTopic addQuestion:question1];
    [iPhoneTopic addQuestion:question2];
    XCTAssertEqual([dataSource tableView:nil numberOfRowsInSection:0], (NSInteger)2, @"Two questions in the topic means two rows in the table");
}

- (void)testContentOfPlaceholderCell
{
    UITableViewCell *placeholderCell = [dataSource tableView:nil cellForRowAtIndexPath:firstCell];
    XCTAssertEqualObjects(placeholderCell.textLabel.text, @"There was a problem connecting to the network.", @"The placeholder cell ought to display a placeholder message");
}

- (void)testPlaceholderCellNotReturnedWhenQuestionsExist
{
    [iPhoneTopic addQuestion:question1];
    UITableViewCell *placeholderCell = [dataSource tableView:nil cellForRowAtIndexPath:firstCell];
    XCTAssertTrue([placeholderCell.textLabel.text isEqualToString:@"There was a problem connecting to the network."], @"The placeholder cell should only be shown when there's no content");
}

- (void)testCellPropertiesAreTheSameAsTheQuestion
{
    [iPhoneTopic addQuestion:question1];
    QuestionSummaryCell *cell = (QuestionSummaryCell *) [dataSource tableView:nil cellForRowAtIndexPath:firstCell];
    XCTAssertEqualObjects(cell.titleLabel.text, @"Question One", @"Question cells display the question's title");
    XCTAssertEqualObjects(cell.scoreLabel.text, @"2", @"Question cells display the question's score");
    XCTAssertEqualObjects(cell.nameLabel.text, @"Marcin Olek", @"Question cells display the asker's name");
}

- (void)tearDown
{
    dataSource = nil;
    iPhoneTopic = nil;
    firstCell = nil;
    question1 = nil;
    question2 = nil;
    asker1 = nil;
    [super tearDown];
}


@end
