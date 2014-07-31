//
//  AnswerListTableDataSourceTests.m
//  BrowseOverflow
//
//  Created by Marcin Olek on 31.07.2014.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "QuestionDetailDataSource.h"
#import "Question.h"
#import "Question+Copyable.h"
#import "Answer.h"
#import "Person.h"
#import "QuestionDetailCell.h"
#import "AnswerCell.h"
#import "AvatarStore.h"
#import "AvatarStore+TestingExtensions.h"

@interface QuestionDetailDataSourceTests : XCTestCase

@end

@implementation QuestionDetailDataSourceTests {
    QuestionDetailDataSource *dataSource;
    Question *question;
    Question *questionNoAnswers;
    Answer *answer1;
    Answer *answer2;
    Person *asker;
    AvatarStore *store;
    NSData *imageData;
    NSURL *imageURL;
    NSIndexPath *questionDetailsPath;
    NSIndexPath *firstAnswerPath;
    NSIndexPath *secondAnswerPath;
    
}

- (void)setUp
{
    [super setUp];
    question = [[Question alloc] init];
    question.title = @"Question title";
    question.score = 3;
    question.body = @"<p>I think I have been through probably 50 versions of this question today.  The closest answer I got was putting </p>\n\n<pre><code>- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow: (UIWindow *)window{\n</code></pre>\n\n<p>into my app delegate and </p>\n\n<pre><code>-(BOOL)shouldAutorotate\n- (NSUInteger) supportedInterfaceOrientations\n</code></pre>\n\n<p>into the view controller I want to restrict to portrait mode.  In this setup what I found is that the methods in my view controller never get called.  The method in my appdelegate gets called whenever I do a tab bar based segue, but not when I do a push segue in a navigation controller.  </p>\n\n<p>I've seen several answers that want me to subclass navigation controllers, but there has to be a more straight forward way.</p>\n\n<p>I have an app with three tabs.  Tab 1 is just a home screen.  Tab 2 has a navigation controller feeding through two tableviewscontrollers, and the last table view segue's into a simple view controller.  Tab three goes to one tableviewcontroller which then does a push segue into the same simple view controller where tab 2 terminates.  </p>\n\n<p>I want that terminating view controller to always be in portrait.  The other scenes should be able to switch between portrait and landscape as needed.</p>\n\n<p>I am in xcode5 IOS7.<br>\nThanks</p>\n";
    asker = [[Person alloc] initWithName:@"Marcin Olek" avatarLocation:@"http://gravatar.com/userimage/54427651/aa2bea90f6a2bc5307fe12ecc4d697bf.jpg"];
    question.asker = asker;
    answer1 = [[Answer alloc] init];
    answer1.text = @"<p>The real answer to the question is that good apps fall into one of three categories: portrait-only apps, landscape-only apps, and apps that support both orientations in all view controllers.  </p>\n\n<p>The UX design goal: the user controls the app, the app <strong>does not</strong> control the user.</p>\n\n<p>An app that has some view controllers that are portrait-only, and some view controllers that support rotation, is an app that is trying to control the user.  Specifically, when the user navigates to the portrait-only view, the app is forcing the user to physically rotate the device in response to the app's whims.</p>\n\n<p>In short, given that you have a view controller that only supports portrait, you should design a portrait-only app.  If you don't want a portrait-only app, then you need to figure out how to support rotation on that last view controller.</p>\n";
    answer1.score = 3;
    answer1.accepted = YES;
    Person *answerer = [[Person alloc] initWithName:@"Graham Lee" avatarLocation:@"http://example.com/avatar"];
    answer2 = [[Answer alloc] init];
    answer2.accepted = NO;
    answer2.score = -99;
    answer2.text = @"<p>strictly-for-the-birds answer</p>\n";
    answer2.person = answerer;
    questionNoAnswers = [question copy];
    [question addAnswer:answer2];
    [question addAnswer:answer1];
    questionDetailsPath = [NSIndexPath indexPathForRow:0 inSection:0];
    firstAnswerPath = [NSIndexPath indexPathForRow:0 inSection:1];
    secondAnswerPath = [NSIndexPath indexPathForRow:1 inSection:1];
    store = [[AvatarStore alloc] init];
    dataSource = [[QuestionDetailDataSource alloc] init];
    dataSource.question = question;
    imageURL = [NSURL URLWithString:@"http://gravatar.com/userimage/54427651/aa2bea90f6a2bc5307fe12ecc4d697bf.jpg"];
    imageData = [NSData dataWithContentsOfURL:imageURL];
}

