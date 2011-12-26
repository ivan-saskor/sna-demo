
#import "_Fx.h"

#import "SnaTableViewPageController.h"

@interface SnaFriendsPageModel : NSObject

@property(nonatomic, readonly) NSArray *friends;

- (id) initWithFriends:(NSArray *)friends;

@end
@interface SnaFriendsPageController : SnaTableViewPageController
{
    @private BOOL _isInitStarted_SnaFriendsPageController;
    
    @private SnaFriendsPageModel *_model;
}
@end
