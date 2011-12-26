
#import "FxExceptions.h"
#import "FxAssert.h"

@implementation FxException

static NSString *_UNSUPPORTED_METHOD_REASON  = @"Method is not supported.";

+ (id) invalidArgumentExceptionWithArgumentName:(NSString *)argumentName argumentValue:(NSObject *)argumentValue reason:(NSString *)reason
{
    [FxAssert isNotNullNorEmptyArgument:argumentName withName:@"argumentName"];
    [FxAssert isNotNullArgument        :reason       withName:@"reason"      ];

    return [[[FxInvalidArgumentException alloc] initWithArgumentName:argumentName argumentValue:argumentValue reason:reason] autorelease];
}

+ (id) invalidStateExceptionWithReason:(NSString *)reason;
{
    [FxAssert isNotNullArgument:reason withName:@"reason"];

    return [[[FxInvalidStateException alloc] initWithReason:reason] autorelease];
}

+ (id) unsupportedMethodException;
{
    return [[[FxUnsupportedMethodException alloc] initWithReason:_UNSUPPORTED_METHOD_REASON] autorelease];
}
- (id) init
{
    @throw [FxException unsupportedMethodException];
}
- (id) initWithCoder:(NSCoder *)aDecoder
{
    @throw [FxException unsupportedMethodException];
}
- (id) initWithReason:(NSString *)reason
{
    [FxAssert isNotNullArgument:reason withName:@"reason"];

    self = [super initWithName:nil reason:reason userInfo:nil];
    
    [FxAssert isNotNullValue:self];
    
    return self;
}
- (id) initWithName:(NSString *)aName reason:(NSString *)aReason userInfo:(NSDictionary *)aUserInfo
{
    @throw [FxException unsupportedMethodException];
}

@end
@implementation FxInvalidArgumentException

- (id) initWithArgumentName:(NSString *)argumentName argumentValue:(NSObject *)argumentValue reason:(NSString *)reason
{
    [FxAssert isNotNullNorEmptyArgument:argumentName withName:@"argumentName"];
    [FxAssert isNotNullArgument        :reason       withName:@"reason"      ];
    
    self = [super initWithReason:reason];
    
    [FxAssert isNotNullValue:self];
    
    return self;
}

@end
@implementation FxInvalidStateException
@end
@implementation FxUnsupportedMethodException
@end
