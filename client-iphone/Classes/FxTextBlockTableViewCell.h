
#import <UIKit/UIKit.h>

@interface FxTextBlockTableViewCell : UITableViewCell
{
    @private NSObject *_boundObject;
    @private NSString *_propertyKey;
    @private NSString *_displayPropertyKey;
}

@property(nonatomic, retain) UILabel *captionLabel;
@property(nonatomic, retain) UILabel *contentLabel;

- (void) bindToBoundObject:(NSObject *)boundObject withPropertyKey:(NSString *)propertyKey displayPropertyKey:(NSString *)dispalayPropertyKey;

@end
