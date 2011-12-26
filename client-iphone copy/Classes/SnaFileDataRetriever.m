//
//  SnaFileDataRetriever.m
//  client-iphone
//
//  Created by Bruno Batarelo on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SnaFileDataRetriever.h"

@implementation SnaFileDataRetriever

- (id) initWithFile:(NSString *)file
{
    self = [super init];
    if (self != nil) {
        fileUrl = [NSString stringWithString:file];
    }
    
    return self;
}

- (NSData *) retrieveData
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager contentsAtPath:fileUrl];
}

- (void) dealloc
{
    [fileUrl release];
    [super dealloc];
}
@end