- (void)tearDown
{
    dataSource = nil;
    question = nil;
    asker = nil;
    answer1 = nil;
    answer2 = nil;
    questionNoAnswers = nil;
    questionDetailsPath = nil;
    firstAnswerPath = nil;
    secondAnswerPath = nil;
    store = nil;
    imageURL = nil;
    imageData = nil;
    [super tearDown];
}

- (void)testTwoSectionsInTable
{
    XCTAssertEqual([dataSource numberOfSectionsInTableView:nil], (NSInteger)2, @"There should be two sections: 1 for question details and 1 for answers");
}

- (void)testOneRowInSecionZero
{
    XCTAssertEqual([dataSource tableView:nil numberOfRowsInSection:0], (NSInteger)1, @"The first section should have only one row: question details");
}

- (void)testNoAnswersLeadsToNoRowsInSectionOne
{
    dataSource.question = questionNoAnswers;
    NSInteger rowNumber = [dataSource tableView:nil numberOfRowsInSection:1];
    XCTAssertEqual(rowNumber, (NSInteger)0,@"Empty answers list means no rows answer section");
}

- (void)testNumberOfRowsInSecionOneEqualsNumberOfAnswers
{
    NSInteger rowNumber = [dataSource tableView:nil numberOfRowsInSection:1];
    XCTAssertEqual(rowNumber, (NSInteger)2, @"Two answers means two rows in answer section");
}

