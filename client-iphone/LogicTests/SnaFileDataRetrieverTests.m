//
//  SnaFileDataRetrieverTests.m
//  client-iphone
//
//  Created by Bruno Batarelo on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SnaFileDataRetrieverTests.h"
#import "SnaFileDataRetriever.h"

@implementation SnaFileDataRetrieverTests

- (void)testSnaFileDataRetriever_returns_NSValue_for_valid_path
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"get_data" ofType:@"json"];
    SnaFileDataRetriever *fileDataRetreiver = [[SnaFileDataRetriever alloc] initWithFile:path];
    
    STAssertNotNil([fileDataRetreiver retrieveData], @"Retrieved data should not be nil");
}

@end
