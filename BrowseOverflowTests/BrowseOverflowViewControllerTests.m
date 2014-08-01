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
#import "Topic.h"
#import "QuestionListTableDataSource.h"
#import "QuestionDetailDataSource.h"
#import "BrowseOverflowConfigurationObject.h"
#import "TestObjectConfiguration.h"
#import "MockStackOverflowManager.h"

@interface BrowseOverflowViewControllerTests : XCTestCase {
    BrowseOverflowViewController *viewController;
    UITableView *tableView;
    id<UITableViewDataSource,UITableViewDelegate> dataSource;
    SEL realViewDidAppear, testViewDidAppear;
    SEL realViewWillDisappear, testViewWillDisappear;
    SEL realUserDidSelectTopic, testUserDidSelectTopic;
    SEL realUserDidSelectQuestion, testUserDidSelectQuestion;
    UINavigationController *navController;
    BrowseOverflowConfigurationObject *objectConfiguration;
}
@end

static const char *notificationKey = "BrowseOverflowViewControllerTestsAssociatedNotificationKey";
static const char *viewDidAppearKey = "BrowseOverflowViewControllerTestsViewDidAppearKey";
static const char *viewWillDissapearKey = "BrowseOverflowViewControllerViewWillDissapearKey";

@implementation BrowseOverflowViewController (TestNotificationDelivery)

- (void)browseOverflowViewController_userDidSelectTopicNotification:(NSNotification *)note
{
    objc_setAssociatedObject(self, notificationKey, note, OBJC_ASSOCIATION_RETAIN);
}

- (void)browseOverflowViewController_userDidSelectQuestionNotification:(NSNotification *)note
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
    objectConfiguration = [[BrowseOverflowConfigurationObject alloc] init];
    viewController.objectConfiguration = objectConfiguration;
    objc_removeAssociatedObjects(viewController);
    realViewDidAppear = @selector(viewDidAppear:);
    testViewDidAppear = @selector(browseOverflowViewControllerTests_viewDidAppear:);
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[UIViewController class] selector:realViewDidAppear andSelector:testViewDidAppear];
    realViewWillDisappear = @selector(viewWillDisappear:);
    testViewWillDisappear = @selector(browseOverflowViewControllerTests_viewWillDisappear:);
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[UIViewController class] selector:realViewWillDisappear andSelector:testViewWillDisappear];
    realUserDidSelectTopic = @selector(userDidSelectTopicNotification:);
    realUserDidSelectQuestion = @selector(userDidSelectQuestionNotification:);
    testUserDidSelectTopic = @selector(browseOverflowViewController_userDidSelectTopicNotification:);
    testUserDidSelectQuestion = @selector(browseOverflowViewController_userDidSelectQuestionNotification:);
    navController = [[UINavigationController alloc] initWithRootViewController:viewController];
}

- (void)tearDown
{
    viewController = nil;
    tableView = nil;
    dataSource = nil;
    objc_removeAssociatedObjects(viewController);
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[UIViewController class] selector:realViewWillDisappear andSelector:testViewWillDisappear];
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[UIViewController class] selector:realViewDidAppear andSelector:testViewDidAppear];
    navController = nil;
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
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[BrowseOverflowViewController class] selector:realUserDidSelectTopic andSelector:testUserDidSelectTopic];
    [[NSNotificationCenter defaultCenter] postNotificationName:TopicTableDidSelectTopicNotification object:nil userInfo:nil];
    XCTAssertNil(objc_getAssociatedObject(viewController, notificationKey), @"Notification should not be received before -viewDidAppear:");
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[BrowseOverflowViewController class] selector:realUserDidSelectTopic andSelector:testUserDidSelectTopic];
}

- (void)testViewControllerReceivesTableSelectionNotificationAfterViewDidApper
{
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[BrowseOverflowViewController class] selector:realUserDidSelectTopic andSelector:testUserDidSelectTopic];
    [viewController viewDidAppear:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:TopicTableDidSelectTopicNotification object:nil userInfo:nil];
    XCTAssertNotNil(objc_getAssociatedObject(viewController, notificationKey), @"After -viewDidAppear: the view controller should handle selection notification");
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[BrowseOverflowViewController class] selector:realUserDidSelectTopic andSelector:testUserDidSelectTopic];
}

