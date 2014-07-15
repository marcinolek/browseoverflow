//
//  Topic.h
//  BrowseOverflow
//
//  Created by Marcin Olek on 15.07.2014.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Topic : NSObject

- (id)initWithName:(NSString *)newName tag:(NSString *)newTag;
@property (readonly) NSString *name;
@property (readonly) NSString *tag;
- (NSArray *)recentQuestions;

@end
