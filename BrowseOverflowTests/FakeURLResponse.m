//
//  FakeURLResponse.m
//  BrowseOverflow
//
//  Created by jata on 27/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "FakeURLResponse.h"

@interface FakeURLResponse () {
    NSInteger responseCode;
}

@end

@implementation FakeURLResponse
- (instancetype)initWithStatusCode:(NSInteger)code
{
    if((self = [super init])) {
        responseCode = code;
    }
    return self;
}

- (NSInteger)statusCode
{
    return responseCode;
}

@end
