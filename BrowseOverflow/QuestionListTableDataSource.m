//
//  QuestionListTableDataSource.m
//  BrowseOverflow
//
//  Created by Marcin Olek on 30.07.2014.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "QuestionListTableDataSource.h"
#import "Topic.h"
#import "QuestionSummaryCell.h"
#import "Person.h"

@implementation QuestionListTableDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.topic recentQuestions] count] ?: 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if(self.topic.recentQuestions.count) {
        Question *question = self.topic.recentQuestions[indexPath.row];
        self.summaryCell = [tableView dequeueReusableCellWithIdentifier:@"question"];
        if(!self.summaryCell) {
            [[NSBundle bundleForClass:[self class]] loadNibNamed:@"QuestionSummaryCell" owner:self options:nil];
        }
        self.summaryCell.titleLabel.text = question.title;
        self.summaryCell.scoreLabel.text = [NSString stringWithFormat:@"%d",question.score];
        self.summaryCell.nameLabel.text = question.asker.name;
        cell = self.summaryCell;
        self.summaryCell = nil;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"placeholder"];
        if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"placeholder"];
        }
        cell.textLabel.text = @"There was a problem connecting to the network.";
    }
    return cell;
}

@end