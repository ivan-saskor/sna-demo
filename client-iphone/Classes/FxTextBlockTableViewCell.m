
#import "FxTextBlockTableViewCell.h"

@interface FxTextBlockTableViewCell()

- (void) _startObserving;
- (void) _stopObserving;

@end
@implementation FxTextBlockTableViewCell

@synthesize captionLabel = _captionLabel;
@synthesize contentLabel = _contentLabel;

- (void) bindToBoundObject:(NSObject *)boundObject withPropertyKey:(NSString *)propertyKey displayPropertyKey:(NSString *)dispalayPropertyKey
{
    [self _stopObserving];
    
    _boundObject        = [boundObject         retain];
    _propertyKey        = [propertyKey         copy  ];
    _displayPropertyKey = [dispalayPropertyKey copy  ];

    [self _startObserving];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _boundObject)
    {
        if ([keyPath isEqual:_propertyKey])
        {
            if (_displayPropertyKey != nil)
            {
                self.contentLabel.text = [[change objectForKey:NSKeyValueChangeNewKey] valueForKey:_displayPropertyKey];
            }
            else
            {
                self.contentLabel.text = [change objectForKey:NSKeyValueChangeNewKey];
            }
        }
    }
    
    //[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void) dealloc
{
    [self _stopObserving];
    
    [_boundObject         release];
    [_propertyKey         release];
    [_displayPropertyKey  release];
    
    [_captionLabel release];
    [_contentLabel release];
    
    [super dealloc];
}

- (void) _startObserving
{
    [_boundObject addObserver:self forKeyPath:_propertyKey options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];

    if (_displayPropertyKey != nil)
    {
        self.contentLabel.text = [[_boundObject valueForKey:_propertyKey] valueForKey:_displayPropertyKey];
    }
    else
    {
        self.contentLabel.text = [_boundObject valueForKey:_propertyKey];
    }
}
- (void) _stopObserving
{
    [_boundObject removeObserver:self forKeyPath:_propertyKey];
}

@end
