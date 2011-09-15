
#import "_Fx.h"

@interface SnaGender : FxEnum
{
    @private NSString *_name;
}

+ (SnaGender *) MALE  ;
+ (SnaGender *) FEMALE;
+ (SnaGender *) OTHER ;

+ (NSArray *)values;

@property(readonly, copy) NSString *name;

@end
