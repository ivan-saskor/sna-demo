
#import "FxUiSection.h"

@implementation FxUiSection

@synthesize caption = _caption;
@synthesize cells   = _cells;

- (id) init
{
    return [self initWithCaption:nil];
}
- (id) initWithCaption:(NSString *)caption
{
    self = [super init];
    
    if (!self) @throw [NSException exceptionWithName:@"Init failed" reason:nil userInfo:nil];
    
    _caption = caption;
    _cells   = [[NSMutableArray alloc] init];
    
    return self;
}

- (void) dealloc
{
    [_caption release];
    [_cells   release];
    
    [super dealloc];
}


- (FxUiCell *) cellAtIndex:(NSInteger)index
{
    return [self.cells objectAtIndex:index];
}
- (id)addCell:(FxUiCell *) cell
{
    [_cells addObject:cell];
    
    return cell;
}

- (FxUiTextBlockCell *) addTextBlockCellWithBoundObject:                            (NSObject *)boundObject propertyKey:(NSString *)propertyKey
{
    return [self addCell:[[[FxUiTextBlockCell alloc] initWithCaption:nil boundObject:boundObject propertyKey:propertyKey] autorelease]];
}
- (FxUiTextBlockCell *) addTextBlockCellWithCaption:(NSString *)caption boundObject:(NSObject *)boundObject propertyKey:(NSString *)propertyKey
{
    return [self addCell:[[[FxUiTextBlockCell alloc] initWithCaption:caption boundObject:boundObject propertyKey:propertyKey] autorelease]];
}
- (FxUiTextBlockCell *) addTextBlockCellWithCaption:(NSString *)caption boundObject:(NSObject *)boundObject propertyKey:(NSString *)propertyKey displayPropertyKey:(NSString *)displayPropertyKey
{
    return [self addCell:[[[FxUiTextBlockCell alloc] initWithCaption:caption boundObject:boundObject propertyKey:propertyKey displayPropertyKey:displayPropertyKey] autorelease]];
}


- (FxUiTextFieldCell *) addTextFieldCellWithPlaceholder:(NSString *)placeholder boundObject:(NSObject *)boundObject propertyKey:(NSString *)propertyKey
{
    return [self addCell:[[[FxUiTextFieldCell alloc] initWithPlaceholder:placeholder boundObject:boundObject propertyKey:propertyKey isPassword:NO isEmail:NO] autorelease]];
}
- (FxUiTextFieldCell *) addTextFieldCellWithPlaceholder:(NSString *)placeholder boundObject:(NSObject *)boundObject propertyKey:(NSString *)propertyKey isPassword:(BOOL)isPassword
{
    return [self addCell:[[[FxUiTextFieldCell alloc] initWithPlaceholder:placeholder boundObject:boundObject propertyKey:propertyKey isPassword:isPassword isEmail:NO] autorelease]];
}
- (FxUiTextFieldCell *) addTextFieldCellWithPlaceholder:(NSString *)placeholder boundObject:(NSObject *)boundObject propertyKey:(NSString *)propertyKey isEmail   :(BOOL)isEmail
{
    return [self addCell:[[[FxUiTextFieldCell alloc] initWithPlaceholder:placeholder boundObject:boundObject propertyKey:propertyKey isPassword:NO isEmail:isEmail] autorelease]];
}

- (FxUiButtonCell *) addButtonCellWithCaption:(NSString *)caption targetObject:(NSObject *)targetObject action:(SEL)action
{
    return [self addCell:[[[FxUiButtonCell alloc] initWithCaption:caption targetObject:targetObject action:action] autorelease]];
}

- (FxUiItemCell *) addItem1CellWithCaptionBoundObject:(NSObject *)captionBoundObject captionPropertyKey:(NSString *)captionPropertyKey contentBoundObject:(NSObject *)contentBoundObject contentPropertyKey:(NSString *)contentPropertyKey targetObject:(NSObject *)targetObject action:(SEL)action actionContext:(NSObject *)actionContext accesoryType:(UITableViewCellAccessoryType)accesoryType
{
    return [self addCell:[[[FxUiItemCell alloc] initWithStyleCode:1 captionBoundObject:captionBoundObject captionPropertyKey:captionPropertyKey contentBoundObject:contentBoundObject contentPropertyKey:contentPropertyKey targetObject:targetObject action:action actionContext:actionContext accesoryType:accesoryType] autorelease]];
}
- (FxUiItemCell *) addItem2CellWithCaptionBoundObject:(NSObject *)captionBoundObject captionPropertyKey:(NSString *)captionPropertyKey contentBoundObject:(NSObject *)contentBoundObject contentPropertyKey:(NSString *)contentPropertyKey  accesoryType:(UITableViewCellAccessoryType)accesoryType
{
    return [self addCell:[[[FxUiItemCell alloc] initWithStyleCode:2 captionBoundObject:captionBoundObject captionPropertyKey:captionPropertyKey contentBoundObject:contentBoundObject contentPropertyKey:contentPropertyKey targetObject:nil action:nil actionContext:nil accesoryType:accesoryType] autorelease]];
}

@end
