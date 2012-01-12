//
//  SnaJsonWrapper.h
//  client-iphone
//
//  Created by Bruno Batarelo on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SnaJsonWrapper : NSObject
+ (NSString *) stringFromJsonDictionary:(NSDictionary *) dictionary;
+ (NSDictionary *) deserializeJsonData:(NSData *) data;
@end
