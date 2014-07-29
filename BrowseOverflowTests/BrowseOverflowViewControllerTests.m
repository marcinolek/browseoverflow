//
//  BrowseOverflowViewControllerTests.m
//  BrowseOverflow
//
//  Created by jata on 28/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BrowseOverflowViewController.h"
#import <objc/runtime.h>
#import "TopicTableDataSource.h"
#import "TopicTableDelegate.h"

@interface BrowseOverflowViewControllerTests : XCTestCase {
    BrowseOverflowViewController *viewController;
    UITableView *tableView;
    id<UITableViewDataSource> dataSource;
    TopicTableDelegate *delegate;
}
@end

@implementation BrowseOverflowViewControllerTests

- (void)setUp
{
    [super setUp];
    viewController = [[BrowseOverflowViewController alloc] init];
    tableView = [[UITableView alloc] init];
    viewController.tableView = tableView;
    delegate = [[TopicTableDelegate alloc] init];
    viewController.dataSource = dataSource;
    viewController.tableViewDelegate = delegate;
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    viewController = nil;
    tableView = nil;
    dataSource = nil;
    [super tearDown];
}

- (void)testViewControllerHasATableViewProperty
{
    objc_property_t tableViewProperty = class_getProperty([viewController class], "tableView");
    XCTAssertTrue(tableViewProperty != NULL, @"BrowseOverflowViewController needs a table view");
}

- (void)testViewControllerHasADataSourceProperty
{
    objc_property_t dataSourceProperty = class_getProperty([viewController class], "dataSource");
    XCTAssertTrue(dataSourceProperty != NULL, @"View Controller needs a data source");
}

- (void)testViewControllerHasATableViewDelegateProperty
{
    objc_property_t delegateProperty = class_getProperty([viewController class], "tableViewDelegate");
    XCTAssertTrue(delegateProperty != NULL, @"View Controller needs a table view delegate");
}

- (void)testViewControllerConnectsDataSourceInViewDidLoad
{
    [viewController viewDidLoad];
    XCTAssertEqualObjects([tableView dataSource], dataSource, @"View controller should have set the table view's data source");
}

- (void)testViewControllerConnectsDelegateInViewDidLoad
{
    [viewController viewDidLoad];
    XCTAssertEqualObjects([tableView delegate], delegate, @"View Controller should have set the table view's delegate");
}

- (void)testViewControllerConnectsDataSourceToDelegate
{
    [viewController viewDidLoad];
    XCTAssertEqualObjects(delegate.tableDataSource, dataSource, @"The view controller should tell the table view delegate about its data source");
}

@end
