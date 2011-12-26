
#import <Foundation/Foundation.h>

#import "FxUiCell.h"

@interface FxUiTextFieldCell : FxUiCell

@property(nonatomic, readonly) NSString *placeHolder;
@property(nonatomic, readonly) NSObject *boundObject;
@property(nonatomic, readonly) NSString *propertyKey;
@property(nonatomic, readonly) BOOL      isPassword;
@property(nonatomic, readonly) BOOL      isEmail;

- (id) initWithPlaceholder:(NSString *)placeholder boundObject:(NSObject *)boundObject propertyKey:(NSString *)propertyKey isPassword:(BOOL)isPassword isEmail:(BOOL)isEmail;

@end
