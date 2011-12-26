
#import "FxUiTextFieldCell.h"

@implementation FxUiTextFieldCell

static const NSInteger _CELL_HEIGHT = 44; 

@synthesize placeHolder = _placeHolder;
@synthesize boundObject = _boundObject;
@synthesize propertyKey = _propertyKey;
@synthesize isPassword  = _isPassword;
@synthesize isEmail     = _isEmail;

- (id) initWithHeight:(NSInteger)height
{
    @throw [NSException exceptionWithName:@"Init with height is not supported" reason:nil userInfo:nil];
}
- (id) initWithPlaceholder:(NSString *)placeholder boundObject:(NSObject *)boundObject propertyKey:(NSString *)propertyKey isPassword:(BOOL)isPassword isEmail:(BOOL)isEmail
{
    self = [super initWithHeight:_CELL_HEIGHT canBecomeFirstResponder:YES];
    
    if (!self) @throw [NSException exceptionWithName:@"Init failed" reason:nil userInfo:nil];

    _placeHolder = [placeholder copy  ];
    _boundObject = [boundObject retain];
    _propertyKey = [propertyKey copy  ];
    _isPassword  =  isPassword         ;
    _isEmail     =  isEmail            ;
    
    return self;
}

- (void) _textFieldValueChanged:(id)sender
{
    UITextField *textField = sender;
    
    [self.boundObject setValue:textField.text forKey:self.propertyKey];
}

- (void) dealloc
{
    [_placeHolder release];
    [_boundObject release];
    [_propertyKey release];
    
    [super dealloc];
}

@end
