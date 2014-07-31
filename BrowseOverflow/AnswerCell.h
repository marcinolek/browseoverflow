//
//  AnswerCell.h
//  BrowseOverflow
//
//  Created by jata on 31/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerCell : UITableViewCell
@property (weak) IBOutlet UIWebView *bodyWebView;
@property (weak) IBOutlet UILabel *scoreLabel;
@property (weak) IBOutlet UILabel *acceptedLabel;
@property (weak) IBOutlet UIImageView *avatarView;
@end
