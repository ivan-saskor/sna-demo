
#import <UIKit/UIKit.h>

@interface FxButtonTableViewCell : UITableViewCell
{
    NSObject *_targetObject;
    SEL       _action;
}

@property(nonatomic,retain) UIButton *button;

- (void) bindToTarget:(NSObject *)targetObject action:(SEL)action;

@end
