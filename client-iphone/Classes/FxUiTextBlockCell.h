
#import <Foundation/Foundation.h>

#import "FxUiCell.h"

@interface FxUiTextBlockCell : FxUiCell

@property(nonatomic, readonly) NSString *caption;
@property(nonatomic, readonly) NSObject *boundObject;
@property(nonatomic, readonly) NSString *propertyKey;
@property(nonatomic, readonly) NSString *displayPropertyKey;

- (id) initWithCaption:(NSString *)caption boundObject:(NSObject *)boundObject propertyKey:(NSString *)propertyKey;
- (id) initWithCaption:(NSString *)caption boundObject:(NSObject *)boundObject propertyKey:(NSString *)propertyKey displayPropertyKey:(NSString *)displayPropertyKey;

@end
