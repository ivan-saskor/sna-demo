
#import "_Fx.h"

#import "SnaTableViewPageController.h"

@interface SnaProfilePageModel : NSObject

@property(nonatomic, readonly) SnaPerson *currentUser;

- (id) initWithCurrentUser:(SnaPerson *)currentUser;

@end
@interface SnaProfilePageController : SnaTableViewPageController
{
    @private BOOL _isInitStarted_SnaProfilePageController;

    @private SnaProfilePageModel *_model;
}

@end
