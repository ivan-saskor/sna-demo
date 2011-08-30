
#import "_Domain.h"

@interface SnaPerson()

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Calculated Properties - CHAMPINS
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@property(nonatomic, readwrite, retain) SnaMessage *lastMessage;
@property(nonatomic, readwrite, assign) NSInteger   unreadMessagesCount;

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Internal Constructor
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (id) _init;

@end
@implementation SnaPerson

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Properties
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (NSString            *) email            { @throw [FxException unsupportedMethodException]; }
- (NSString            *) password         { @throw [FxException unsupportedMethodException]; }
- (SnaVisibilityStatus *) visibilityStatus { @throw [FxException unsupportedMethodException]; }
- (SnaFriendshipStatus *) friendshipStatus { @throw [FxException unsupportedMethodException]; }
- (NSString            *) nick             { @throw [FxException unsupportedMethodException]; }
- (NSString            *) mood             { @throw [FxException unsupportedMethodException]; }
- (NSString            *) phone            { @throw [FxException unsupportedMethodException]; }
- (NSArray             *) messages         { @throw [FxException unsupportedMethodException]; }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Calculated Properties - CHAMPINS
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@synthesize lastMessage         = _lastMessage;
@synthesize unreadMessagesCount = _unreadMessagesCount;

- (SnaMessage          *) _calculateLastMessage
{
    return [self.messages lastObject];
}
- (NSInteger            ) _calculateUnreadMessagesCount
{
    NSInteger result = 0;
    
    for (SnaMessage *message in self.messages)
    {
        if (!message.isRead)
        {
            result++;
        }
    }
    
    return result;
}