- (void)testDataInQuestionDetailCellMatchQuestionProperties
{
    QuestionDetailCell *cell = (QuestionDetailCell *)[dataSource tableView:nil cellForRowAtIndexPath:questionDetailsPath];
    UIWebView *bodyView = cell.bodyWebView;
    /* NASTY HACK ALERT
     * The UIWebView loads its contents asynchronously. If it's still doing
     * that when the test comes to evaluate its content, the content will seem
     * empty and the test will fail. Any solution to this comes down to "hold
     * the test back for a bit", which I've done explicitly here.
     * http://stackoverflow.com/questions/7255515/why-is-my-uiwebview-empty-in-my-unit-test
     */
    [[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow: 2.0]];
    NSString *bodyHTML = [bodyView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    XCTAssertEqualObjects(cell.titleLabel.text, @"Question title", @"Question detail cell should display question title");
    XCTAssertEqualObjects(cell.scoreLabel.text, @"3", @"Question detail cell should display question score");
    XCTAssertEqualObjects(bodyHTML, @"<p>I think I have been through probably 50 versions of this question today.  The closest answer I got was putting </p>\n\n<pre><code>- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow: (UIWindow *)window{\n</code></pre>\n\n<p>into my app delegate and </p>\n\n<pre><code>-(BOOL)shouldAutorotate\n- (NSUInteger) supportedInterfaceOrientations\n</code></pre>\n\n<p>into the view controller I want to restrict to portrait mode.  In this setup what I found is that the methods in my view controller never get called.  The method in my appdelegate gets called whenever I do a tab bar based segue, but not when I do a push segue in a navigation controller.  </p>\n\n<p>I've seen several answers that want me to subclass navigation controllers, but there has to be a more straight forward way.</p>\n\n<p>I have an app with three tabs.  Tab 1 is just a home screen.  Tab 2 has a navigation controller feeding through two tableviewscontrollers, and the last table view segue's into a simple view controller.  Tab three goes to one tableviewcontroller which then does a push segue into the same simple view controller where tab 2 terminates.  </p>\n\n<p>I want that terminating view controller to always be in portrait.  The other scenes should be able to switch between portrait and landscape as needed.</p>\n\n<p>I am in xcode5 IOS7.<br>\nThanks</p>\n", @"Question detail cell should display question body");
    XCTAssertEqualObjects(cell.askerNameLabel.text, @"Marcin Olek", @"Question detail cell should display question asker name");
}

- (void)testDataInAnswerCellMatchAnswerProperties
{
    AnswerCell *cell = (AnswerCell *)[dataSource tableView:nil cellForRowAtIndexPath:firstAnswerPath];
    UIWebView *bodyView = cell.bodyWebView;
    [[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow: 2.0]];
    NSString *bodyHTML = [bodyView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];

    
    XCTAssertEqualObjects(bodyHTML, @"<p>The real answer to the question is that good apps fall into one of three categories: portrait-only apps, landscape-only apps, and apps that support both orientations in all view controllers.  </p>\n\n<p>The UX design goal: the user controls the app, the app <strong>does not</strong> control the user.</p>\n\n<p>An app that has some view controllers that are portrait-only, and some view controllers that support rotation, is an app that is trying to control the user.  Specifically, when the user navigates to the portrait-only view, the app is forcing the user to physically rotate the device in response to the app's whims.</p>\n\n<p>In short, given that you have a view controller that only supports portrait, you should design a portrait-only app.  If you don't want a portrait-only app, then you need to figure out how to support rotation on that last view controller.</p>\n", @"Answer cell should display answer body");
    XCTAssertEqualObjects(cell.scoreLabel.text, @"3", @"Answer cell should display answer score");
    XCTAssertTrue(cell.acceptedLabel.hidden, @"Answer cell should indicate that answer is accepted");
}

- (void)testDataInSecondAnswerCellMatchSecondAnswerProperties
{
    dataSource.avatarStore = store;
    [store setData: imageData forLocation: @"http://example.com/avatar"];
    AnswerCell *secondAnswerCell = (AnswerCell *)[dataSource tableView:nil cellForRowAtIndexPath:secondAnswerPath];
    UIWebView *bodyView = secondAnswerCell.bodyWebView;
    [[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow: 0.5]];
    NSString *bodyHTML = [bodyView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
    XCTAssertEqualObjects(bodyHTML, @"<p>strictly-for-the-birds answer</p>\n", @"Answer cell should display answer body");
    XCTAssertEqualObjects(secondAnswerCell.scoreLabel.text, @"-99", @"Answer cell should display answer score");
    XCTAssertFalse(secondAnswerCell.acceptedLabel.hidden, @"Answer cell should indicate that answer is not accepted");
    XCTAssertNotNil(secondAnswerCell.avatarView.image, @"Answer cell should show answerer avatar");

    XCTAssertEqualObjects(secondAnswerCell.answererNameLabel.text, @"Graham Lee", @"Answer cell should show answerer name");
}

- (void)testQuestionCellGetsImageFromAvatarStore
{
    dataSource.avatarStore = store;
    [store setData:imageData forLocation:[imageURL absoluteString]];
    QuestionDetailCell *cell = (QuestionDetailCell *)[dataSource tableView:nil cellForRowAtIndexPath:questionDetailsPath];
    XCTAssertNotNil(cell.avatarView.image, @"Question detail cell should display asker avatar");
}

- (void)testQuestionCellIsAtLeastAsTallAsItsContent
{
    QuestionDetailCell *cell = (QuestionDetailCell *)[dataSource tableView:nil cellForRowAtIndexPath:questionDetailsPath];
    CGFloat height = [dataSource tableView:nil heightForRowAtIndexPath:questionDetailsPath];
    XCTAssert(height >= cell.frame.size.height, @"Question row should be at least as tall as its content");
}

- (void)testAnswerCellIsAtLeastAsTallAsItsContent
{
    AnswerCell *cell = (AnswerCell *)[dataSource tableView:nil cellForRowAtIndexPath:firstAnswerPath];
    CGFloat height = [dataSource tableView:nil heightForRowAtIndexPath:firstAnswerPath];
    XCTAssert(height >= cell.frame.size.height, @"Answer row should be at least as tall as its content");
}



@end
