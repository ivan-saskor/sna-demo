#import "ServerConnector.h"
#import "SnaJsonWrapper.h"
#import "_Domain.h"
#import "Constants.h"

@interface ServerConnector()
- (NSDictionary *)dictonarizePerson:(SnaPerson *) person withLocation:(SnaLocation *) location;

- (BOOL)isRequestSuccessfulForData:(NSData *)data;
- (NSDate *)dateFromRFC3339String:(NSString *)rfc3339DateTimeString withFormat:(NSString *) format;
- (NSString *)stringFromSmallDate:(NSDate *) date;
- (NSString *)_stringForField:(NSString *)field FromDictionary:(NSDictionary *) dictionary;
- (NSString *)_stringForField:(NSString *)field FromDictionary:(NSDictionary *) dictionary orDefault:(NSString *) defaultValue;
- (NSInteger)_integerForField:(NSString *)field FromDictionary:(NSDictionary *) dictionary;
- (NSDate *)_dateForField:(NSString *)field FromDictionary:(NSDictionary *) dictionary withFormat:(NSString *) format;
- (NSArray *)_arrayForField:(NSString *)field FromDictionary:(NSDictionary *) dictionary;

- (NSData *)sendHttpRequestWithUrl:(NSString *)url httpParams:(NSDictionary *)params httpBodyParams:(NSDictionary *) bodyParams httpMethod:(NSString *) method;
@end

@implementation ServerConnector

- (id)initWithUrlPrefix:(NSString *)prefix
{
    self = [super init];
    if (self) {
        _persons = [[NSMutableArray alloc] init];
        _messages = [[NSMutableArray alloc] init];
        _urlPrefix = [prefix copy];
    }
    
    return self;
}

- (void) dealloc
{
    [_persons release];
    [_messages release];
    [_urlPrefix release];
    
    [super dealloc];
}

