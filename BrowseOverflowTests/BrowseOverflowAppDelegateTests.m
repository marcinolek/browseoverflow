//
//  BrowseOverflowAppDelegateTests.m
//  BrowseOverflow
//
//  Created by jata on 01/08/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AppDelegate.h"
#import "BrowseOverflowViewController.h"
#import "TopicTableDataSource.h"

@interface BrowseOverflowAppDelegateTests : XCTestCase

@end

@implementation BrowseOverflowAppDelegateTests
{
    UINavigationController *navigationController;
    AppDelegate *appDelegate;
    UIWindow *window;
}

- (void)setUp
{
    [super setUp];
    navigationController = [[UINavigationController alloc] init];
    window = [[UIWindow alloc] init];
    window.rootViewController = navigationController;
    [window makeKeyAndVisible];
    appDelegate = [[AppDelegate alloc] init];
    appDelegate.window = window;
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    navigationController = nil;
    appDelegate = nil;
    [super tearDown];
}

- (void)testAppDidFinishLaunchingReturnsYES
{
    XCTAssertTrue([appDelegate application:nil didFinishLaunchingWithOptions:nil], @"Method should always return yes");
}

- (void)testNavigationControllerShowsABrowseOverflowViewController
{
    [appDelegate application:nil didFinishLaunchingWithOptions:nil];
    navigationController = (UINavigationController *)appDelegate.window.rootViewController;
    NSObject *topVC = navigationController.topViewController;
    XCTAssertTrue([topVC isKindOfClass:[BrowseOverflowViewController class]], @"Views in this app are supplied by BrowseOverflowViewControllers");
}

- (void)testFirstViewControllerHasATopicTableDataSource
{
    [appDelegate application:nil didFinishLaunchingWithOptions:nil];
    navigationController = (UINavigationController *)appDelegate.window.rootViewController;
    BrowseOverflowViewController *topVC = (BrowseOverflowViewController *) navigationController.topViewController;
    XCTAssertTrue([topVC.dataSource isKindOfClass:[TopicTableDataSource class]], @"First view should display a list of topics");
}

- (void)testTopicListIsNotEmptyOnAppLaunch
{
    [appDelegate application:nil didFinishLaunchingWithOptions:nil];
    navigationController = (UINavigationController *)appDelegate.window.rootViewController;
    BrowseOverflowViewController *topVC = (BrowseOverflowViewController *) navigationController.topViewController;
    id <UITableViewDataSource> dataSource = topVC.dataSource;
    XCTAssertFalse([dataSource tableView:nil numberOfRowsInSection:0] == 0 , @"There should be some rows to display");
}

- (void)testFirstViewControllerHasAnObjectConfiguration
{
    [appDelegate application:nil didFinishLaunchingWithOptions:nil];
    navigationController = (UINavigationController *)appDelegate.window.rootViewController;
    BrowseOverflowViewController *topVC = (BrowseOverflowViewController *) navigationController.topViewController;
    XCTAssertNotNil(topVC.objectConfiguration, @"The view controller should have an object configuration instance");
}

@end
