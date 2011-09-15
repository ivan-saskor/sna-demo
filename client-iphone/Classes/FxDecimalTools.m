
#import "FxDecimalTools.h"

@implementation FxDecimalTools

+ (NSDecimal) decimalFromMantisa:(NSInteger)mantisa exponent:(NSInteger)exponent isNegative:(BOOL)isNegative
{
    return [[NSDecimalNumber decimalNumberWithMantissa:mantisa exponent:exponent isNegative:isNegative] decimalValue];
}

@end
