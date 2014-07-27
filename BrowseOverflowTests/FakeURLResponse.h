//
//  FakeURLResponse.h
//  BrowseOverflow
//
//  Created by jata on 27/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FakeURLResponse : NSObject
- (instancetype)initWithStatusCode:(NSInteger)code;
- (NSInteger)statusCode;
@end
