
#import "FxAssert.h"

#import "FxExceptions.h"

@interface FxAssert()

+ (void) _safeAssert_isNotNullArgument        :(NSObject *)argumentValue withName:(NSString *)argumentName;
+ (void) _safeAssert_isNotEmptyArgument       :(NSObject *)argumentValue withName:(NSString *)argumentName;
+ (void) _safeAssert_isNotNullNorEmptyArgument:(NSObject *)argumentValue withName:(NSString *)argumentName;

@end
@implementation FxAssert

static NSString *_ARGUMENT_IS_NOT_NULL_REASON  = @"Argument value should not be NULL.";
static NSString *_ARGUMENT_IS_NOT_EMPTY_REASON = @"Argument value should not be empty.";
static NSString *_ARGUMENT_IS_NOT_VALID_REASON = @"Argument validation falied.";

static NSString *_VALUE_IS_NOT_NULL_REASON = @"Value should not be NULL.";

static NSString *_STATE_IS_NOT_VALID_REASON = @"State validation failed.";

+ (void) isNotNullArgument        :(NSObject *)argumentValue withName:(NSString *)argumentName
{
    [FxAssert _safeAssert_isNotNullNorEmptyArgument:argumentName withName:@"argumentName"];
    
    if (argumentValue == nil)
    {
        @throw [FxException invalidArgumentExceptionWithArgumentName:argumentName argumentValue:argumentValue reason:_ARGUMENT_IS_NOT_NULL_REASON];
    }
}
+ (void) isNotEmptyArgument       :(NSObject *)argumentValue withName:(NSString *)argumentName
{
    [FxAssert _safeAssert_isNotNullArgument        :argumentValue withName:@"argumentValue"];
    [FxAssert _safeAssert_isNotNullNorEmptyArgument:argumentName  withName:@"argumentName" ];
    
    if ([argumentValue isEqual:@""])
    {
        @throw [FxException invalidArgumentExceptionWithArgumentName:argumentName argumentValue:argumentValue reason:_ARGUMENT_IS_NOT_EMPTY_REASON];
    }
}
+ (void) isNotNullNorEmptyArgument:(NSObject *)argumentValue withName:(NSString *)argumentName
{
    [FxAssert _safeAssert_isNotNullNorEmptyArgument:argumentName withName:@"argumentName"];
    
    if (argumentValue == nil)
    {
        @throw [FxException invalidArgumentExceptionWithArgumentName:argumentName argumentValue:argumentValue reason:_ARGUMENT_IS_NOT_NULL_REASON];
    }
    if ([argumentValue isEqual:@""])
    {
        @throw [FxException invalidArgumentExceptionWithArgumentName:argumentName argumentValue:argumentValue reason:_ARGUMENT_IS_NOT_EMPTY_REASON];
    }
}

+ (void) isValidArgument          :(NSObject *)argumentValue withName:(NSString *)argumentName validation:(BOOL)validationResult
{
    [FxAssert _safeAssert_isNotNullNorEmptyArgument:argumentName withName:@"argumentName"];
    
    if (!validationResult)
    {
        @throw [FxException invalidArgumentExceptionWithArgumentName:argumentName argumentValue:argumentValue reason:_ARGUMENT_IS_NOT_VALID_REASON];
    }
}

+ (void) isNotNullValue:(NSObject *)value
{
    [FxAssert isNotNullValue:value reason:_VALUE_IS_NOT_NULL_REASON];
}
+ (void) isNotNullValue:(NSObject *)value reason:(NSString *)reason
{
    [FxAssert _safeAssert_isNotNullArgument:reason withName:@"reason"];
    
    if (value == nil)
    {
        @throw [FxException invalidStateExceptionWithReason:reason];
    }
}

+ (void) isValidState:(BOOL)validationResult
{
    [FxAssert isValidState:validationResult reason:_STATE_IS_NOT_VALID_REASON];
}
+ (void) isValidState:(BOOL)validationResult reason:(NSString *)reason
{
    [FxAssert _safeAssert_isNotNullArgument:reason withName:@"reason"];
    
    if (!validationResult)
    {
        @throw [FxException invalidStateExceptionWithReason:reason];
    }
}


+ (void) _safeAssert_isNotNullArgument        :(NSObject *)argumentValue withName:(NSString *)argumentName
{
    if (argumentName == nil)
    {
        @throw [FxException invalidArgumentExceptionWithArgumentName:@"argumentName" argumentValue:argumentName reason:_ARGUMENT_IS_NOT_NULL_REASON];
    }
    if ([argumentName isEqual:@""])
    {
        @throw [FxException invalidArgumentExceptionWithArgumentName:@"argumentName" argumentValue:argumentName reason:_ARGUMENT_IS_NOT_EMPTY_REASON];
    }
    
    if (argumentValue == nil)
    {
        @throw [FxException invalidArgumentExceptionWithArgumentName:argumentName argumentValue:argumentValue reason:_ARGUMENT_IS_NOT_NULL_REASON];
    }
}
+ (void) _safeAssert_isNotEmptyArgument       :(NSObject *)argumentValue withName:(NSString *)argumentName
{
    if (argumentValue == nil)
    {
        @throw [FxException invalidArgumentExceptionWithArgumentName:@"argumentValue" argumentValue:argumentValue reason:_ARGUMENT_IS_NOT_NULL_REASON];
    }
    if (argumentName == nil)
    {
        @throw [FxException invalidArgumentExceptionWithArgumentName:@"argumentName" argumentValue:argumentName reason:_ARGUMENT_IS_NOT_NULL_REASON];
    }
    if ([argumentName isEqual:@""])
    {
        @throw [FxException invalidArgumentExceptionWithArgumentName:@"argumentName" argumentValue:argumentName reason:_ARGUMENT_IS_NOT_EMPTY_REASON];
    }
    
    if ([argumentValue isEqual:@""])
    {
        @throw [FxException invalidArgumentExceptionWithArgumentName:argumentName argumentValue:argumentValue reason:_ARGUMENT_IS_NOT_EMPTY_REASON];
    }
}
+ (void) _safeAssert_isNotNullNorEmptyArgument:(NSObject *)argumentValue withName:(NSString *)argumentName
{
    if (argumentName == nil)
    {
        @throw [FxException invalidArgumentExceptionWithArgumentName:@"argumentName" argumentValue:argumentName reason:_ARGUMENT_IS_NOT_NULL_REASON];
    }
    if ([argumentName isEqual:@""])
    {
        @throw [FxException invalidArgumentExceptionWithArgumentName:@"argumentName" argumentValue:argumentName reason:_ARGUMENT_IS_NOT_EMPTY_REASON];
    }
    
    if (argumentValue == nil)
    {
        @throw [FxException invalidArgumentExceptionWithArgumentName:argumentName argumentValue:argumentValue reason:_ARGUMENT_IS_NOT_NULL_REASON];
    }
    if ([argumentValue isEqual:@""])
    {
        @throw [FxException invalidArgumentExceptionWithArgumentName:argumentName argumentValue:argumentValue reason:_ARGUMENT_IS_NOT_EMPTY_REASON];
    }
}

@end
