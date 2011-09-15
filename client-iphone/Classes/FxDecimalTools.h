
#import <Foundation/Foundation.h>

@interface FxDecimalTools : NSObject

+ (NSDecimal) decimalFromMantisa:(NSInteger)mantisa exponent:(NSInteger)exponent isNegative:(BOOL)isNegative;

@end
