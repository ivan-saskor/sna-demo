
#import "FxButtonTableViewCell.h"

@implementation FxButtonTableViewCell

@synthesize button = _button;

- (void) bindToTarget:(NSObject *)targetObject action:(SEL)action;
{
    [self.button removeTarget:_targetObject action:_action forControlEvents:UIControlEventTouchUpInside];
    
    _targetObject = [targetObject retain];
    _action       =  action;
    
    [self.button addTarget:_targetObject action:_action forControlEvents:UIControlEventTouchUpInside];
}

- (void)dealloc
{
    [self.button removeTarget:_targetObject action:_action forControlEvents:UIControlEventTouchUpInside];

    [_targetObject release];
    
    [_button release];
    
    [super dealloc];
}

@end
