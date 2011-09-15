
#import <UIKit/UIKit.h>

#import "FxUiCell.h"
#import "FxUiTextBlockCell.h"
#import "FxUiTextFieldCell.h"
#import "FxUiButtonCell.h"
#import "FxUiItemCell.h"

@interface FxUiSection : NSObject
{
    @private NSMutableArray *_cells;
}

@property(nonatomic, readonly) NSString *caption;
@property(nonatomic, readonly) NSArray  *cells;

- (id) initWithCaption:(NSString *)caption;

- (FxUiCell *) cellAtIndex:(NSInteger)index;

- (id) addCell:(FxUiCell *) cell;

- (FxUiTextBlockCell *) addTextBlockCellWithBoundObject:                            (NSObject *)boundObject propertyKey:(NSString *)propertyKey;
- (FxUiTextBlockCell *) addTextBlockCellWithCaption:(NSString *)caption boundObject:(NSObject *)boundObject propertyKey:(NSString *)propertyKey;
- (FxUiTextBlockCell *) addTextBlockCellWithCaption:(NSString *)caption boundObject:(NSObject *)boundObject propertyKey:(NSString *)propertyKey displayPropertyKey:(NSString *)displayPropertyKey;

- (FxUiTextFieldCell *) addTextFieldCellWithPlaceholder:(NSString *)placeholder boundObject:(NSObject *)boundObject propertyKey:(NSString *)propertyKey;
- (FxUiTextFieldCell *) addTextFieldCellWithPlaceholder:(NSString *)placeholder boundObject:(NSObject *)boundObject propertyKey:(NSString *)propertyKey isPassword:(BOOL)isPassword;
- (FxUiTextFieldCell *) addTextFieldCellWithPlaceholder:(NSString *)placeholder boundObject:(NSObject *)boundObject propertyKey:(NSString *)propertyKey isEmail   :(BOOL)isEmail;

- (FxUiButtonCell *) addButtonCellWithCaption:(NSString *)caption targetObject:(NSObject *)targetObject action:(SEL)action;

- (FxUiItemCell *) addItem1CellWithCaptionBoundObject:(NSObject *)captionBoundObject captionPropertyKey:(NSString *)captionPropertyKey contentBoundObject:(NSObject *)contentBoundObject contentPropertyKey:(NSString *)contentPropertyKey targetObject:(NSObject *)targetObject action:(SEL)action actionContext:(NSObject *)actionContext accesoryType:(UITableViewCellAccessoryType)accesoryType;
- (FxUiItemCell *) addItem2CellWithCaptionBoundObject:(NSObject *)captionBoundObject captionPropertyKey:(NSString *)captionPropertyKey contentBoundObject:(NSObject *)contentBoundObject contentPropertyKey:(NSString *)contentPropertyKey  accesoryType:(UITableViewCellAccessoryType)accesoryType;

@end
