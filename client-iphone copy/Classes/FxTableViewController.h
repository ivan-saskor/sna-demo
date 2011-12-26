
#import <UIKit/UIKit.h>

#import "FxUiSection.h"

@interface FxTableViewController : UITableViewController
{
    @private BOOL _isInitStarted_FxTableViewController;
    
    @private NSMutableArray *_sections;
    @private NSMutableArray *_pageRefreshTriggers;
    
    @private BOOL _canAddPageRefreshTrigger;
}

@property(nonatomic, copy    ) NSString *backTitle;
@property(nonatomic, readonly) NSArray  *sections;
@property(nonatomic, readonly) id        firstResponderCell;

- (void) refreshPage;
- (void) onPageRefresh;

- (void) addPageRefreshTriggerWithBoundObject:(NSObject *)boundObject propertyKey:(NSString *)propertyKey;

- (FxUiSection *) sectionAtIndex:(NSInteger)index;
- (FxUiSection *) addSection;
- (FxUiSection *) addSectionWithCaption:(NSString *)caption;
- (void) removeAllSections;

- (void) addPageRefreshTriggerWithBoundObject:(NSObject *)boundObject propertyKey:(NSString *)propertyKey;
- (void) removeAllPageRefreshTriggers;

- (void) pushViewController     :(UIViewController *)viewController;
- (void) flipViewController     :(UIViewController *)viewController;
- (void) showMadalViewController:(UIViewController *)viewController;
- (void) popViewController;

@end
