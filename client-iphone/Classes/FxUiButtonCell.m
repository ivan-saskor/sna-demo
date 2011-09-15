
#import "FxUiButtonCell.h"

@implementation FxUiButtonCell

static const NSInteger _CELL_HEIGHT = 37; 

@synthesize caption      = _caption;

@synthesize targetObject = _targetObject;
@synthesize action       = _action;

- (id) initWithHeight:(NSInteger)height
{
    @throw [NSException exceptionWithName:@"Init with height is not supported" reason:nil userInfo:nil];
}
- (id) initWithCaption:(NSString *)caption targetObject:(NSObject *)targetObject action:(SEL)action
{
    self = [super initWithHeight:_CELL_HEIGHT canBecomeFirstResponder:NO];
    
    if (!self) @throw [NSException exceptionWithName:@"Init failed" reason:nil userInfo:nil];
    
    _caption      = [caption      copy  ];
    
    _targetObject = [targetObject retain];
    _action       =  action              ;
    
    return self;
}

- (void) dealloc
{
    [_caption      release];

    [_targetObject release];
    
    [super dealloc];
}

@end
