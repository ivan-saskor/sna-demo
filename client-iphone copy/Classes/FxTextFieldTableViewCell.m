
#import "FxTextFieldTableViewCell.h"

@implementation FxTextFieldTableViewCell

@synthesize textField = _textField;

- (void) bindToTarget:(NSObject *)targetObject action:(SEL)action;
{
    [self.textField removeTarget:_targetObject action:_action forControlEvents:UIControlEventEditingChanged];
    
    _targetObject = [targetObject retain];
    _action       =  action;
    
    [self.textField addTarget:_targetObject action:_action forControlEvents:UIControlEventEditingChanged];
}

- (void)dealloc
{
    [self.textField removeTarget:_targetObject action:_action forControlEvents:UIControlEventEditingChanged];

    [_targetObject release];
    
    [_textField release];
    
    [super dealloc];
}

@end
