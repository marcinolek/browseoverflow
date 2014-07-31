//
//  QuestionDetailCellTableViewCell.h
//  BrowseOverflow
//
//  Created by jata on 31/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionDetailCell : UITableViewCell
@property (weak) IBOutlet UILabel *titleLabel;
@property (weak) IBOutlet UILabel *askerNameLabel;
@property (weak) IBOutlet UIWebView *bodyWebView;
@property (weak) IBOutlet UILabel *scoreLabel;
@property (weak) IBOutlet UIImageView *avatarView;
@end
