
#import "_Fx.h"

#import "SnaTableViewPageController.h"

@interface SnaMessagePageModel : NSObject

@property(nonatomic, readonly) SnaMessage *message;

- (id) initWithMessage:(SnaMessage *)message;

@end
@interface SnaMessagePageController : SnaTableViewPageController
{
    @private BOOL _isInitStarted_SnaMessagePageController;
    
    @private SnaMessagePageModel *_model;
}

- (id) initWithMessage:(SnaMessage *)message;

@end
