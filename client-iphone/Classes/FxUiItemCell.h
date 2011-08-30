
#import <Foundation/Foundation.h>

#import "FxUiCell.h"

@interface FxUiItemCell : FxUiCell

@property(nonatomic, readonly) NSInteger  styleCode;

@property(nonatomic, readonly) NSObject  *captionBoundObject;
@property(nonatomic, readonly) NSString  *captionPropertyKey;

@property(nonatomic, readonly) NSObject  *contentBoundObject;
@property(nonatomic, readonly) NSString  *contentPropertyKey;

@property(nonatomic, readonly) NSObject  *targetObject;
@property(nonatomic, readonly) SEL        action;
@property(nonatomic, readonly) NSObject  *actionContext;

- (id) initWithStyleCode:(NSInteger)styleCode captionBoundObject:(NSObject *)captionBoundObject captionPropertyKey:(NSString *)captionPropertyKey contentBoundObject:(NSObject *)contentBoundObject contentPropertyKey:(NSString *)contentPropertyKey targetObject:(NSObject *)targetObject action:(SEL)action actionContext:(NSObject *)actionContext;

@end
