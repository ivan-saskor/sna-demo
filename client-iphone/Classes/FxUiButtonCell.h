
#import <Foundation/Foundation.h>

#import "FxUiCell.h"

@interface FxUiButtonCell : FxUiCell

@property(nonatomic, readonly) NSString *caption;

@property(nonatomic, readonly) NSObject *targetObject;
@property(nonatomic, readonly) SEL       action;

- (id) initWithCaption:(NSString *)caption targetObject:(NSObject *)targetObject action:(SEL)action;

@end
