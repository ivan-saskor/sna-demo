
#import "_Fx.h"

#import "SnaTableViewPageController.h"

@interface SnaLogInPageModel : NSObject

@property(nonatomic, copy) NSString *email;
@property(nonatomic, copy) NSString *password;

- (id) initWithEmail:(NSString *)email password:(NSString *)password;

@end
@interface SnaLogInPageController : SnaTableViewPageController
{
    @private BOOL _isInitStarted_SnaLogInPageController;
    
    @private SnaLogInPageModel *_model;
}
@end