- (void)testViewControllerDoesNotReceiveTableSelectionNotificationAfterViewWillDisapear
{
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[BrowseOverflowViewController class] selector:realUserDidSelectTopic andSelector:testUserDidSelectTopic];
    [viewController viewDidAppear:NO];
    [viewController viewWillDisappear:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:TopicTableDidSelectTopicNotification object:nil userInfo:nil];
    XCTAssertNil(objc_getAssociatedObject(viewController, notificationKey), @"After -viewWillDissapear: is called, the view controller should no longer respond to topic selection notification");
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[BrowseOverflowViewController class] selector:realUserDidSelectTopic andSelector:testUserDidSelectTopic];
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

- (void)testSelectingTopicPushesNewViewController
{
    [viewController userDidSelectTopicNotification:nil];
    UIViewController *currentTopVC = navController.topViewController;
    XCTAssertFalse([currentTopVC isEqual:viewController], @"New view should be pushed onto the stack");
    XCTAssertTrue([currentTopVC isKindOfClass:[BrowseOverflowViewController class]], @"New view controller should be a BrowseOverflowViewController");
}

- (void)testNewViewControllerHasAQuestionListDataSourceForTheSelectedTopic
{
    Topic *iphoneTopic = [[Topic alloc] initWithName:@"iPhone" tag:@"iphone"];
    NSNotification *iPhoneTopicSelectedNotification = [NSNotification notificationWithName:TopicTableDidSelectTopicNotification object:iphoneTopic];
    [viewController userDidSelectTopicNotification:iPhoneTopicSelectedNotification];
    BrowseOverflowViewController *nextViewController = (BrowseOverflowViewController *)navController.topViewController;
    XCTAssertTrue([nextViewController.dataSource isKindOfClass:[QuestionListTableDataSource class]], @"Selecting a topic should push a list of questions");
    XCTAssertEqualObjects([(QuestionListTableDataSource *)nextViewController.dataSource topic], iphoneTopic, @"The questions to display should come from the selected topic");
}

- (void)testViewControllerConnectsTableViewBacklinkInViewDidLoad
{
    QuestionListTableDataSource *questionsDataSource = [[QuestionListTableDataSource alloc] init];
    viewController.dataSource = questionsDataSource;
    [viewController viewDidLoad];
    XCTAssertEqualObjects(questionsDataSource.tableView, tableView, @"Back-link to table view should be set in data source");
}

#pragma mark - Questions list related tests

-(void)testDefaultStateOfViewControllerDoesNotReceiveQuestionSelectionNotification
{
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[BrowseOverflowViewController class] selector:realUserDidSelectQuestion andSelector:testUserDidSelectQuestion];
    [[NSNotificationCenter defaultCenter] postNotificationName:QuestionListDidSelectQuestionNotification object:nil userInfo:nil];
    XCTAssertNil(objc_getAssociatedObject(viewController, notificationKey), @"Notification should not be received before -viewDidAppear:");
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[BrowseOverflowViewController class] selector:realUserDidSelectQuestion andSelector:testUserDidSelectQuestion];
}

- (void)testViewControllerDoesReceiveQuestionSelectionNotificationAfterViewDidAppear
{
    
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[BrowseOverflowViewController class] selector:realUserDidSelectQuestion andSelector:testUserDidSelectQuestion];
    [viewController viewDidAppear:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:QuestionListDidSelectQuestionNotification object:nil userInfo:nil];
    XCTAssertNotNil(objc_getAssociatedObject(viewController, notificationKey), @"Notification should be received after -viewDidAppear:");
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[BrowseOverflowViewController class] selector:realUserDidSelectQuestion andSelector:testUserDidSelectQuestion];

}

- (void)testViewControllerDoesNotReceiveQuestionSelectionNotificationAfterViewWillDisappear
{
    
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[BrowseOverflowViewController class] selector:realUserDidSelectQuestion andSelector:testUserDidSelectQuestion];
    [viewController viewWillAppear:NO];
    [viewController viewWillDisappear:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:QuestionListDidSelectQuestionNotification object:nil userInfo:nil];
    XCTAssertNil(objc_getAssociatedObject(viewController, notificationKey), @"Notification should not be received after -viewWillDispear:");
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[BrowseOverflowViewController class] selector:realUserDidSelectQuestion andSelector:testUserDidSelectQuestion];
    
}

