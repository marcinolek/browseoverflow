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
#import "QuestionSummaryCell.h"
#import "AvatarStore.h"
#import "AvatarStore+TestingExtensions.h"
#import "FakeNotificationCenter.h"
#import "ReloadDataWatcher.h"
#import "BrowseOverflowViewController.h"

@interface QuestionListTableDataSourceTests : XCTestCase

@end

@implementation QuestionListTableDataSourceTests {
    QuestionListTableDataSource *dataSource;
    Topic *iPhoneTopic;
    NSIndexPath *firstCell;
    Question *question1, *question2;
    Person *asker1;
    AvatarStore *store;
    NSNotification *receivedNotification;

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
    store = [[AvatarStore alloc] init];
}

- (void)tearDown
{
    dataSource = nil;
    iPhoneTopic = nil;
    firstCell = nil;
    question1 = nil;
    question2 = nil;
    asker1 = nil;
    store = nil;
    receivedNotification = nil;
    [super tearDown];
}

- (void)didReceiveNotification:(NSNotification *)note
{
    receivedNotification = note;
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
    XCTAssertFalse([placeholderCell.textLabel.text isEqualToString:@"There was a problem connecting to the network."], @"The placeholder cell should only be shown when there's no content");
}

- (void)testCellPropertiesAreTheSameAsTheQuestion
{
    [iPhoneTopic addQuestion:question1];
    QuestionSummaryCell *cell = (QuestionSummaryCell *) [dataSource tableView:nil cellForRowAtIndexPath:firstCell];
    XCTAssertEqualObjects(cell.titleLabel.text, @"Question One", @"Question cells display the question's title");
    XCTAssertEqualObjects(cell.scoreLabel.text, @"2", @"Question cells display the question's score");
    XCTAssertEqualObjects(cell.nameLabel.text, @"Marcin Olek", @"Question cells display the asker's name");
}

#pragma mark Avatar retriever tests

- (void)testCellGetsImageFromAvatarStore
{
    dataSource.avatarStore = store;
    NSURL *imageURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"Marcin_Olek" withExtension:@"jpg"];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    [store setData:imageData forLocation:@"http://gravatar.com/userimage/54427651/aa2bea90f6a2bc5307fe12ecc4d697bf.jpg"];
    [iPhoneTopic addQuestion:question1];
    QuestionSummaryCell *cell = (QuestionSummaryCell *)[dataSource tableView:nil cellForRowAtIndexPath:firstCell];
    XCTAssertNotNil(cell.avatarView.image,@"The avatar store should supply the avatar image");
}

- (void)testQuestionListRegisteredForAvatarNotifications
{
    FakeNotificationCenter *center = [FakeNotificationCenter new];
    dataSource.notificationCenter = (NSNotificationCenter *)center;
    [dataSource registerForUpdatesToAvatarStore:store];
    XCTAssertTrue([center hasObject:dataSource forNotification:AvatarStoreDidUpdateContentNotification], @"The data source should no longer listen to avatar store notifications");
}

- (void)testQuestionListStopRegisteringForAvatarNotifications
{
    FakeNotificationCenter *center = [FakeNotificationCenter new];
    dataSource.notificationCenter = (NSNotificationCenter *)center;
    [dataSource registerForUpdatesToAvatarStore:store];
    [dataSource removeObservationOfUpdatesToAvatarStore:store];
    XCTAssertFalse([center hasObject:dataSource forNotification:AvatarStoreDidUpdateContentNotification], @"The data source should no longer listen to avatar store notifications");
}

- (void)testQuestionListCausesTableReloadOnAvatarNotification
{
    ReloadDataWatcher *fakeTableView = [[ReloadDataWatcher alloc] init];
    dataSource.tableView = (UITableView *)fakeTableView;
    [dataSource avatarStoreDidUpdateContent:nil];
    XCTAssertTrue([fakeTableView didReceiveReloadData], @"Data source should get the table view to reload when new data is available");
    
}

@end
