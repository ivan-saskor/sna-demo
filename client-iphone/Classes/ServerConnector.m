#import "ServerConnector.h"
#import "ServerConnectorCallback.h"
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"
#import "_Domain.h"

@interface ServerConnector()
- (NSDictionary *)dictonarizePerson:(SnaPerson *) person;

- (BOOL)isRequestSuccessfulForData:(NSData *)data;
- (NSDate *)dateFromRFC3339String:(NSString *)rfc3339DateTimeString;
- (NSDate *)dateFromSmallRFC3339String:(NSString *)rfc3339DateTimeString;
- (NSString *)stringFromSmallDate:(NSDate *) date;
@end

@implementation ServerConnector

- (id)initWithUrlPrefix:(NSString *)prefix
{
    self = [super init];
    if (self) {
        serverCallback = [[ServerConnectorCallback alloc] init];

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
    [serverCallback release];
    
    [super dealloc];
}

- (BOOL)sendDataRequestForEmail:(NSString *)email withPassword:(NSString *)password
{
    
//    [_persons removeAllObjects];
//    [_messages removeAllObjects];
//    
//    SnaPerson *person = [[SnaMutablePerson alloc] initWithEmail:email password:password visibilityStatus:[SnaVisibilityStatus ONLINE] offlineSince:nil friendshipStatus:[SnaFriendshipStatus SELF] rejectedOn:nil nick:@"Pero" mood:nil gravatarCode:nil bornOn:nil gender:nil lookingForGenders:[NSSet set] phone:nil myDescription:nil occupation:nil hobby:nil mainLocation:nil lastKnownLocation:nil distanceInMeeters:0];
//    
//    [_persons addObject:person];
//    

    NSMutableURLRequest *dataRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/data", _urlPrefix]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLConnection *dataConnection=[[NSURLConnection alloc] initWithRequest:dataRequest delegate:serverCallback];
    [dataRequest addValue:email forHTTPHeaderField: @"EMAIL"];
    [dataRequest addValue:password forHTTPHeaderField: @"PASSWORD"];
    

    if (dataConnection)
    {
        _data = [NSURLConnection sendSynchronousRequest:dataRequest returningResponse:nil error:nil];

        NSLog(@"data request sent");
                
        [self populatePersons];
        [self populateMessages];
    }
    
    return [self isRequestSuccessfulForData:_data];
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

- (void)populatePersons
{
    NSError *theError = nil;

    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    theDeserializer.nullObject = NULL;
    
    
    
    NSDictionary *theObject = [NSDictionary dictionaryWithDictionary:[theDeserializer deserialize:_data error:&theError]];

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
    
    if (theError == nil) 
    {
        //NSLog(@"no error loading json");
        
        NSArray *persons = [theObject mutableArrayValueForKey:@"Persons"];
        
        for (int i=0; i < [persons count]; i++)
        {                           
            NSDictionary *json_person;
            json_person = [persons objectAtIndex:i];
			
			SnaMutablePerson *person = [self FindPersonByEmail:[self _cleanString:[json_person valueForKey:@"Email"]]];
			if (person == nil) {
				person = [[SnaMutablePerson alloc]init];
				[_persons addObject:person];
			}
            
            NSString *visibilityStatusAsString;
            NSString *offlineSinceAsString;
            NSString *friendshipStatusAsString;
            
            if ([[[json_person keyEnumerator] allObjects] containsObject:@"Email"]) 
            {
                [person setEmail:[self _cleanString:[json_person valueForKey:@"Email"]]];
            }
            else
            {
                [person setEmail:nil];
            }
            
            if ([[[json_person keyEnumerator] allObjects] containsObject:@"Password"]) 
            {
                [person setPassword:[self _cleanString:[json_person valueForKey:@"Password"]]];
            }
            else
            {
                [person setPassword:nil];
            }
            
            if ([[[json_person keyEnumerator] allObjects] containsObject:@"VisibilityStatus"]) 
            {
                visibilityStatusAsString = [self _cleanString:[json_person valueForKey:@"VisibilityStatus"]];
            }
            else
            {
                visibilityStatusAsString = nil;
            }
            
            if ([[[json_person keyEnumerator] allObjects] containsObject:@"OfflineSince"]) 
            {
                offlineSinceAsString = [self _cleanString:[json_person valueForKey:@"OfflineSince"]];
            }
            else
            {
                offlineSinceAsString  = nil;
            }
            
            if ([[[json_person keyEnumerator] allObjects] containsObject:@"Nick"]) 
            {
                [person setNick:[self _cleanString:[json_person valueForKey:@"Nick"]]];
            }
            else
            {
                [person setNick:nil];
            }
            
            if ([[[json_person keyEnumerator] allObjects] containsObject:@"FriendshipStatus"]) 
            {
                friendshipStatusAsString = [self _cleanString:[json_person valueForKey:@"FriendshipStatus"]];
            }
            else
            {
                friendshipStatusAsString = nil;
            }
            
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
                [person setOfflineSince:[self dateFromRFC3339String:offlineSinceAsString]];
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
                @throw [FxException exceptionWithName:@"Impossible CP reached" reason:@"Invalid visibility status" userInfo:nil];
            }
                

            [FxAssert isNotNullValue:person.email];
            [FxAssert isNotNullValue:person.password];
            [FxAssert isNotNullValue:person.visibilityStatus];
            [FxAssert isNotNullValue:person.nick];
            [FxAssert isNotNullValue:person.friendshipStatus];

            [person setDistanceInMeeters:0];
            
            continue;
            
            NSLog(@"Mood: %@", [self _cleanString:[json_person valueForKey:@"Mood"]]);
            
            [person setMood:[self _cleanString:[json_person valueForKey:@"Mood"]]];
            [person setGravatarCode:[self _cleanString:[json_person valueForKey:@"GravatarCode"]]];
			[person setBornOn:[self dateFromSmallRFC3339String:[self _cleanString:[json_person valueForKey:@"BornOn"]]]];
            
            NSLog(@"%@", [self _cleanString:[json_person valueForKey:@"BornOn"]]);
		   
		   if ([self _cleanString:[json_person valueForKey:@"Gender"]] != nil) {
			   NSString *gender = [self _cleanString:[json_person valueForKey:@"Gender"]];
			   if ([gender isEqualToString:@"Male"]) {
				   [person setGender:[SnaGender MALE]];
			   }
			   else if ([gender isEqualToString:@"Female"]) {
				   [person setGender:[SnaGender FEMALE]];
			   }
			   else if ([gender isEqualToString:@"Other"]) {
				   [person setGender:[SnaGender OTHER]];
			   }
			   else {
				   @throw ([NSException exceptionWithName:@"parse error" reason:@"invalid gender in input json" userInfo:nil]);
			   }
		   }
		   
        [[person lookingForGenders]removeAllObjects];
		   if ([self _cleanString:[json_person valueForKey:@"LookingForGenders"]] != nil) {
			   
			   
				NSArray *genders = [json_person valueForKey:@"LookingForGenders"];
							
				for (int g=0; g<[genders count]; g++) {
					if ([[genders objectAtIndex:g] isEqualToString:@"Male"]) {
						[[person lookingForGenders]addObject:[SnaGender MALE]];
					}
					if ([[genders objectAtIndex:g] isEqualToString:@"Female"]) {
						[[person lookingForGenders]addObject:[SnaGender FEMALE]];
					}
					if ([[genders objectAtIndex:g] isEqualToString:@"Other"]) {
						[[person lookingForGenders]addObject:[SnaGender OTHER]];
					}
					
				}
			}

            //NSLog(@"%@", [FxDumper dumpValue:person]);
            
            if ([[[json_person keyEnumerator] allObjects] containsObject:@"Phone"]) 
            {
                [person setPhone:[self _cleanString:[json_person valueForKey:@"Phone"]]];
            }
            else
            {
                [person setPhone:nil];
            }
            
            if ([[[json_person keyEnumerator] allObjects] containsObject:@"Occupation"]) 
            {
                [person setOccupation:[self _cleanString:[json_person valueForKey:@"Occupation"]]];
            }
            else
            {
                [person setOccupation:nil];
            }
            
            if ([[[json_person keyEnumerator] allObjects] containsObject:@"Hoby"]) 
            {
                [person setHobby:[self _cleanString:[json_person valueForKey:@"Hoby"]]];
            }
            else
            {
                [person setHobby:nil];
            }
            
            if ([[[json_person keyEnumerator] allObjects] containsObject:@"MainLocation"]) 
            {
                [person setMainLocation:[self _cleanString:[json_person valueForKey:@"MainLocation"]]];
            }
            else
            {
                [person setMainLocation:nil];
            }
            
            [person setDistanceInMeeters:[self _cleanIntegerAsString:[json_person valueForKey:@"DistanceInMeters"]]];
        }
    }
    else
    {
        @throw ([NSException exceptionWithName:@"parse error" reason:@"can't parse json" userInfo:nil]);
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
    NSError *theError = nil;
    
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    theDeserializer.nullObject = NULL;
    
    NSDictionary *theObject = [NSDictionary dictionaryWithDictionary:[theDeserializer deserialize:_data error:&theError]];
    
    if (theError == nil) 
    {   
        NSArray *messages = [theObject mutableArrayValueForKey:@"Messages"];
        
        for (int i=0; i<[messages count]; i++)
        {                           
            NSDictionary *json_message = [messages objectAtIndex:i];
			
			SnaMutableMessage *message;
			message = [self FindMessageById:[json_message valueForKey:@"Id"]];
			if (message == nil) {
				message = [[SnaMutableMessage alloc]init];
				[_messages addObject:message];
			}
			
			[message setFrom:[self FindPersonByEmail:[json_message valueForKey:@"FromEmail"]]];
			[message setTo:[self FindPersonByEmail:[json_message valueForKey:@"ToEmail"]]];
			[message setText:[json_message valueForKey:@"Text"]];
			[message setSentOn:[self dateFromRFC3339String:[json_message valueForKey:@"SentOn"]]];
			[message setReadOn:[json_message valueForKey:@"ReadOn"] == nil?nil : [self dateFromRFC3339String:[json_message valueForKey:@"ReadOn"]]];
            
            NSLog(@"From email: %@", [[message from] email]);
            NSLog(@"Read on: %@", [message readOn]);
            NSLog(@"Sent on: %@", [message sentOn]);
            NSLog(@"ToEmail: %@", [[message to] email]);
            NSLog(@"Text: %@", [message text]);
            NSLog(@"Id: %@", [message id]);
        }
    }
    else
    {
        @throw ([NSException exceptionWithName:@"parse error" reason:@"can't parse json" userInfo:nil]);
    }
}

- (void)populateEmails
{
    NSError *theError = nil;
    NSDictionary *theObject = [NSDictionary dictionaryWithDictionary:[[CJSONDeserializer deserializer] deserialize:_data error:&theError]];
    
    if (theError == nil) 
    {
        //NSLog(@"no error loading json");
        
        NSArray *emails = [theObject mutableArrayValueForKey:@"NearbyPersonsEmails"];
        
        for (int i=0; i<[emails count]; i++)
        {                           
            NSDictionary *json_person;
            NSValue *json_email = [emails objectAtIndex:i];
            
//            [_persons addObject:person];
            
            NSLog(@"%@", json_email);
        }
    }
    else
    {
        @throw ([NSException exceptionWithName:@"parse error" reason:@"can't parse json" userInfo:nil]);
    }
}

- (NSData *)sendFriendshipRequestFrom:(SnaPerson *)person1 to:(SnaPerson *)person2 withMessage:(NSString *)message
{
    NSString * postParams = [[NSString stringWithFormat:@"message=%@", message] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSData *postData = [NSData dataWithBytes: [postParams UTF8String] length: [postParams length]];
    
    NSString *url = [NSString stringWithFormat:@"%@/api/persons/%@/request-friendship", _urlPrefix, [person2 email]];
    NSString *escapedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSLog(@"url to send to: %@", escapedUrl);
    
    NSMutableURLRequest *dataRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:escapedUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [dataRequest setHTTPMethod:@"POST"];
    [dataRequest addValue:[person1 email] forHTTPHeaderField: @"EMAIL"];
    [dataRequest addValue:[person1 password] forHTTPHeaderField: @"PASSWORD"];
    [dataRequest setHTTPBody:postData];

    NSData *data = [NSURLConnection sendSynchronousRequest:dataRequest returningResponse:nil error:nil];
    
    [self isRequestSuccessfulForData: data];
    
    NSLog(@"friendship request sent");
        
    return data;
}

- (NSData *)rejectFriendshipFor:(SnaPerson *)person1 to:(SnaPerson *)person2 withMessage:(NSString *)message
{
    NSString * postParams = [[NSString stringWithFormat:@"message=%@", message] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSData *postData = [NSData dataWithBytes: [postParams UTF8String] length: [postParams length]];
    
    NSString *url = [NSString stringWithFormat:@"%@/api/persons/%@/reject-friendship", _urlPrefix, [person2 email]];
    
    NSLog(@"url to send to: %@", url);
    
    NSMutableURLRequest *dataRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [dataRequest setHTTPMethod:@"POST"];
    [dataRequest addValue:[person1 email] forHTTPHeaderField: @"EMAIL"];
    [dataRequest addValue:[person1 password] forHTTPHeaderField: @"PASSWORD"];
    [dataRequest setHTTPBody:postData];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:dataRequest returningResponse:nil error:nil];
    
    [self isRequestSuccessfulForData: data];
    
    NSLog(@"friendship rejection sent");
    
    return data;
}

- (void)sendMessageFrom:(SnaPerson *)person1 to:(SnaPerson *)person2 withText:(NSString *)text
{
    NSString * postParams = [[NSString stringWithFormat:@"message=%@", text] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSData *postData = [NSData dataWithBytes: [postParams UTF8String] length: [postParams length]];
    
    NSString *url = [NSString stringWithFormat:@"%@/api/messages/%@/send-message", _urlPrefix, [person2 email]];
    NSString *escapedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSMutableURLRequest *dataRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:escapedUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [dataRequest setHTTPMethod:@"POST"];
    [dataRequest addValue:[person1 email] forHTTPHeaderField: @"EMAIL"];
    [dataRequest addValue:[person1 password] forHTTPHeaderField: @"PASSWORD"];
    [dataRequest setHTTPBody:postData];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:dataRequest returningResponse:nil error:nil];
    
    [self isRequestSuccessfulForData: data];
    
    NSLog(@"message sent");
}

- (void)markMessage:(SnaMessage *)message asReadForPerson:(SnaPerson *) person
{
    NSString *url = [NSString stringWithFormat:@"%@/api/messages/%@/mark-as-read", _urlPrefix, [message id]];
    NSString *escapedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSMutableURLRequest *dataRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:escapedUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [dataRequest setHTTPMethod:@"PUT"];
    [dataRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [dataRequest addValue:[person email] forHTTPHeaderField: @"EMAIL"];
    [dataRequest addValue:[person password] forHTTPHeaderField: @"PASSWORD"];
    
    NSData* data = [NSURLConnection sendSynchronousRequest:dataRequest returningResponse:nil error:nil];
    
    [self isRequestSuccessfulForData: data];
    
    NSLog(@"message marked as read");
}

- (BOOL)isRequestSuccessfulForData:(NSData *)data
{
    NSError *theError = nil;
    NSDictionary *theObject = [NSDictionary dictionaryWithDictionary:[[CJSONDeserializer deserializer] deserialize:data error:&theError]];
    
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
    NSDictionary *personDict = [self dictonarizePerson:person];
    
    CJSONSerializer * serializer = [[CJSONSerializer alloc] init];
    
    NSString *personJson = [[NSString alloc] initWithData:[serializer serializeDictionary:personDict error:nil] encoding:NSUTF8StringEncoding];
    
    NSLog(@"Logging person: %@", personJson);
    
    NSString * postParams = [[NSString stringWithFormat:@"profileJson=%@", personJson] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSData *postData = [NSData dataWithBytes: [postParams UTF8String] length: [postParams length]];
    
    NSString *url = [NSString stringWithFormat:@"%@/api/profile", _urlPrefix, personJson];
    NSString *escapedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    
    NSMutableURLRequest *dataRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:escapedUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [dataRequest setHTTPMethod:@"POST"];
    [dataRequest setHTTPBody:postData];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:dataRequest returningResponse:nil error:nil];
    
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
    NSDictionary *personDict = [self dictonarizePerson:person];
    
    CJSONSerializer * serializer = [[CJSONSerializer alloc] init];
    
    NSString *personJson = [[NSString alloc] initWithData:[serializer serializeDictionary:personDict error:nil] encoding:NSUTF8StringEncoding];
    
    NSString * postParams = [[NSString stringWithFormat:@"profileJson=%@", personJson] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSData *postData = [NSData dataWithBytes: [postParams UTF8String] length: [postParams length]];
    
    NSLog(@"Serialized JSON: %@", personJson);
    
    NSString *url = [NSString stringWithFormat:@"%@/api/profile", _urlPrefix];
    NSString *escapedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSMutableURLRequest *dataRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:escapedUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSLog(@"HTTP Header EMAIL: %@", [person email]);
    NSLog(@"HTTP Header PASSWORD: %@", [person password]);
    
    [dataRequest addValue:[person email] forHTTPHeaderField: @"EMAIL"];
    [dataRequest addValue:[person password] forHTTPHeaderField: @"PASSWORD"];
    [dataRequest setHTTPMethod:@"PUT"];
    [dataRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [dataRequest setHTTPBody:postData];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:dataRequest returningResponse:nil error:nil];
    
    if([self isRequestSuccessfulForData: data])
    {
        NSLog(@"profile updated");
        return YES;
    }
    
    NSLog(@"profile NOT updated");
    return NO;
}

- (NSDictionary *)dictonarizePerson:(SnaPerson *) person
{
    NSMutableDictionary *personDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [personDict setValue:[person email] forKey:@"Email"];
    [personDict setValue:[person password] forKey:@"Password"];
    
    if ([person visibilityStatus] != nil){
//        Ovo server ne smije primit!
//        if ([person visibilityStatus] == [SnaVisibilityStatus OFFLINE]) {
//            [personDict setValue:@"Offline" forKey:@"VisibilityStatus"];
//        }
        if ([person visibilityStatus] == [SnaVisibilityStatus ONLINE]) {
            [personDict setValue:@"Online" forKey:@"VisibilityStatus"];
        }
        if ([person visibilityStatus] == [SnaVisibilityStatus INVISIBLE]) {
            [personDict setValue:@"Invisible" forKey:@"VisibilityStatus"];
        }
        if ([person visibilityStatus] == [SnaVisibilityStatus CONTACT_ME]) {
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
    //if ([person lookingForGendersAsString] != nil)  [personDict setValue:[person lookingForGendersAsString] forKey:@"LookingForGenders"];
    if ([person phone] != nil)                      [personDict setValue:[person phone] forKey:@"Phone"];
    if ([person myDescription] != nil)              [personDict setValue:[person myDescription] forKey:@"Description"];
    if ([person occupation] != nil)                 [personDict setValue:[person occupation] forKey:@"Occupation"];
    if ([person hobby] != nil)                      [personDict setValue:[person hobby] forKey:@"Hobby"];
    if ([person mainLocation] != nil)               [personDict setValue:[person mainLocation] forKey:@"MainLocation"];
    if ([person lastKnownLocation] != nil){
        NSMutableDictionary *location = [[NSMutableDictionary alloc] init];
        [location setValue:[NSString stringWithFormat:@"%.4f", [[person lastKnownLocation] latitude]] forKey:@"Latitude"];
        [location setValue:[NSString stringWithFormat:@"%.4f", [[person lastKnownLocation] longitude]] forKey:@"Longitude"];
        [personDict setValue:location forKey:@"LastKnownLocation"];
    }
    
    return [personDict copy];
}

- (NSDate *)dateFromRFC3339String:(NSString *)rfc3339DateTimeString
{
    NSDateFormatter *   rfc3339DateFormatter;
    NSLocale *          enUSPOSIXLocale;
    NSDate *            date;
    
    NSLog(@"formatting date: %@", rfc3339DateTimeString);

    if ([rfc3339DateTimeString isKindOfClass:[NSNull class]] ) return nil;
    
    rfc3339DateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
    enUSPOSIXLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
    
    [rfc3339DateFormatter setLocale:enUSPOSIXLocale];
    [rfc3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    [rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    date = [rfc3339DateFormatter dateFromString:rfc3339DateTimeString];
    
    return date;
}

- (NSDate *)dateFromSmallRFC3339String:(NSString *)rfc3339DateTimeString
{
    NSDateFormatter *   rfc3339DateFormatter;
    NSLocale *          enUSPOSIXLocale;
    NSDate *            date;
    
    NSLog(@"formatting date: %@", rfc3339DateTimeString);
    
    if ([rfc3339DateTimeString isKindOfClass:[NSNull class]] ) return nil;
    
    rfc3339DateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
    enUSPOSIXLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
    
    [rfc3339DateFormatter setLocale:enUSPOSIXLocale];
    [rfc3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'"];
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