- (NSData *)sendHttpRequestWithUrl:(NSString *)url httpParams:(NSDictionary *)params httpBodyParams:(NSDictionary *) bodyParams httpMethod:(NSString *) method
{
    NSString *escapedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSMutableURLRequest *dataRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:escapedUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSMutableString *httpBody = [NSMutableString string];
    
    if (params != nil && [params count] > 0)
    {
        for(NSString *key in params)
        {
            [dataRequest addValue:[params objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    if (method != nil && ([method isEqualToString:@"POST"] || [method isEqualToString:@"PUT"])) {
        if (bodyParams != nil && [bodyParams count] > 0)
        {
            for(NSString *key in bodyParams)
            {
                [httpBody appendFormat:@"%@=%@&", key, [bodyParams objectForKey:key]];
            }
            
            NSString *postParams = [[httpBody substringToIndex:[httpBody length]-1] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSData *postData = [NSData dataWithBytes: [postParams UTF8String] length: [postParams length]];
            
            [dataRequest setHTTPBody:postData];
        }
        
        if ([method isEqualToString:@"POST"])
        {
            [dataRequest setHTTPMethod:@"POST"];
        }
        else
        {
            [dataRequest setHTTPMethod:@"PUT"];
            [dataRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        }
    }
    
    return [NSURLConnection sendSynchronousRequest:dataRequest returningResponse:nil error:nil];
}

- (NSData *)sendGetRequestWithURL:(NSString *)url httpParams:(NSDictionary *)params
{
    NSLog(@"Sending GET request to %@", url);
    return [self sendHttpRequestWithUrl:url httpParams:params httpBodyParams:nil httpMethod:nil];
}

- (NSData *)sendPostRequestWithURL:(NSString *)url httpParams:(NSDictionary *)params httpBodyParams:(NSDictionary *) bodyParams
{
    NSLog(@"Sending POST request to %@", url);
    
    return [self sendHttpRequestWithUrl:url httpParams:params httpBodyParams:bodyParams httpMethod:@"POST"];
}

- (NSData *)sendPutRequestWithURL:(NSString *)url httpParams:(NSDictionary *)params httpBodyParams:(NSDictionary *) bodyParams
{
    NSLog(@"Sending PUT request to %@", url);
    return [self sendHttpRequestWithUrl:url httpParams:params httpBodyParams:bodyParams httpMethod:@"PUT"];
}

- (BOOL)sendDataRequestForEmail:(NSString *)email withPassword:(NSString *)password
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:email, @"EMAIL", password, @"PASSWORD", nil];
    
    NSData * data = [self sendGetRequestWithURL:[NSString stringWithFormat:@"%@/api/data", _urlPrefix] httpParams:params];

    NSLog(@"data request sent");
    
    if ([self isRequestSuccessfulForData:data]) {
        [_data release];
        _data = data;
        [_data retain];
        
        [self populatePersons];
        [self populateMessages];
        return YES;
    }
    return NO;
}

- (void) resetData
{
    [_messages removeAllObjects];
    [_persons removeAllObjects];
}

- (NSMutableArray *)getPersons
{
	return _persons;
}

- (NSMutableArray *)getMessages
{
	return _messages;
}

- (NSString *) _cleanString:(NSString *) string
{
    if ([string isKindOfClass:[NSNull class]] || string == NULL) {
        return nil;
    }
    return string;
}

- (NSInteger) _cleanIntegerAsString:(NSString *) integerAsString
{
    if ([integerAsString isKindOfClass:[NSNull class]] || integerAsString == NULL) {
        return 0;
    }
    
    return [integerAsString integerValue];
}

- (NSString *)_stringForField:(NSString *)field FromDictionary:(NSDictionary *) dictionary
{
    return [self _stringForField:field FromDictionary:dictionary orDefault:nil];
}

- (NSString *)_stringForField:(NSString *)field FromDictionary:(NSDictionary *) dictionary orDefault:(NSString *) defaultValue
{
    if ([[[dictionary keyEnumerator] allObjects] containsObject:field]) 
    {
        return [self _cleanString:[dictionary valueForKey:field]];
    }
    else
    {
        return defaultValue;
    }
}

- (NSInteger)_integerForField:(NSString *)field FromDictionary:(NSDictionary *) dictionary
{
    if ([[[dictionary keyEnumerator] allObjects] containsObject:field]) 
    {
        return [self _cleanIntegerAsString:[dictionary valueForKey:field]];
    }
    else
    {
        return 0;
    }
}

- (NSDate *)_dateForField:(NSString *)field FromDictionary:(NSDictionary *) dictionary withFormat:(NSString *) format
{
    if ([[[dictionary keyEnumerator] allObjects] containsObject:field]) 
    {
        return [self dateFromRFC3339String:[self _cleanString:[dictionary valueForKey:field]] withFormat:format];
    }
    else
    {
        return nil;
    }
}

- (NSArray *)_arrayForField:(NSString *)field FromDictionary:(NSDictionary *) dictionary
{
    if ([[[dictionary keyEnumerator] allObjects] containsObject:field]) 
    {
        return [dictionary valueForKey:field];
    }
    else
    {
        return [NSArray array];
    }
}

- (void)populatePersons
{
    NSDictionary * theObject = [SnaJsonWrapper deserializeJsonData:_data];

//    NSMutableDictionary *theObject = [NSMutableDictionary dictionary];
//    
//    NSMutableArray *x = [NSMutableArray array];
//    
//    NSMutableDictionary *y = [NSMutableDictionary dictionary];
//    
//    [y setObject:@"x" forKey:@"Email"];
//    [y setObject:@"y" forKey:@"Password"];
//    [y setObject:@"Online" forKey:@"VisibilityStatus"];
//    //[y setObject:@"2011-07-29T00:43:00Z" forKey:@"OfflineSince"];
//    //[y setObject:nil forKey:@"OfflineSince"];
//    [y setObject:@"x-nick" forKey:@"Nick"];
//    [y setObject:@"Self" forKey:@"FriendshipStatus"];
//    
//    [x addObject:y];
//    
//    [theObject setObject:x forKey:@"Persons"];
        
    NSArray *persons = [theObject mutableArrayValueForKey:@"Persons"];
    
    for (int i=0; i < [persons count]; i++)
    {                           
        NSLog(@"Person number: %d", i);
        
        NSDictionary *json_person;
        json_person = [persons objectAtIndex:i];
        
        SnaMutablePerson *person = [self FindPersonByEmail:[self _cleanString:[json_person valueForKey:@"Email"]]];
        if (person == nil) {
            person = [[[SnaMutablePerson alloc]init] autorelease];
            [_persons addObject:person];
        }
        
        NSString *visibilityStatusAsString;
        NSString *offlineSinceAsString;
        NSString *friendshipStatusAsString;
        NSString *genderAsString;
        
        [person setEmail:       [self _stringForField:@"Email"          FromDictionary:json_person]];
        [person setPassword:    [self _stringForField:@"Password"       FromDictionary:json_person]];
        [person setNick:        [self _stringForField:@"Nick"           FromDictionary:json_person]];
        
        [person setMyDescription:[self _stringForField:@"Description"   FromDictionary:json_person]];
        [person setMood:        [self _stringForField:@"Mood"           FromDictionary:json_person]];
        [person setPhone:       [self _stringForField:@"Phone"          FromDictionary:json_person]];
        [person setOccupation:  [self _stringForField:@"Occupation"     FromDictionary:json_person]];
        [person setHobby:       [self _stringForField:@"Hobby"          FromDictionary:json_person]];
        [person setMainLocation:[self _stringForField:@"MainLocation"   FromDictionary:json_person]];
        [person setGravatarCode:[self _stringForField:@"GravatarCode"   FromDictionary:json_person]];
        
        [person setBornOn:[self _dateForField:@"BornOn" FromDictionary:json_person withFormat:ShortDate]];
        
        [person setDistanceInMeeters:[self _integerForField:@"DistanceInMeters" FromDictionary:json_person]];
        
        visibilityStatusAsString = [self _stringForField:@"VisibilityStatus" FromDictionary:json_person];
        offlineSinceAsString = [self _stringForField:@"OfflineSince" FromDictionary:json_person];
        friendshipStatusAsString = [self _stringForField:@"FriendshipStatus" FromDictionary:json_person];
        genderAsString = [self _stringForField:@"Gender" FromDictionary:json_person];
        
        if ([visibilityStatusAsString isEqualToString:@"Online"]) 
        {
            [person setVisibilityStatus:[SnaVisibilityStatus ONLINE]];
        }
        else if ([visibilityStatusAsString isEqualToString:@"Offline"]) 
        {
            [person setVisibilityStatus:[SnaVisibilityStatus OFFLINE]];
        }
        else if ([visibilityStatusAsString isEqualToString:@"ContactMe"])
        {
            [person setVisibilityStatus:[SnaVisibilityStatus CONTACT_ME]];
        }
        else if ([visibilityStatusAsString isEqualToString:@"Invisible"])
        {
            [person setVisibilityStatus:[SnaVisibilityStatus INVISIBLE]];
        }
        else if (visibilityStatusAsString == nil)
        {
            [person setVisibilityStatus:nil];
        }
        else
        {
            @throw [FxException exceptionWithName:@"Impossible CP reached" reason:@"Invalid visibility status" userInfo:nil];
        }
        
        if (offlineSinceAsString != nil)
        {
            [person setOfflineSince:[self dateFromRFC3339String:offlineSinceAsString withFormat:LongDate]];
        }
        else
        {
            [person setOfflineSince:nil];
        }
        
        if ([friendshipStatusAsString isEqualToString:@"Alien"])
        {
            [person setFriendshipStatus:[SnaFriendshipStatus ALIEN]];
        }
        else if ([friendshipStatusAsString isEqualToString:@"Self"])
        {
            [person setFriendshipStatus:[SnaFriendshipStatus SELF]];
        }
        else if ([friendshipStatusAsString isEqualToString:@"WaitingForHim"])
        {
            [person setFriendshipStatus:[SnaFriendshipStatus WAITING_FOR_HIM]];
        }
        else if ([friendshipStatusAsString isEqualToString:@"WaitingForMe"])
        {
            [person setFriendshipStatus:[SnaFriendshipStatus WAITING_FOR_ME]];
        }
        else if ([friendshipStatusAsString isEqualToString:@"Rejected"])
        {
            [person setFriendshipStatus:[SnaFriendshipStatus REJECTED]];
        }
        else if ([friendshipStatusAsString isEqualToString:@"Friend"])
        {
            [person setFriendshipStatus:[SnaFriendshipStatus FRIEND]];
        }
        else if (friendshipStatusAsString == nil)
        {
            [person setFriendshipStatus:nil];
        }
        else
        {
            @throw [FxException exceptionWithName:@"Impossible CP reached" reason:@"Invalid visibility status received from server" userInfo:nil];
        }
        
        if (genderAsString != nil && [genderAsString length] > 0)
        {
            if ([genderAsString isEqualToString:@"Male"])
            {
                [person setGender:[SnaGender MALE]];
            }
            else if ([genderAsString isEqualToString:@"Female"])
            {
                [person setGender:[SnaGender FEMALE]];
            }
            else if ([genderAsString isEqualToString:@"Other"])
            {
                [person setGender:[SnaGender OTHER]];
            }
            else
            {
                @throw [FxException exceptionWithName:@"Impossible CP reached" reason:@"Invalid gender received from server" userInfo:nil];
            }
        }

        [FxAssert isNotNullValue:person.email];
        [FxAssert isNotNullValue:person.password];
        [FxAssert isNotNullValue:person.visibilityStatus];
        [FxAssert isNotNullValue:person.nick];
        [FxAssert isNotNullValue:person.friendshipStatus];

        [[person lookingForGenders]removeAllObjects];
        NSArray *genders = [self _arrayForField:@"LookingForGenders" FromDictionary:json_person];
       
        for (int g=0; g<[genders count]; g++)
        {
            if ([[genders objectAtIndex:g] isEqualToString:@"Male"])
            {
                [[person lookingForGenders]addObject:[SnaGender MALE]];
            }
            if ([[genders objectAtIndex:g] isEqualToString:@"Female"])
            {
                [[person lookingForGenders]addObject:[SnaGender FEMALE]];
            }
            if ([[genders objectAtIndex:g] isEqualToString:@"Other"])
            {
                [[person lookingForGenders]addObject:[SnaGender OTHER]];
            }
        }
    }
}

- (SnaMutablePerson *)FindPersonByEmail:(NSString *)email
{
    for(int i=0; i<[_persons count]; i++)
    {
        if ([[[_persons objectAtIndex:i] email] isEqualToString:email])
        {
            return [_persons objectAtIndex:i];
        }
    }
    return nil;
}

- (SnaMutableMessage *)FindMessageById:(NSString *)id
{
    for(int i=0; i<[_messages count]; i++)
    {
        if ([[[_messages objectAtIndex:i] id] isEqualToString:id])
        {
            return [_messages objectAtIndex:i];
        }
    }
    
    return nil;
    
    @throw ([NSException exceptionWithName:@"error" reason:@"no email found" userInfo:nil]);
}

- (void)populateMessages
{
    NSDictionary * theObject = [SnaJsonWrapper deserializeJsonData:_data];
    NSArray *messages = [theObject mutableArrayValueForKey:@"Messages"];
        
    for (int i=0; i<[messages count]; i++)
    {                           
        NSDictionary *json_message = [messages objectAtIndex:i];
        
        SnaMutableMessage *message;
        message = [self FindMessageById:[json_message valueForKey:@"Id"]];
        if (message == nil) {
            message = [[[SnaMutableMessage alloc]init] autorelease];
            [_messages addObject:message];
        }
        
        [message setId:[self _stringForField:@"Id" FromDictionary:json_message]];
        [message setFrom:[self FindPersonByEmail:[self _stringForField:@"FromEmail" FromDictionary:json_message]]];
        [message setTo:[self FindPersonByEmail:[self _stringForField:@"ToEmail" FromDictionary:json_message]]];
        [message setText:[self _stringForField:@"Text" FromDictionary:json_message]];
        [message setSentOn:[self _dateForField:@"SentOn" FromDictionary:json_message withFormat:LongDate]];
        [message setReadOn:[self _dateForField:@"ReadOn" FromDictionary:json_message withFormat:LongDate]];
        
        NSLog(@"From email: %@", message.from.email);
        NSLog(@"Read on: %@", message.readOn);
        NSLog(@"Sent on: %@", message.sentOn);
        NSLog(@"ToEmail: %@", message.to.email);
        NSLog(@"Text: %@", message.text);
        NSLog(@"Id: %@", message.id);
    }
}

//- (void)populateEmails
//{
//    NSError *theError = nil;
//    NSDictionary *theObject = [NSDictionary dictionaryWithDictionary:[[CJSONDeserializer deserializer] deserialize:_data error:&theError]];
//    
//    if (theError == nil) 
//    {
//        //NSLog(@"no error loading json");
//        
//        NSArray *emails = [theObject mutableArrayValueForKey:@"NearbyPersonsEmails"];
//        
//        for (int i=0; i<[emails count]; i++)
//        {                           
//            //NSDictionary *json_person;
//            NSValue *json_email = [emails objectAtIndex:i];
//            
////            [_persons addObject:person];
//            
//            NSLog(@"%@", json_email);
//        }
//    }
//    else
//    {
//        @throw ([NSException exceptionWithName:@"parse error" reason:@"can't parse json" userInfo:nil]);
//    }
//}

- (BOOL)sendFriendshipRequestFrom:(SnaPerson *)person1 to:(SnaPerson *)person2 withMessage:(NSString *)message
{
    NSString *url = [NSString stringWithFormat:@"%@/api/persons/%@/request-friendship", _urlPrefix, [person2 email]];
    NSDictionary *bodyParams = [NSDictionary dictionaryWithObjectsAndKeys:message, @"message", nil];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[person1 email], @"EMAIL", [person1 password], @"PASSWORD", nil];
    
    NSData *data = [self sendPostRequestWithURL:url httpParams:params httpBodyParams:bodyParams];
    
    NSLog(@"friendship request sent");
    
    if ([self isRequestSuccessfulForData:data]) {
        [_data release];
        _data = data;
        [_data retain];
        
        [self populatePersons];
        [self populateMessages];
        return YES;
    }
    return NO;
}

- (BOOL)rejectFriendshipFor:(SnaPerson *)person1 to:(SnaPerson *)person2 withMessage:(NSString *)message
{
    NSString *url = [NSString stringWithFormat:@"%@/api/persons/%@/reject-friendship", _urlPrefix, [person2 email]];
    NSDictionary *bodyParams = [NSDictionary dictionaryWithObjectsAndKeys:message, @"message", nil];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[person1 email], @"EMAIL", [person1 password], @"PASSWORD", nil];

    NSData *data = [self sendPostRequestWithURL:url httpParams:params httpBodyParams:bodyParams];
    
    NSLog(@"friendship rejection sent");
    
    if ([self isRequestSuccessfulForData:data]) {
        [_data release];
        _data = data;
        [_data retain];
        
        [self populatePersons];
        [self populateMessages];
        return YES;
    }
    return NO;
}

- (BOOL)sendMessageFrom:(SnaPerson *)person1 to:(SnaPerson *)person2 withText:(NSString *)text
{
    NSString *url = [NSString stringWithFormat:@"%@/api/messages/%@/send-message", _urlPrefix, [person2 email]];
    NSDictionary *bodyParams = [NSDictionary dictionaryWithObjectsAndKeys:text, @"message", nil];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[person1 email], @"EMAIL", [person1 password], @"PASSWORD", nil];
    
    NSData *data = [self sendPostRequestWithURL:url httpParams:params httpBodyParams:bodyParams];

    NSLog(@"message sent");
    
    if ([self isRequestSuccessfulForData:data]) {
        [_data release];
        _data = data;
        [_data retain];
        
        [self populatePersons];
        [self populateMessages];
        return YES;
    }
    return NO;
}

- (BOOL)markMessage:(SnaMessage *)message asReadForPerson:(SnaPerson *) person
{
    NSString *url = [NSString stringWithFormat:@"%@/api/messages/%@/mark-as-read", _urlPrefix, [message id]];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[person email], @"EMAIL", [person password], @"PASSWORD", nil];
    NSLog(@"URL: %@", url);

    NSData *data = [self sendGetRequestWithURL:url httpParams:params];
    
    NSLog(@"Mark message as read request sent");
    
    if ([self isRequestSuccessfulForData:data]) {
        [_data release];
        _data = data;
        [_data retain];
        
        [self populatePersons];
        [self populateMessages];
        return YES;
    }
    return NO;
}