- (void)testSelectingQuestionPushesNewViewController
{
    [viewController userDidSelectQuestionNotification:nil];
    UIViewController *currentTopVC = navController.topViewController;
    XCTAssertFalse([currentTopVC isEqual:viewController],@"New VC should have been pushed on the stack");
    XCTAssertTrue([currentTopVC isKindOfClass: [BrowseOverflowViewController class]], @"New view controller should be a BrowseOverflowViewController");
}

- (void)testViewControllerPushedOnQuestionSelectionHasQuestionDetailDataSource
{
    Question *sampleQuestion = [[Question alloc] init];
    NSNotification *note = [NSNotification notificationWithName:QuestionListDidSelectQuestionNotification object:sampleQuestion];
    [viewController userDidSelectQuestionNotification:note];
    BrowseOverflowViewController *nextVC = (BrowseOverflowViewController *)navController.topViewController;
    XCTAssertTrue([nextVC.dataSource isKindOfClass:[QuestionDetailDataSource class]], @"Selecting a question should show details for the question");
    XCTAssertEqualObjects([(QuestionDetailDataSource *)nextVC.dataSource question], sampleQuestion, @"Question should be passed to the data source");
}

- (void)testSelectingTopicNoficiationPassesObjectConfigurationToNewViewController
{
    [viewController userDidSelectTopicNotification:nil];
    BrowseOverflowViewController *newTopVC = (BrowseOverflowViewController *)navController.topViewController;
    XCTAssertEqualObjects(newTopVC.objectConfiguration, objectConfiguration, @"The object configuration should be passed through to the new VC");
    
}

- (void)testSelectingQuestionNoficiationPassesObjectConfigurationToNewViewController
{
    [viewController userDidSelectQuestionNotification:nil];
    BrowseOverflowViewController *newTopVC = (BrowseOverflowViewController *)navController.topViewController;
    XCTAssertEqualObjects(newTopVC.objectConfiguration, objectConfiguration, @"The object configuration should be passed through to the new VC");
    
}

- (void)testViewWillAppearOnQuestionListInitiatesLoadingOfQuestion
{
    TestObjectConfiguration *configuration = [[TestObjectConfiguration alloc] init];
    MockStackOverflowManager *manager = [[MockStackOverflowManager alloc] init];
    configuration.objectToReturn = manager;
    viewController.objectConfiguration = configuration;
    viewController.dataSource = [[QuestionListTableDataSource alloc] init];
    [viewController viewWillAppear:YES];
    XCTAssertTrue([manager didFetchQuestions], @"View controller should have arranged for question content to be downloaded");
}

// TODO: “Don’t forget to write additional tests to ensure that the question list isn’t requested at other times (and that the question details are loaded when required).”

- (void)testViewWillAppearOnQuestionDetailsDoesNotInitiateLoadingOfQuestion
{
    TestObjectConfiguration *configuration = [[TestObjectConfiguration alloc] init];
    MockStackOverflowManager *manager = [[MockStackOverflowManager alloc] init];
    configuration.objectToReturn = manager;
    viewController.objectConfiguration = configuration;
    viewController.dataSource = [[QuestionDetailDataSource alloc] init];
    [viewController viewWillAppear:YES];
    XCTAssertFalse([manager didFetchQuestions], @"View controller mustn't arrange question content to be downloaded when question details are displayed");
}

- (void)testViewControllerConformsToStackOverflowManagerDelegateProtocol
{
    XCTAssertTrue([viewController conformsToProtocol:@protocol(StackOverflowManagerDelegate)], @"View controllers need to be StackOverflowManagerDelegates");
}

- (void)testViewControllerConfiguredAsStackOverflowManagerDelegateOnManagerCreation
{
    [viewController viewWillAppear:YES];
    XCTAssertEqualObjects(viewController.manager.delegate, viewController, @"View controller sets itself as the manager's delegate");
}


@end
