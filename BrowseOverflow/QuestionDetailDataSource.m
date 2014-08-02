//
//  AnswerListTableDataSource.m
//  BrowseOverflow
//
//  Created by Marcin Olek on 31.07.2014.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "QuestionDetailDataSource.h"
#import "Question.h"
#import "QuestionDetailCell.h"
#import "AnswerCell.h"
#import "Answer.h"
#import "Question.h"
#import "Person.h"
#import "AvatarStore.h"

@implementation QuestionDetailDataSource

enum {
    questionSection = 0,
    answersSection = 1,
    sectionCount = 2
};

- (NSString *)HTMLStringForSnippet:(NSString *)snippet {
    return [NSString stringWithFormat: @"<html><head></head><body>%@</body></html>", snippet];
}

#pragma mark UITableViewDataSource 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == questionSection ? 1 : self.question.answers.count;
}

static NSString *answerCellReuseIdentifier = @"AnswerCell";
static NSString *questionDetailCellReuseIdentifier = @"QuestionDetail";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if(indexPath.section == questionSection) {
        self.detailCell = [tableView dequeueReusableCellWithIdentifier:questionDetailCellReuseIdentifier];
        if(!self.detailCell) {
            [[NSBundle bundleForClass:[self class]] loadNibNamed:@"QuestionDetailCell" owner:self options:nil];
        }
        [self.detailCell.bodyWebView loadHTMLString:[self HTMLStringForSnippet:self.question.body] baseURL:nil];
        
        Person *asker = self.question.asker;
        self.detailCell.askerNameLabel.text = asker.name;
        self.detailCell.scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)self.question.score];
        self.detailCell.titleLabel.text = self.question.title;
        NSData *avatarData = [self.avatarStore dataForURL:asker.avatarURL];
        if(avatarData) {
            self.detailCell.avatarView.image = [UIImage imageWithData:avatarData];
        }
        cell = self.detailCell;
    } else if(indexPath.section == answersSection) {
        Answer *thisAnswer = self.question.answers[indexPath.row];
        Person *answerer = thisAnswer.person;
        self.answerCell = [tableView dequeueReusableCellWithIdentifier:answerCellReuseIdentifier];
        if(!self.answerCell) {
            [[NSBundle bundleForClass:[self class]] loadNibNamed:@"AnswerCell" owner:self options:nil];
        }
        self.answerCell.scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)thisAnswer.score];
        self.answerCell.acceptedLabel.hidden = thisAnswer.accepted;
        self.answerCell.answererNameLabel.text = answerer.name;
        [self.answerCell.bodyWebView loadHTMLString:[self HTMLStringForSnippet:thisAnswer.text] baseURL:nil];
        NSData *avatarData = [self.avatarStore dataForURL:answerer.avatarURL];
        if(avatarData) {
            self.answerCell.avatarView.image = [UIImage imageWithData:avatarData];
        }
    
        cell = self.answerCell;
    } else {
        NSParameterAssert(indexPath.section < sectionCount);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == questionSection) {
        return 276.0f;
    }
    else {
        return 201.0f;
    }
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
