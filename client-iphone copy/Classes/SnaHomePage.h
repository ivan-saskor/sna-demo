
#import "_Fx.h"

#import "SnaTableViewPageController.h"

@interface SnaHomePageModel : NSObject
@end
@interface SnaHomePageController : SnaTableViewPageController
{
    @private BOOL _isInitStarted_SnaHomePageController;
    
    @private SnaHomePageModel *_model;
}

@end
