//
//  SnaJsonWrapper.m
//  client-iphone
//
//  Created by Bruno Batarelo on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SnaJsonWrapper.h"
#import "CJSONSerializer.h"
#import "CJSONDeserializer.h"

//#import "JSONKit.h"

@implementation SnaJsonWrapper
+ (NSString *) stringFromJsonDictionary:(NSDictionary *) dictionary
{
    CJSONSerializer * serializer = [[[CJSONSerializer alloc] init] autorelease];
    NSString *stringJson = [[[NSString alloc] initWithData:[serializer serializeDictionary:dictionary error:nil] encoding:NSUTF8StringEncoding] autorelease];
    
    return stringJson;
    
//    return [dictionary JSONString];
    
}
+ (NSDictionary *) deserializeJsonData:(NSData *) data
{
    NSError *theError = nil;
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    theDeserializer.nullObject = NULL;

    return [NSDictionary dictionaryWithDictionary:[theDeserializer deserialize:data error:&theError]];
    
//    JSONDecoder *decoder = [JSONDecoder decoder];
//    
//    return (NSDictionary *)[decoder objectWithData:data];
}
@end
