//
//  SnaFileDataRetriever.h
//  client-iphone
//
//  Created by Bruno Batarelo on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SnaDataRetriever.h"

@interface SnaFileDataRetriever : NSObject<SnaDataRetriever>
{
    NSString *fileUrl;
}
- (id) initWithFile:(NSString *) file;
- (NSData *) retrieveData;
@end
