//
//  BrowseOverflowViewController.m
//  BrowseOverflow
//
//  Created by jata on 28/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "BrowseOverflowViewController.h"
#import "TopicTableDataSource.h"
#import "QuestionListTableDataSource.h"
#import "QuestionDetailDataSource.h"
#import "BrowseOverflowConfigurationObject.h"
#import "StackOverflowManager.h"
#import "Topic.h"
#import <objc/runtime.h>

@interface BrowseOverflowViewController ()

@end

@implementation BrowseOverflowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.dataSource;
    objc_property_t tableViewProperty = class_getProperty([self.dataSource class], "tableView");
    if(tableViewProperty) {
        [self.dataSource setValue:self.tableView forKey:@"tableView"];
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.manager = [self.objectConfiguration stackOverflowManager];
    self.manager.delegate = self;
    if([self.dataSource isKindOfClass:[QuestionListTableDataSource class]]) {
        QuestionListTableDataSource *ds = (QuestionListTableDataSource *)self.dataSource;
        ds.avatarStore = [self.objectConfiguration avatarStore];
        Topic *selectedTopic = [ds topic];
        [self.manager fetchQuestionsOnTopic:selectedTopic];
        
    }
    
    if([self.dataSource isKindOfClass:[QuestionDetailDataSource class]]) {
        QuestionDetailDataSource *ds = (QuestionDetailDataSource *)self.dataSource;
        ds.avatarStore = [self.objectConfiguration avatarStore];
        Question *question = [ds question];
        [self.manager fetchBodyForQuestion:question];
        [self.manager fetchAnswersForQuestion:question];
        
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidSelectTopicNotification:) name:TopicTableDidSelectTopicNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidSelectQuestionNotification:) name:QuestionListDidSelectQuestionNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TopicTableDidSelectTopicNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QuestionListDidSelectQuestionNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userDidSelectTopicNotification:(NSNotification *)note
{
    Topic *selectedTopic = (Topic *)note.object;
    BrowseOverflowViewController *nextViewController = [[BrowseOverflowViewController alloc] init];
    QuestionListTableDataSource *dataSource = [[QuestionListTableDataSource alloc] init];
    dataSource.topic = selectedTopic;
    nextViewController.dataSource = dataSource;
    nextViewController.objectConfiguration = self.objectConfiguration;
    [[self navigationController] pushViewController:nextViewController animated:YES];
}

- (void)userDidSelectQuestionNotification:(NSNotification *)note
{
    Question *question = (Question *)note.object;
    BrowseOverflowViewController *nextViewController = [[BrowseOverflowViewController alloc] init];
    QuestionDetailDataSource *dataSource = [[QuestionDetailDataSource alloc] init];
    dataSource.question = question;
    nextViewController.dataSource = dataSource;
    nextViewController.objectConfiguration = self.objectConfiguration;
    [[self navigationController] pushViewController:nextViewController animated:YES];
}

#pragma mark StackOverflowManagerDelegate

- (void)fetchingAnswersFailedWithError:(NSError *)error
{
    
}

- (void)fetchingQuestionsFailedWithError:(NSError *)error
{
    
}

- (void)didReceiveQuestions:(NSArray *)questions
{
    Topic *topic = ((QuestionListTableDataSource *)self.dataSource).topic;
    for(Question *q in questions) {
        [topic addQuestion:q];
    }
    [self.tableView reloadData];
    
}

- (void)answersReceivedForQuestion:(Question *)question
{
    [self.tableView reloadData];
}

- (void)bodyReceivedForQuestion:(Question *)question
{
    [self.tableView reloadData];
}

@end
