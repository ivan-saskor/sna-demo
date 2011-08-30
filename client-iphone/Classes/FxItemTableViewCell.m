
#import "FxItemTableViewCell.h"

@interface FxItemTableViewCell()

- (void) _startObserving;
- (void) _stopObserving;

@end
@implementation FxItemTableViewCell

- (void) bindToCaptionBoundObject:(NSObject *)captionBoundObject withCaptionPropertyKey:(NSString *)captionPropertyKey toContentBoundObject:(NSObject *)contentBoundObject withContentPropertyKey:(NSString *)contentPropertyKey;
{
    [self _stopObserving];
    
    _captionBoundObject = [captionBoundObject retain];
    _captionPropertyKey = [captionPropertyKey copy  ];

    _contentBoundObject = [contentBoundObject retain];
    _contentPropertyKey = [contentPropertyKey copy  ];

    [self _startObserving];
}

- (void) dealloc
{
    [self _stopObserving];
    
    [_captionBoundObject  release];
    [_captionPropertyKey  release];

    [_contentBoundObject  release];
    [_contentPropertyKey  release];

    [super dealloc];
}


- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _captionBoundObject)
    {
        if ([keyPath isEqual:_captionPropertyKey])
        {
            self.textLabel.text = [change objectForKey:NSKeyValueChangeNewKey];
        }
    }
    if (object == _contentBoundObject)
    {
        if ([keyPath isEqual:_contentPropertyKey])
        {
            self.detailTextLabel.text = [change objectForKey:NSKeyValueChangeNewKey];
        }
    }
    
    //[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void) _startObserving
{
    [_contentBoundObject addObserver:self forKeyPath:_contentPropertyKey options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    [_captionBoundObject addObserver:self forKeyPath:_captionPropertyKey options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    
    self.textLabel.text       = [_captionBoundObject valueForKey:_captionPropertyKey];
    self.detailTextLabel.text = [_contentBoundObject valueForKey:_contentPropertyKey];
}
- (void) _stopObserving
{
    [_contentBoundObject removeObserver:self forKeyPath:_contentPropertyKey];
    [_captionBoundObject removeObserver:self forKeyPath:_captionPropertyKey];
}

@end
