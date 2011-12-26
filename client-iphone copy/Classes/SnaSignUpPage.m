
#import "SnaSignUpPage.h"

@implementation SnaSignUpPageModel

@synthesize email                       = _email;
@synthesize password                    = _password;
@synthesize nick                        = _nick;
@synthesize mood                        = _mood;
@synthesize bornOnAsString              = _bornOnAsString;
@synthesize genderAsString              = _genderAsString;
@synthesize lookingForGendersAsString   = _lookingForGendersAsString;
@synthesize myDescription               = _myDescription;
@synthesize occupation                  = _occupation;
@synthesize hobby                       = _hobby;
@synthesize mainLocation                = _mainLocation;
@synthesize phone                       = _phone;

- (id) init
{
    self = [super init];
    
    [FxAssert isNotNullValue:self];
    
    _email                      = @"";
    _password                   = @"";
    _nick                       = @"";
    _mood                       = @"";
    _bornOnAsString             = @"";
    _genderAsString             = @"";
    _lookingForGendersAsString  = @"";
    _myDescription              = @"";
    _occupation                 = @"";
    _hobby                      = @"";
    _mainLocation               = @"";
    _phone                      = @"";
    
    return self;
}

- (void) dealloc
{
    [_email                     release];
    [_password                  release];
    [_nick                      release];
    [_mood                      release];
    [_bornOnAsString            release];
    [_genderAsString 			release];
    [_lookingForGendersAsString release];
    [_myDescription 			release];
    [_occupation 				release];
    [_hobby 					release];
    [_mainLocation              release];
    [_phone                     release];
    
    [super dealloc];
}

@end

@interface SnaSignUpPageController()

- (BOOL)isValidDate:(NSString *)dateAsString;
- (BOOL)isValidGender:(NSString *)genderAsString;
- (BOOL)isValidGenders:(NSString *)gendersAsString;

- (NSDate *)convertDate:(NSString *)dateAsString;
- (SnaGender *)convertGender:(NSString *)genderAsString;
- (NSSet *)convertGenders:(NSString *)gendersAsString;

@end

@implementation SnaSignUpPageController

- (id) init
{
    _isInitStarted_SnaSignUpPageController = YES;
    
    self = [super init];
    
    [FxAssert isNotNullValue:self];
    
    _model = [[SnaSignUpPageModel alloc] init];
    
    return self;
}
- (id) initWithStyle:(UITableViewStyle)style
{
    if (_isInitStarted_SnaSignUpPageController)
    {
        return [super initWithStyle:style];
    }
    else
    {
        @throw [FxException unsupportedMethodException];
    }
}

- (void) dealloc
{
    [_model release];
    
    [super dealloc];
}

- (void) onPageRefresh
{
    super.title     = @"Sign Up";
    super.backTitle = @"Log In";
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(signUp:)] autorelease];
    
    FxUiSection *logInDataSection = [super addSection];
    {
        [logInDataSection addTextFieldCellWithPlaceholder:@"Email"    boundObject:_model propertyKey:@"email"    isEmail   :YES];
        [logInDataSection addTextFieldCellWithPlaceholder:@"Password" boundObject:_model propertyKey:@"password" isPassword:YES];
    }

    FxUiSection *nickSection = [super addSection];
    {
        [nickSection addTextFieldCellWithPlaceholder:@"Nick" boundObject:_model propertyKey:@"nick"];
        [nickSection addTextFieldCellWithPlaceholder:@"Mood" boundObject:_model propertyKey:@"mood"];
    }
    
    FxUiSection *otherSection = [super addSection];
    {
        [otherSection addTextFieldCellWithPlaceholder:@"Born on [dd.mm.yyyy]" boundObject:_model propertyKey:@"bornOnAsString"];
        [otherSection addTextFieldCellWithPlaceholder:@"Gender [m/f]"         boundObject:_model propertyKey:@"genderAsString"];
        [otherSection addTextFieldCellWithPlaceholder:@"Looking for [m/f/a]"  boundObject:_model propertyKey:@"lookingForGendersAsString"];
    }
    
    FxUiSection *additionalSection = [super addSection];
    {
        [additionalSection addTextFieldCellWithPlaceholder:@"Description" boundObject:_model propertyKey:@"myDescription"];
        [additionalSection addTextFieldCellWithPlaceholder:@"Occupation"  boundObject:_model propertyKey:@"occupation"];
        [additionalSection addTextFieldCellWithPlaceholder:@"Hobby"       boundObject:_model propertyKey:@"hobby"];
    }
    
    FxUiSection *lastSection = [super addSection];
    {
        [lastSection addTextFieldCellWithPlaceholder:@"Main location" boundObject:_model propertyKey:@"mainLocation"];
        [lastSection addTextFieldCellWithPlaceholder:@"Phone"         boundObject:_model propertyKey:@"phone"];
    }
    
	#ifdef DEBUG
    {
        FxUiSection *testSection = [super addSectionWithCaption:@"Test"];
        {
            [testSection addButtonCellWithCaption:@"Fill All Fields"     targetObject:self action:@selector(testFillAllFields:)];
            [testSection addButtonCellWithCaption:@"Fill Existing Email" targetObject:self action:@selector(testFillExistingEmail:)];
            [testSection addButtonCellWithCaption:@"Fill Existing Nick"  targetObject:self action:@selector(testFillExistingNick:)];
        }
    }
	#endif
}

