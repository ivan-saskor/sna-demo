//
//  LogicTests.m
//  LogicTests
//
//  Created by Bruno Batarelo on 12/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LogicTests.h"
#import "SnaFileDataRetriever.h"
//#import "ServerConnector.h"

@implementation LogicTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testSomething2
{
    SnaFileDataRetriever *retriever = [[SnaFileDataRetriever alloc] initWithFile:@"get_data.json"];
    
    NSData *data = [retriever retrieveData];
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"Test1: %@", str);
    
    
    STAssertNil(nil, @"");
    //STAssertNotNil(data, @"data should not be nil"); 
}

- (void)testSomething
{
    //ServerConnector *sc = [[ServerConnector alloc] init];
    NSLog(@"Test2");
    STAssertNil(nil, @"");
}

@end
