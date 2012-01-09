//
//  SnaDataRepository.m
//  client-iphone
//
//  Created by Bruno Batarelo on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SnaHttpDataRepository.h"

@implementation SnaHttpDataRepository
- (id) initWithConnector:(ServerConnector *)connector
{
    self = [super init];
    if (self != nil) {
        _connector = [connector retain];
    }
    
    return self;
}

- (void) dealloc
{
    [_connector release];
    [super dealloc];
}

- (NSMutableArray *)getPersons
{
	return _persons;
}

- (NSMutableArray *)getMessages
{
	return _messages;
}
@end
