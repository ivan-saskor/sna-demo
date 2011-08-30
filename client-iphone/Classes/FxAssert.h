
#import <Foundation/Foundation.h>

@interface FxAssert : NSObject

+ (void) isNotNullArgument        :(NSObject *)argumentValue withName:(NSString *)argumentName;
+ (void) isNotEmptyArgument       :(NSObject *)argumentValue withName:(NSString *)argumentName;
+ (void) isNotNullNorEmptyArgument:(NSObject *)argumentValue withName:(NSString *)argumentName;

+ (void) isValidArgument          :(NSObject *)argumentValue withName:(NSString *)argumentName validation:(BOOL)validationResult;

+ (void) isNotNullValue:(NSObject *)value;
+ (void) isNotNullValue:(NSObject *)value reason:(NSString *)reason;

+ (void) isValidState:(BOOL)validationResult;
+ (void) isValidState:(BOOL)validationResult reason:(NSString *)reason;

@end
