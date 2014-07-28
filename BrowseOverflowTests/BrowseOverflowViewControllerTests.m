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
#import "EmptyTableViewDataSource.h"
#import "EmptyTableViewDelegate.h"

@interface BrowseOverflowViewControllerTests : XCTestCase {
    BrowseOverflowViewController *viewController;
    UITableView *tableView;
}
@end

@implementation BrowseOverflowViewControllerTests

- (void)setUp
{
    [super setUp];
    viewController = [[BrowseOverflowViewController alloc] init];
    tableView = [[UITableView alloc] init];
    viewController.tableView = tableView;
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    viewController = nil;
    tableView = nil;
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
    id <UITableViewDataSource> dataSource = [[EmptyTableViewDataSource alloc] init];
    viewController.dataSource = dataSource;
    [viewController viewDidLoad];
    XCTAssertEqualObjects([tableView dataSource], dataSource, @"View controller should have set the table view's data source");
}

- (void)testViewControllerConnectsDelegateInViewDidLoad
{
    id <UITableViewDelegate> delegate = [[EmptyTableViewDelegate alloc] init];
    viewController.tableViewDelegate = delegate;
    [viewController viewDidLoad];
    XCTAssertEqualObjects([tableView delegate], delegate, @"View Controller should have set the table view's delegate");
}

@end