- (BOOL)isRequestSuccessfulForData:(NSData *)data
{
    NSDictionary * theObject = [SnaJsonWrapper deserializeJsonData:data];
    
    NSString * response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Server response: %@", response);
    
    if ([theObject valueForKey:@"ErrorCode"] == NULL)
        return true;
    
    NSLog(@"Error code: %@", [theObject valueForKey:@"ErrorCode"]);
    NSLog(@"Error message: %@", [theObject valueForKey:@"ErrorMessage"]);
    
    return false;
}

- (BOOL)createProfileForPerson:(SnaPerson *) person
{
    NSString *url = [NSString stringWithFormat:@"%@/api/profile", _urlPrefix];
    
    NSDictionary *personDict = [self dictonarizePerson:person withLocation:nil];
    
    NSString *personJson = [SnaJsonWrapper stringFromJsonDictionary:personDict];
    
    NSDictionary *bodyParams = [NSDictionary dictionaryWithObjectsAndKeys:personJson, @"profileJson", nil];
    
    NSData *data = [self sendPostRequestWithURL:url httpParams:nil httpBodyParams:bodyParams];
    
    if([self isRequestSuccessfulForData: data])
    {
        NSLog(@"profile created");
        return YES;
    }
    
    NSLog(@"profile NOT created");
    return NO;
}

