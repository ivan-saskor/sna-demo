
#import "_Fx.h"

#import "SnaTableViewPageController.h"

@interface SnaMessagesPageModel : NSObject

@property(nonatomic, readonly) NSArray *friendsWithMessages;

- (id) initWithFriendsWithMessages:(NSArray *)friendsWithMessages;

@end
@interface SnaMessagesPageController : SnaTableViewPageController
{
    @private BOOL _isInitStarted_SnaMessagesPageController;

    @private SnaMessagesPageModel *_model;
}
@end
