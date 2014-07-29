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

@interface BrowseOverflowViewControllerTests : XCTestCase {
    BrowseOverflowViewController *viewController;
    UITableView *tableView;
    id<UITableViewDataSource,UITableViewDelegate> dataSource;
    SEL realViewDidAppear, testViewDidAppear;
    SEL realViewWillDisappear, testViewWillDisappear;
}
@end

static const char *notificationKey = "BrowseOverflowViewControllerTestsAssociatedNotificationKey";
static const char *viewDidAppearKey = "BrowseOverflowViewControllerTestsViewDidAppearKey";
static const char *viewWillDissapearKey = "BrowseOverflowViewControllerViewWillDissapearKey";
@implementation BrowseOverflowViewController (TestNotificationDelivery)
- (void)userDidSelectTopicNotification:(NSNotification *)note
{
    objc_setAssociatedObject(self, notificationKey, note, OBJC_ASSOCIATION_RETAIN);
}

@end

@implementation UIViewController (TestSuperClassCalled)

- (void)browseOverflowViewControllerTests_viewDidAppear:(BOOL)animated
{
    NSNumber *parameter = [NSNumber numberWithBool:animated];
    objc_setAssociatedObject(self, viewDidAppearKey, parameter, OBJC_ASSOCIATION_RETAIN);
}

- (void)browseOverflowViewControllerTests_viewWillDisappear:(BOOL)animated
{
    NSNumber *parameter = [NSNumber numberWithBool:animated];
    objc_setAssociatedObject(self, viewWillDissapearKey, parameter, OBJC_ASSOCIATION_RETAIN);
}

@end

@implementation BrowseOverflowViewControllerTests


+ (void)swapInstanceMethodsForClass:(Class)cls selector:(SEL)sel1 andSelector:(SEL)sel2
{
    Method method1 = class_getInstanceMethod(cls, sel1);
    Method method2 = class_getInstanceMethod(cls, sel2);
    method_exchangeImplementations(method1, method2);
    
}

- (void)setUp
{
    [super setUp];
    viewController = [[BrowseOverflowViewController alloc] init];
    tableView = [[UITableView alloc] init];
    viewController.tableView = tableView;
    dataSource = [[TopicTableDataSource alloc] init];
    viewController.dataSource = dataSource;
    objc_removeAssociatedObjects(viewController);
    realViewDidAppear = @selector(viewDidAppear:);
    testViewDidAppear = @selector(browseOverflowViewControllerTests_viewDidAppear:);
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[UIViewController class] selector:realViewDidAppear andSelector:testViewDidAppear];
    realViewWillDisappear = @selector(viewWillDisappear:);
    testViewWillDisappear = @selector(browseOverflowViewControllerTests_viewWillDisappear:);
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[UIViewController class] selector:realViewWillDisappear andSelector:testViewWillDisappear];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    viewController = nil;
    tableView = nil;
    dataSource = nil;
    objc_removeAssociatedObjects(viewController);
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[UIViewController class] selector:realViewWillDisappear andSelector:testViewWillDisappear];
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[UIViewController class] selector:realViewDidAppear andSelector:testViewDidAppear];
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


- (void)testViewControllerConnectsDataSourceInViewDidLoad
{
    [viewController viewDidLoad];
    XCTAssertEqualObjects([tableView dataSource], dataSource, @"View controller should have set the table view's data source");
}

- (void)testViewControllerConnectsDelegateInViewDidLoad
{
    [viewController viewDidLoad];
    XCTAssertEqualObjects([tableView delegate], viewController.dataSource, @"View Controller should have set the table view's delegate");
}

- (void)testDefaultStateOfViewControllerDoesNotReceiveNotifications
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TopicTableDidSelectTopicNotification object:nil userInfo:nil];
    XCTAssertNil(objc_getAssociatedObject(viewController, notificationKey), @"Notification should not be received before -viewDidAppear:");
}

- (void)testViewControllerReceivesTableSelectionNotificationAfterViewDidApper
{
    [viewController viewDidAppear:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:TopicTableDidSelectTopicNotification object:nil userInfo:nil];
    XCTAssertNotNil(objc_getAssociatedObject(viewController, notificationKey), @"After -viewDidAppear: the view controller should handle selection notification");
}

- (void)testViewControllerDoesNotReceiveTableSelectionNotificationAfterViewWillDisapear
{
    [viewController viewDidAppear:NO];
    [viewController viewWillDisappear:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:TopicTableDidSelectTopicNotification object:nil userInfo:nil];
    XCTAssertNil(objc_getAssociatedObject(viewController, notificationKey), @"After -viewWillDissapear: is called, the view controller should no longer respond to topic selection notification");
}

- (void)testViewControllerCallsSuperViewDidAppear
{
    [viewController viewDidAppear:NO];
    XCTAssertNotNil(objc_getAssociatedObject(viewController, viewDidAppearKey), @"-viewDidAppear: should call through to superclass implementation");
}

- (void)testViewControllerCallsSuperViewWillDisappear
{
    [viewController viewWillDisappear:NO];
    XCTAssertNotNil(objc_getAssociatedObject(viewController, viewWillDissapearKey), @"-viewWillDisappear: should call through to superclass implementation");
}

@end
