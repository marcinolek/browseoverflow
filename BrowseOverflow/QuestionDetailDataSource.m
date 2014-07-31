//
//  AnswerListTableDataSource.m
//  BrowseOverflow
//
//  Created by Marcin Olek on 31.07.2014.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "QuestionDetailDataSource.h"

@implementation QuestionDetailDataSource


#pragma mark UITableViewDataSource 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
