//
//  TestObjectConfiguration.m
//  BrowseOverflow
//
//  Created by jata on 01/08/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "TestObjectConfiguration.h"

@implementation TestObjectConfiguration

- (StackOverflowManager *)stackOverflowManager
{
    return (StackOverflowManager *)self.objectToReturn;
}

@end
