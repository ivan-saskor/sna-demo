
#import <UIKit/UIKit.h>

@interface FxItemTableViewCell : UITableViewCell
{
    @private NSObject *_captionBoundObject;
    @private NSString *_captionPropertyKey;

    @private NSObject *_contentBoundObject;
    @private NSString *_contentPropertyKey;
}

- (void) bindToCaptionBoundObject:(NSObject *)captionBoundObject withCaptionPropertyKey:(NSString *)captionPropertyKey toContentBoundObject:(NSObject *)contentBoundObject withContentPropertyKey:(NSString *)contentPropertyKey;

@end
