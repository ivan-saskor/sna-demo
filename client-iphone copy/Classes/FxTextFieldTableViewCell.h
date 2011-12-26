
#import <UIKit/UIKit.h>

@interface FxTextFieldTableViewCell : UITableViewCell
{
    NSObject *_targetObject;
    SEL       _action;
}

@property(nonatomic,retain) UITextField *textField;

- (void) bindToTarget:(NSObject *)targetObject action:(SEL)action;

@end
