
#import "FxUiCell.h"

@implementation FxUiCell

@synthesize height                  = _height;
@synthesize canBecomeFirstResponder = _canBecomeFirstResponder;

- (id) init
{
    @throw [NSException exceptionWithName:@"Init is not supported" reason:nil userInfo:nil];
}
- (id) initWithHeight:(NSInteger)height canBecomeFirstResponder:(BOOL)canBecomeFirstResponder
{
    self = [super init];
    
    if (!self) @throw [NSException exceptionWithName:@"Init failed" reason:nil userInfo:nil];
    
    _height                  = height;
    _canBecomeFirstResponder = canBecomeFirstResponder;
    
    return self;
}

- (void) didSelect
{
}

- (void) dealloc
{
    [super dealloc];
}

@end
