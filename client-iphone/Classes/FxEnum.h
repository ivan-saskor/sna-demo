
#import <Foundation/Foundation.h>

#import "FxIDumpableEnum.h"

@interface FxEnum : NSObject<FxIDumpableEnum>
{
    @private NSString *_identifier;
}

- (id) initWithIdentifier:(NSString *)identifier;

@property(readonly) NSString *identifier;

@end
