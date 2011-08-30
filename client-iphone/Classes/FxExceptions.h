
#import <Foundation/Foundation.h>

@interface FxException : NSException

+ (id) invalidArgumentExceptionWithArgumentName:(NSString *)argumentName argumentValue:(NSObject *)argumentValue reason:(NSString *)reason;

+ (id) invalidStateExceptionWithReason:(NSString *)reason;

+ (id) unsupportedMethodException;

- (id) initWithReason:(NSString *)reason;

@end

@interface FxInvalidArgumentException : FxException

- (id) initWithArgumentName:(NSString *)argumentName argumentValue:(NSObject *)argumentValue reason:(NSString *)reason;

@end
@interface FxInvalidStateException : FxException
@end
@interface FxUnsupportedMethodException : FxException
@end
