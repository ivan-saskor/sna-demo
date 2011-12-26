
#import "_Fx.h"

@interface SnaVisibilityStatus : FxEnum
{
    @private NSString *_name;
}

+ (SnaVisibilityStatus *) INVISIBLE ;
+ (SnaVisibilityStatus *) OFFLINE   ;
+ (SnaVisibilityStatus *) ONLINE    ;
+ (SnaVisibilityStatus *) CONTACT_ME;

+ (NSArray *)values;

@property(readonly, copy) NSString *name;

@end
