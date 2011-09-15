
#import "_Fx.h"

#import "SnaTableViewPageController.h"

@interface SnaChangeMoodPageModel : NSObject

@property(nonatomic, copy, readwrite) NSString *mood;

- (id) initWithMood:(NSString *)mood;

@end
@interface SnaChangeMoodPageController : SnaTableViewPageController
{
    @private BOOL _isInitStarted_SnaChangeMoodPageController;
    
    @private SnaChangeMoodPageModel *_model;
}
@end
