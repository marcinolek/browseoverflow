//
//  Person.h
//  BrowseOverflow
//
//  Created by Marcin Olek on 16.07.2014.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSURL *avatarURL;

- (instancetype)initWithName:(NSString *)newName avatarLocation:(NSString *)avatarLocation;

@end
