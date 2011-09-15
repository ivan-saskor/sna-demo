
#import "_Fx.h"

#import "SnaTableViewPageController.h"

@interface SnaSignUpPageModel : NSObject

@property(nonatomic, copy, readwrite) NSString *email;
@property(nonatomic, copy, readwrite) NSString *password;
@property(nonatomic, copy, readwrite) NSString *nick;

@end
@interface SnaSignUpPageController : SnaTableViewPageController
{
    @private BOOL _isInitStarted_SnaSignUpPageController;
    
    @private SnaSignUpPageModel *_model;
}
@end
