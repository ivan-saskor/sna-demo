
#import "FxUiItemCell.h"

@implementation FxUiItemCell

static const NSInteger _CELL_HEIGHT = 44; 

@synthesize styleCode          = _styleCode;

@synthesize captionBoundObject = _captionBoundObject;
@synthesize captionPropertyKey = _captionPropertyKey;

@synthesize contentBoundObject = _contentBoundObject;
@synthesize contentPropertyKey = _contentPropertyKey;

@synthesize targetObject       = _targetObject;
@synthesize action             = _action;
@synthesize actionContext      = _actionContext;

- (id) initWithHeight:(NSInteger)height
{
    @throw [NSException exceptionWithName:@"Init with height is not supported" reason:nil userInfo:nil];
}
- (id) initWithStyleCode:(NSInteger)styleCode captionBoundObject:(NSObject *)captionBoundObject captionPropertyKey:(NSString *)captionPropertyKey contentBoundObject:(NSObject *)contentBoundObject contentPropertyKey:(NSString *)contentPropertyKey targetObject:(NSObject *)targetObject action:(SEL)action actionContext:(NSObject *)actionContext;
{
    self = [super initWithHeight:_CELL_HEIGHT canBecomeFirstResponder:YES];
    
    if (!self) @throw [NSException exceptionWithName:@"Init failed" reason:nil userInfo:nil];
    
    _styleCode          =  styleCode;
    
    _captionBoundObject = [captionBoundObject retain];
    _captionPropertyKey = [captionPropertyKey copy  ];

    _contentBoundObject = [contentBoundObject retain];
    _contentPropertyKey = [contentPropertyKey copy  ];

    _targetObject       = [targetObject       retain];
    _action             =  action                    ;
    _actionContext      = [actionContext      retain];

    return self;
}

- (void) didSelect
{
    [_targetObject performSelector:_action withObject:_actionContext];
}

- (void) dealloc
{
    [_captionBoundObject release];
    [_captionPropertyKey release];

    [_contentBoundObject release];
    [_contentPropertyKey release];

    [_targetObject       release];
    [_actionContext      release];

    [super dealloc];
}

@end
