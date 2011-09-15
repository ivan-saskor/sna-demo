
#import <UIKit/UIKit.h>

#import "_Services.h"

@interface SnaApplicationDelegate : NSObject <UIApplicationDelegate>
{
    UIWindow               *_window;
    UINavigationController *_navigationController;
}

@property(nonatomic, retain) IBOutlet UIWindow *window;
@property(nonatomic, retain) IBOutlet UINavigationController *navigationController;

+ (SnaApplicationDelegate *) INSTANCE;

- (void) flipToLoginPage;
- (void) flipToHomePage;

@end

