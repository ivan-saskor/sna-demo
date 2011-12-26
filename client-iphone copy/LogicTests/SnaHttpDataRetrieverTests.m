//
//  SnaHttpDataRetrieverTests.m
//  client-iphone
//
//  Created by Bruno Batarelo on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SnaHttpDataRetrieverTests.h"
#import "SnaHttpDataRetriever.h"

@implementation SnaHttpDataRetrieverTests

- (void)testSnaHttpDataRetriever_returns_NSValue_for_valid_path
{
    NSString *url = [[NSString alloc] initWithFormat:@"http://localhost:3000/api/data"];
    
    SnaHttpDataRetriever *httpDataRetreiver = [[SnaHttpDataRetriever alloc] initWithUrl:url];
    
    STAssertNotNil([httpDataRetreiver retrieveData], @"Retrieved data should not be nil");
}

@end
