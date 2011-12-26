#import "_Fx.h"

#import "SnaTableViewPageController.h"

@interface SnaSignUpPageModel : NSObject

@property(nonatomic, copy, readwrite) NSString *email;
@property(nonatomic, copy, readwrite) NSString *password;
@property(nonatomic, copy, readwrite) NSString *nick;
@property(nonatomic, copy, readwrite) NSString *mood;
@property(nonatomic, copy, readwrite) NSString *bornOnAsString;
@property(nonatomic, copy, readwrite) NSString *genderAsString;
@property(nonatomic, copy, readwrite) NSString *lookingForGendersAsString;
@property(nonatomic, copy, readwrite) NSString *myDescription;
@property(nonatomic, copy, readwrite) NSString *occupation;
@property(nonatomic, copy, readwrite) NSString *hobby;
@property(nonatomic, copy, readwrite) NSString *mainLocation;
@property(nonatomic, copy, readwrite) NSString *phone;

@end
@interface SnaSignUpPageController : SnaTableViewPageController
{
    @private BOOL _isInitStarted_SnaSignUpPageController;
    
    @private SnaSignUpPageModel *_model;
}
@end