- (BOOL)updateProfileForPerson:(SnaPerson *) person
{
    return [self updateProfileForPerson:person withLocation:nil];
}

- (BOOL)updateProfileForPerson:(SnaPerson *) person withLocation:(SnaLocation *)location
{
    NSDictionary *personDict = [self dictonarizePerson:person withLocation:location];
    
    NSString *url = [NSString stringWithFormat:@"%@/api/profile", _urlPrefix];
    NSString *personJson = [SnaJsonWrapper stringFromJsonDictionary:personDict];
    NSDictionary *postParams = [NSDictionary dictionaryWithObjectsAndKeys:personJson, @"profileJson", nil];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[person email], @"EMAIL", [person password], @"PASSWORD", nil];
    
    NSLog(@"Serialized JSON: %@", personJson);
    
    NSData *data = [self sendPutRequestWithURL:url httpParams:params httpBodyParams:postParams];
    
    if ([self isRequestSuccessfulForData:data]) {
        [_data release];
        _data = data;
        [_data retain];
        
        [self populatePersons];
        [self populateMessages];
        NSLog(@"profile updated");
        return YES;
    }
    NSLog(@"profile NOT updated");
    return NO;
}

- (NSDictionary *)dictonarizePerson:(SnaPerson *) person withLocation:(SnaLocation *) location
{
    NSMutableDictionary *personDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [personDict setValue:[person email] forKey:@"Email"];
    [personDict setValue:[person password] forKey:@"Password"];
    
    if ([person visibilityStatus] != nil){
//        Ovo server ne smije primit!
//        if ([person visibilityStatus] == [SnaVisibilityStatus OFFLINE]) {
//            [personDict setValue:@"Offline" forKey:@"VisibilityStatus"];
//        }
        if ([person visibilityStatus] == [SnaVisibilityStatus ONLINE])
        {
            [personDict setValue:@"Online" forKey:@"VisibilityStatus"];
        }
        if ([person visibilityStatus] == [SnaVisibilityStatus INVISIBLE])
        {
            [personDict setValue:@"Invisible" forKey:@"VisibilityStatus"];
        }
        if ([person visibilityStatus] == [SnaVisibilityStatus CONTACT_ME])
        {
            [personDict setValue:@"ContactMe" forKey:@"VisibilityStatus"];
        }
    }
    else
    {
        @throw[FxException invalidStateExceptionWithReason:@"dictionarizePerson received person without valid VisibilityStatus "];
    }
    
    if ([person nick] != nil)                       [personDict setValue:[person nick] forKey:@"Nick"];
    if ([person mood] != nil)                       [personDict setValue:[person mood] forKey:@"Mood"];
    if ([person gravatarCode] != nil)               [personDict setValue:[person gravatarCode] forKey:@"GravatarCode"];
    if ([person bornOn] != nil)                     [personDict setValue:[self stringFromSmallDate:[person bornOn]] forKey:@"BornOn"];
    if ([person gender] != nil){
        if ([person gender] == [SnaGender MALE]) {
            [personDict setValue:@"Male" forKey:@"Gender"];
        }
        if ([person gender] == [SnaGender FEMALE]) {
            [personDict setValue:@"Female" forKey:@"Gender"];
        }
        if ([person gender] == [SnaGender OTHER]) {
            [personDict setValue:@"Other" forKey:@"Gender"];
        }
    }
    
    if ([[person lookingForGenders] count] > 0) {
        NSMutableArray *genders = [NSMutableArray array];
        for (SnaGender *g in [person lookingForGenders])
        {
            [genders addObject:[g name]];
        }
        [personDict setValue:genders forKey:@"LookingForGenders"];
    }
    if (location != nil)
    {
        double longitude = location.longitude;
        double latitude =  location.latitude;
        
        NSLog(@"NEW LOCATION: %.4f %.4f", longitude, latitude);
        
        NSDictionary *location = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.4f", longitude], @"Longitude", [NSString stringWithFormat:@"%.4f", latitude], @"Latitude", nil];
        [personDict setValue:location forKey:@"LastKnownLocation"];
    }
    else
    {
        if ([person lastKnownLocation] != nil){
            NSMutableDictionary *location = [[NSMutableDictionary alloc] init];
            [location setValue:[NSString stringWithFormat:@"%.4f", [[person lastKnownLocation] latitude]] forKey:@"Latitude"];
            [location setValue:[NSString stringWithFormat:@"%.4f", [[person lastKnownLocation] longitude]] forKey:@"Longitude"];
            [personDict setValue:location forKey:@"LastKnownLocation"];
        }
    }
    
    if ([person phone] != nil)                      [personDict setValue:[person phone] forKey:@"Phone"];
    if ([person myDescription] != nil)              [personDict setValue:[person myDescription] forKey:@"Description"];
    if ([person occupation] != nil)                 [personDict setValue:[person occupation] forKey:@"Occupation"];
    if ([person hobby] != nil)                      [personDict setValue:[person hobby] forKey:@"Hobby"];
    if ([person mainLocation] != nil)               [personDict setValue:[person mainLocation] forKey:@"MainLocation"];
    
    
    return [personDict copy];
}

- (NSDate *)dateFromRFC3339String:(NSString *)rfc3339DateTimeString withFormat:(NSString *) format
{
    NSDateFormatter *   rfc3339DateFormatter;
    NSLocale *          enUSPOSIXLocale;
    NSDate *            date;
    
    NSLog(@"formatting date: %@", rfc3339DateTimeString);

    if ([rfc3339DateTimeString isKindOfClass:[NSNull class]] ) return nil;
    
    rfc3339DateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
    enUSPOSIXLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
    
    [rfc3339DateFormatter setLocale:enUSPOSIXLocale];
    [rfc3339DateFormatter setDateFormat:format];
    [rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    date = [rfc3339DateFormatter dateFromString:rfc3339DateTimeString];
    
    return date;
}

- (NSString *)stringFromSmallDate:(NSDate *) date
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSString *stringFromDate = [formatter stringFromDate:date];

    return stringFromDate;
}
@end