- (void) signUp:(id)sender
{
    if (![self isValidDate:_model.bornOnAsString])
    {
        [[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid date in Born on!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
        return;
    }
    if (![self isValidGender:_model.genderAsString])
    {
        [[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid gender field!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
        return;
    }
    if (![self isValidGenders:_model.lookingForGendersAsString])
    {
        [[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid gender in Looking for field!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
        return;
    }

    BOOL isSuccesfull = [self.dataService trySignUpWithEmail:_model.email
                                                    password:_model.password
                                                        nick:_model.nick
                                                        mood:_model.mood
                                                      bornOn:[self convertDate: _model.bornOnAsString]
                                                      gender:[self convertGender: _model.genderAsString]
                                           lookingForGenders:[self convertGenders: _model.lookingForGendersAsString]
                                               myDescription:_model.myDescription
                                                  occupation:_model.occupation
                                                       hobby:_model.hobby
                                                mainLocation:_model.mainLocation
                                                       phone:_model.phone];
    
    if (isSuccesfull)
    {
        [self showHomePage];
    }
    else
    {
        [[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sign up failed!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }
}

- (BOOL)isValidDate:(NSString *)dateAsString
{
    [FxAssert isNotNullArgument:dateAsString withName:@"dateAsString"];
    
    if ([dateAsString isEqualToString:@""]) { return YES; }
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    
    [formatter setDateFormat:@"dd.MM.yyyy"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSLog(@"%@", [formatter dateFromString:dateAsString]);
    
    if ([formatter dateFromString:dateAsString] != nil)
        return YES;
    
    return NO;
}
- (BOOL)isValidGender:(NSString *)genderAsString
{
    [FxAssert isNotNullArgument:genderAsString withName:@"genderAsString"];
    
    if ([genderAsString isEqualToString:@""]) { return YES; }
    
    if ([genderAsString isEqualToString:@"m"]) { return YES; }
    if ([genderAsString isEqualToString:@"f"]) { return YES; }
    if ([genderAsString isEqualToString:@"M"]) { return YES; }
    if ([genderAsString isEqualToString:@"F"]) { return YES; }
    
    return NO;
}
- (BOOL)isValidGenders:(NSString *)gendersAsString
{
    [FxAssert isNotNullArgument:gendersAsString withName:@"gendersAsString"];
    
    if ([gendersAsString isEqualToString:@""]) { return YES; }
    
    if ([gendersAsString isEqualToString:@"m"]) { return YES; }
    if ([gendersAsString isEqualToString:@"f"]) { return YES; }
    if ([gendersAsString isEqualToString:@"a"]) { return YES; }
    if ([gendersAsString isEqualToString:@"M"]) { return YES; }
    if ([gendersAsString isEqualToString:@"F"]) { return YES; }
    if ([gendersAsString isEqualToString:@"A"]) { return YES; }
    
    return NO;
}

- (NSDate *)convertDate:(NSString *)dateAsString
{
    [FxAssert isNotNullArgument:dateAsString withName:@"dateAsString"];
    [FxAssert isValidArgument:dateAsString withName:@"dateAsString" validation:[self isValidDate:dateAsString]];
    
    if ([dateAsString isEqualToString:@""]) { return nil; }

    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    
    [formatter setDateFormat:@"dd'.'MM'.'yyyy"];
    
    return [formatter dateFromString:dateAsString];
}
- (SnaGender *)convertGender:(NSString *)genderAsString
{
    [FxAssert isNotNullArgument:genderAsString withName:@"genderAsString"];
    [FxAssert isValidArgument:genderAsString withName:@"genderAsString" validation:[self isValidGender:genderAsString]];
    
    if ([genderAsString isEqualToString:@""]) { return nil; }
    
    if ([genderAsString isEqualToString:@"m"]) { return [SnaGender MALE]; }
    if ([genderAsString isEqualToString:@"f"]) { return [SnaGender FEMALE]; }
    if ([genderAsString isEqualToString:@"M"]) { return [SnaGender MALE]; }
    if ([genderAsString isEqualToString:@"F"]) { return [SnaGender FEMALE]; }
    
    @throw [FxException invalidStateExceptionWithReason:@"impossible code path reached"];
}
- (NSSet *)convertGenders:(NSString *)gendersAsString
{
    [FxAssert isNotNullArgument:gendersAsString withName:@"gendersAsString"];
    [FxAssert isValidArgument:gendersAsString withName:@"gendersAsString" validation:[self isValidGenders:gendersAsString]];
    
    if ([gendersAsString isEqualToString:@""]) { return [NSSet set]; }
    
    if ([gendersAsString isEqualToString:@"m"]) { return [NSSet setWithObject:[SnaGender MALE]]; }
    if ([gendersAsString isEqualToString:@"f"]) { return [NSSet setWithObject:[SnaGender FEMALE]]; }
    if ([gendersAsString isEqualToString:@"M"]) { return [NSSet setWithObject:[SnaGender MALE]]; }
    if ([gendersAsString isEqualToString:@"F"]) { return [NSSet setWithObject:[SnaGender FEMALE]]; }
    
    @throw [FxException invalidStateExceptionWithReason:@"impossible code path reached"];
}


#ifdef DEBUG

- (void) testFillAllFields:(id)sender
{
    SnaPerson *newProfile = [self.dataService testGenerateNewProfile];
    
    _model.email    = newProfile.email;
    _model.password = newProfile.password;
    _model.nick     = newProfile.nick;
    
    [self refreshPage];
}
- (void) testFillExistingEmail:(id)sender
{
    _model.email = [self.dataService testGetRandomPerson].email;
    
    [self refreshPage];
}
- (void) testFillExistingNick:(id)sender
{
    _model.nick = [self.dataService testGetRandomPerson].nick;
    
    [self refreshPage];
}

#endif

@end
