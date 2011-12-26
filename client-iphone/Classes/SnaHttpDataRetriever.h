//
//  SnaHttpDataRetriever.h
//  client-iphone
//
//  Created by Bruno Batarelo on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SnaDataRetriever.h"

@interface SnaHttpDataRetriever : NSObject<SnaDataRetriever>
- (id) initWithUrl:(NSString *) url;
- (NSData *) retrieveData;
@end
