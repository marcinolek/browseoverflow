//
//  BrowseOverflowObjectConfiguration.h
//  BrowseOverflow
//
//  Created by jata on 01/08/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StackOverflowManager;
@class AvatarStore;

@interface BrowseOverflowConfigurationObject : NSObject
- (StackOverflowManager *)stackOverflowManager;
- (AvatarStore *)avatarStore;
@end
