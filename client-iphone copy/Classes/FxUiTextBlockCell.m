
#import "FxUiTextBlockCell.h"

@implementation FxUiTextBlockCell

static const NSInteger _CELL_HEIGHT = 24; 

@synthesize caption            = _caption;
@synthesize boundObject        = _boundObject;
@synthesize propertyKey        = _propertyKey;
@synthesize displayPropertyKey = _displayPropertyKey;

- (id) initWithHeight:(NSInteger)height
{
    @throw [NSException exceptionWithName:@"Init with height is not supported" reason:nil userInfo:nil];
}
- (id) initWithCaption:(NSString *)caption boundObject:(NSObject *)boundObject propertyKey:(NSString *)propertyKey
{
    return [self initWithCaption:caption boundObject:boundObject propertyKey:propertyKey displayPropertyKey:nil];
}
- (id) initWithCaption:(NSString *)caption boundObject:(NSObject *)boundObject propertyKey:(NSString *)propertyKey displayPropertyKey:(NSString *)displayPropertyKey
{
    self = [super initWithHeight:_CELL_HEIGHT canBecomeFirstResponder:NO];
    
    if (!self) @throw [NSException exceptionWithName:@"Init failed" reason:nil userInfo:nil];
    
    _caption            = [caption            copy  ];
    _boundObject        = [boundObject        retain];
    _propertyKey        = [propertyKey        copy  ];
    _displayPropertyKey = [displayPropertyKey copy  ];
    
    return self;
}

- (void) dealloc
{
    [_caption     release];
    [_boundObject release];
    [_propertyKey release];
    
    [super dealloc];
}

@end
