
#import <UIKit/UIKit.h>

@interface FxUiCell : NSObject

@property(nonatomic, readonly) NSInteger height;
@property(nonatomic, readonly) BOOL      canBecomeFirstResponder;

- (id) initWithHeight:(NSInteger)height canBecomeFirstResponder:(BOOL)canBecomeFirstResponder;

- (void) didSelect;

@end