- (void) refreshCalculatedFields_CHAMPION
{
    self.lastMessage         = [[self _calculateLastMessage] retain];
    self.unreadMessagesCount = [self _calculateUnreadMessagesCount];
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Constructors
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (id) init
{
    @throw [FxException unsupportedMethodException];
}
- (id) _init
{
    self = [super init];
    
    [FxAssert isNotNullValue:self];
    
    _lastMessage         = nil;
    _unreadMessagesCount = 0;
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Infrastructure
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (NSString *) description
{
    return [FxDumper dumpValue:self];
}
- (NSArray *) dumpFields
{
    return [NSArray arrayWithObjects:
            
        [FxDumper dumpFieldWithName:@"email"                 value:self.email              ],
        [FxDumper dumpFieldWithName:@"password"              value:self.password           ],
        [FxDumper dumpFieldWithName:@"visibilityStatus"      value:self.visibilityStatus   ],
        [FxDumper dumpFieldWithName:@"friendshipStatus"      value:self.friendshipStatus   ],
        [FxDumper dumpFieldWithName:@"nick"                  value:self.nick               ],
        [FxDumper dumpFieldWithName:@"mood"                  value:self.mood               ],
        [FxDumper dumpFieldWithName:@"phone"                 value:self.phone              ],
        [FxDumper dumpFieldWithName:@"messages"              value:self.messages           ],

        [FxDumper dumpFieldWithName:@"lastMessage"           value:self.lastMessage        ],
        [FxDumper dumpFieldWithName:@"unreadMessagesCount" integer:self.unreadMessagesCount],

        nil
    ];
}
- (id) copyWithZone:(NSZone *)zone
{
    if ([self class] != [SnaImmutablePerson class] || (zone != nil && self.zone != zone))
    {
        return [[SnaImmutablePerson allocWithZone:zone] initWithEmail:self.email
                                                             password:self.password
                                                     visibilityStatus:self.visibilityStatus
                                                     friendshipStatus:self.friendshipStatus
                                                                 nick:self.nick
                                                                 mood:self.mood
                                                                phone:self.phone
                                                             messages:self.messages];
    }
    else
    {
        return [self retain];
    }
}
- (id) mutableCopyWithZone:(NSZone *)zone
{
    return [[SnaMutablePerson allocWithZone:zone] initWithEmail:self.email 
                                                       password:self.password
                                               visibilityStatus:self.visibilityStatus
                                               friendshipStatus:self.friendshipStatus
                                                           nick:self.nick 
                                                           mood:self.mood
                                                          phone:self.phone
                                                       messages:self.messages];
}

- (void) dealloc
{
    [_lastMessage release];
    
    [super dealloc];
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@end
@implementation SnaImmutablePerson

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Properties
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (NSString            *) email            { return _email;            }
- (NSString            *) password         { return _password;         }
- (SnaVisibilityStatus *) visibilityStatus { return _visibilityStatus; }
- (SnaFriendshipStatus *) friendshipStatus { return _friendshipStatus; }
- (NSString            *) nick             { return _nick;             }
- (NSString            *) mood             { return _mood;             }
- (NSString            *) phone            { return _phone;            }
- (NSArray             *) messages         { return _messages;         }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Constructors
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (id) init
{
    @throw [FxException unsupportedMethodException];
}
- (id) initWithEmail:(NSString            *)email
            password:(NSString            *)password
    visibilityStatus:(SnaVisibilityStatus *)visibilityStatus
    friendshipStatus:(SnaFriendshipStatus *)friendshipStatus
                nick:(NSString            *)nick
                mood:(NSString            *)mood
               phone:(NSString            *)phone
            messages:(NSArray             *)messages
{
    self = [super _init];
    
    [FxAssert isNotNullValue:self];
    
    _email            = [email            copy];
    _password         = [password         copy];
    _visibilityStatus =  visibilityStatus      ;
    _friendshipStatus =  friendshipStatus      ;
    _nick             = [nick             copy];
    _mood             = [mood             copy];
    _phone            = [phone            copy];
    _messages         = [messages         copy];

    return self;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Infrastructure
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (void) dealloc
{
    [_email    release];
    [_password release];
    [_nick     release];
    [_mood     release];
    [_phone    release];
    [_messages release];
    
	[super dealloc];
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@end
@implementation SnaMutablePerson

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Properties
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (NSString            *) email            { return _email           ; }
- (NSString            *) password         { return _password        ; }
- (SnaVisibilityStatus *) visibilityStatus { return _visibilityStatus; }
- (SnaFriendshipStatus *) friendshipStatus { return _friendshipStatus; }
- (NSString            *) nick             { return _nick            ; }
- (NSString            *) mood             { return _mood            ; }
- (NSString            *) phone            { return _phone           ; }
- (NSMutableArray      *) messages         { return _messages        ; }

- (void) setEmail           :(NSString            *)value
{
    [_email release];
    
    _email = [value copy];
}
- (void) setPassword        :(NSString            *)value
{
    [_password release];
    
    _password= [value copy];
}
- (void) setVisibilityStatus:(SnaVisibilityStatus *)value
{
    _visibilityStatus = value;
}
- (void) setFriendshipStatus:(SnaFriendshipStatus *)value
{
    _friendshipStatus = value;
}
- (void) setNick            :(NSString            *)value
{
    [_nick release];
    
    _nick = [value copy];
}
- (void) setMood            :(NSString            *)value
{
    [_mood release];
    
    _mood = [value copy];
}
- (void) setPhone           :(NSString            *)value
{
    [_phone release];
    
    _phone = [value copy];
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Constructors
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (id) init
{
    return [self initWithEmail:nil
                      password:nil
              visibilityStatus:nil
              friendshipStatus:nil
                          nick:nil
                          mood:nil
                         phone:nil
                      messages:nil];
}
- (id) initWithEmail:(NSString            *)email
            password:(NSString            *)password
    visibilityStatus:(SnaVisibilityStatus *)visibilityStatus
    friendshipStatus:(SnaFriendshipStatus *)friendshipStatus
                nick:(NSString            *)nick
                mood:(NSString            *)mood
               phone:(NSString            *)phone
{
    return [self initWithEmail:email
                      password:password
              visibilityStatus:visibilityStatus
              friendshipStatus:friendshipStatus
                          nick:nick
                          mood:mood
                         phone:phone  
                      messages:[NSArray array]];
}
- (id) initWithEmail:(NSString            *)email
            password:(NSString            *)password
    visibilityStatus:(SnaVisibilityStatus *)visibilityStatus
    friendshipStatus:(SnaFriendshipStatus *)friendshipStatus
                nick:(NSString            *)nick
                mood:(NSString            *)mood
               phone:(NSString            *)phone
            messages:(NSArray             *)messages
{
    self = [super _init];
    
    [FxAssert isNotNullValue:self];
    
    _email            = [email                   copy];
    _password         = [password                copy];
    _visibilityStatus =  visibilityStatus             ;
    _friendshipStatus =  friendshipStatus             ;
    _nick             = [nick                    copy];
    _mood             = [mood                    copy];
    _phone            = [phone                   copy];
    _messages         = [messages         mutableCopy];

    return self;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Infrastructure
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (void) dealloc
{
    [_email    release];
    [_password release];
    [_nick     release];
    [_mood     release];
    [_phone    release];
    [_messages release];

	[super dealloc];
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@end
