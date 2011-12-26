
#import <UIKit/UIKit.h>

@interface FxPageViewController : UIViewController

@property(nonatomic, copy) NSString *backTitle;

- (void) flipViewController:(UIViewController *)viewController;

@end
