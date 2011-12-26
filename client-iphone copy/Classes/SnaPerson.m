
#import "_Domain.h"

@interface SnaPerson()

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Calculated Properties - CHAMPINS
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@property(nonatomic, readwrite, copy  ) NSString   *bornOnAsString;
@property(nonatomic, readwrite, copy  ) NSString   *lookingForGendersAsString;
@property(nonatomic, readwrite, copy  ) NSString   *distanceInMeetersAsString;

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

- (NSString            *) email             { @throw [FxException unsupportedMethodException]; }
- (NSString            *) password          { @throw [FxException unsupportedMethodException]; }

- (SnaVisibilityStatus *) visibilityStatus  { @throw [FxException unsupportedMethodException]; }
- (NSDate              *) offlineSince      { @throw [FxException unsupportedMethodException]; }

- (SnaFriendshipStatus *) friendshipStatus  { @throw [FxException unsupportedMethodException]; }
- (NSDate              *) rejectedOn        { @throw [FxException unsupportedMethodException]; }

- (NSString            *) nick              { @throw [FxException unsupportedMethodException]; }
- (NSString            *) mood              { @throw [FxException unsupportedMethodException]; }
- (NSString            *) gravatarCode      { @throw [FxException unsupportedMethodException]; }

- (NSDate              *) bornOn            { @throw [FxException unsupportedMethodException]; }
- (SnaGender           *) gender            { @throw [FxException unsupportedMethodException]; }
- (NSSet               *) lookingForGenders { @throw [FxException unsupportedMethodException]; }

- (NSString            *) phone             { @throw [FxException unsupportedMethodException]; }
- (NSString            *) myDescription     { @throw [FxException unsupportedMethodException]; }
- (NSString            *) occupation        { @throw [FxException unsupportedMethodException]; }
- (NSString            *) hobby             { @throw [FxException unsupportedMethodException]; }
- (NSString            *) mainLocation      { @throw [FxException unsupportedMethodException]; }

- (SnaLocation         *) lastKnownLocation { @throw [FxException unsupportedMethodException]; }
- (NSInteger            ) distanceInMeeters { @throw [FxException unsupportedMethodException]; }

- (NSArray             *) messages          { @throw [FxException unsupportedMethodException]; }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Calculated Properties - CHAMPIONS
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@synthesize bornOnAsString            = _bornOnAsString;
@synthesize lookingForGendersAsString = _lookingForGendersAsString;
@synthesize distanceInMeetersAsString = _distanceInMeetersAsString;

@synthesize lastMessage               = _lastMessage;
@synthesize unreadMessagesCount       = _unreadMessagesCount;

- (NSString            *) _calculateBornOnAsString
{
    if (self.bornOn == nil)
    {
        return @"";
    }
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    {
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
    }
    
    return [dateFormatter stringFromDate:self.bornOn];
}
- (NSString            *) _calculateLookingForGendersAsString
{
    NSMutableString *result = [NSMutableString string];
    
    for (SnaGender *gender in self.lookingForGenders)
    {
        if ([result length] > 0)
        {
            [result appendString:@", "];
        }
        [result appendString:gender.name];
    }
    
    return [result copy];
}
- (NSString            *) _calculateDistanceInMeetersAsString
{
    return [NSString stringWithFormat:@"%d mi", self.distanceInMeeters];
}

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
    self.bornOnAsString            = [self _calculateBornOnAsString           ];
    self.lookingForGendersAsString = [self _calculateLookingForGendersAsString];
    self.distanceInMeetersAsString = [self _calculateDistanceInMeetersAsString];

    self.lastMessage               = [self _calculateLastMessage              ];
    self.unreadMessagesCount       = [self _calculateUnreadMessagesCount      ];
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
    
    _bornOnAsString            = nil;
    _lookingForGendersAsString = nil;
    
    _lastMessage               = nil;
    _unreadMessagesCount       = 0;
    
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
        [FxDumper dumpFieldWithName:@"offlineSince"          value:self.offlineSince       ],
        
        [FxDumper dumpFieldWithName:@"friendshipStatus"      value:self.friendshipStatus   ],
        [FxDumper dumpFieldWithName:@"rejectedOn"            value:self.rejectedOn         ],
        
        [FxDumper dumpFieldWithName:@"nick"                  value:self.nick               ],
        [FxDumper dumpFieldWithName:@"mood"                  value:self.mood               ],
        [FxDumper dumpFieldWithName:@"gravatarCode"          value:self.gravatarCode       ],
        
        [FxDumper dumpFieldWithName:@"bornOn"                value:self.bornOn             ],
        [FxDumper dumpFieldWithName:@"gender"                value:self.gender             ],
        [FxDumper dumpFieldWithName:@"lookingForGenders"     value:self.lookingForGenders  ],
        
        [FxDumper dumpFieldWithName:@"phone"                 value:self.phone              ],
        [FxDumper dumpFieldWithName:@"myDescription"         value:self.myDescription      ],
        [FxDumper dumpFieldWithName:@"occupation"            value:self.occupation         ],
        [FxDumper dumpFieldWithName:@"hobby"                 value:self.hobby              ],
        [FxDumper dumpFieldWithName:@"mainLocation"          value:self.mainLocation       ],
        
        [FxDumper dumpFieldWithName:@"lastKnownLocation"     value:self.lastKnownLocation  ],
        [FxDumper dumpFieldWithName:@"distanceInMeeters"   integer:self.distanceInMeeters  ],
        
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
                                                         offlineSince:self.offlineSince
                                                     
                                                     friendshipStatus:self.friendshipStatus
                                                           rejectedOn:self.rejectedOn
                                                                 
                                                                 nick:self.nick
                                                                 mood:self.mood
                                                         gravatarCode:self.gravatarCode
                                                               
                                                               bornOn:self.bornOn
                                                               gender:self.gender
                                                    lookingForGenders:self.lookingForGenders
                                                                
                                                                phone:self.phone
                                                        myDescription:self.myDescription
                                                           occupation:self.occupation
                                                                hobby:self.hobby
                                                         mainLocation:self.mainLocation
                                                    
                                                    lastKnownLocation:self.lastKnownLocation
                                                    distanceInMeeters:self.distanceInMeeters
                                                             
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
                                                   offlineSince:self.offlineSince
            
                                               friendshipStatus:self.friendshipStatus
                                                     rejectedOn:self.rejectedOn
            
                                                           nick:self.nick
                                                           mood:self.mood
                                                   gravatarCode:self.gravatarCode
            
                                                         bornOn:self.bornOn
                                                         gender:self.gender
                                              lookingForGenders:self.lookingForGenders
            
                                                          phone:self.phone
                                                  myDescription:self.myDescription
                                                     occupation:self.occupation
                                                          hobby:self.hobby
                                                   mainLocation:self.mainLocation
            
                                              lastKnownLocation:self.lastKnownLocation
                                              distanceInMeeters:self.distanceInMeeters
            
                                                       messages:self.messages];
}

- (void) dealloc
{
    [_bornOnAsString            release];
    [_lookingForGendersAsString release];
    
    [_lastMessage               release];
    
    [super dealloc];
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@end
@implementation SnaImmutablePerson

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Properties
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (NSString            *) email             { return _email            ; }
- (NSString            *) password          { return _password         ; }

- (SnaVisibilityStatus *) visibilityStatus  { return _visibilityStatus ; }
- (NSDate              *) offlineSince      { return _offlineSince     ; }

- (SnaFriendshipStatus *) friendshipStatus  { return _friendshipStatus ; }
- (NSDate              *) rejectedOn        { return _rejectedOn       ; }

- (NSString            *) nick              { return _nick             ; }
- (NSString            *) mood              { return _mood             ; }
- (NSString            *) gravatarCode      { return _gravatarCode     ; }

- (NSDate              *) bornOn            { return _bornOn           ; }
- (SnaGender           *) gender            { return _gender           ; }
- (NSSet               *) lookingForGenders { return _lookingForGenders; }

- (NSString            *) phone             { return _phone            ; }
- (NSString            *) myDescription     { return _myDescription    ; }
- (NSString            *) occupation        { return _occupation       ; }
- (NSString            *) hobby             { return _hobby            ; }
- (NSString            *) mainLocation      { return _mainLocation     ; }

- (SnaLocation         *) lastKnownLocation { return _lastKnownLocation; }
- (NSInteger            ) distanceInMeeters { return _distanceInMeeters; }

- (NSArray             *) messages          { return _messages         ; }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Constructors
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (id) initWithEmail:(NSString            *)email
            password:(NSString            *)password

    visibilityStatus:(SnaVisibilityStatus *)visibilityStatus
        offlineSince:(NSDate              *)offlineSince

    friendshipStatus:(SnaFriendshipStatus *)friendshipStatus
          rejectedOn:(NSDate              *)rejectedOn

                nick:(NSString            *)nick
                mood:(NSString            *)mood
        gravatarCode:(NSString            *)gravatarCode

              bornOn:(NSDate              *)bornOn
              gender:(SnaGender           *)gender
   lookingForGenders:(NSSet               *)lookingForGenders

               phone:(NSString            *)phone
       myDescription:(NSString            *)myDescription
          occupation:(NSString            *)occupation
               hobby:(NSString            *)hobby
        mainLocation:(NSString            *)mainLocation

   lastKnownLocation:(SnaLocation         *)lastKnownLocation
   distanceInMeeters:(NSInteger            )distanceInMeeters

            messages:(NSArray             *)messages
{
    self = [super _init];
    
    [FxAssert isNotNullValue:self];
    
    _email             = [email             copy];
    _password          = [password          copy];
    
    _visibilityStatus  =  visibilityStatus       ;
    _offlineSince      = [offlineSince      copy];
    
    _friendshipStatus  =  friendshipStatus       ;
    _rejectedOn        = [rejectedOn        copy];
    
    _nick              = [nick              copy];
    _mood              = [mood              copy];
    _gravatarCode      = [gravatarCode      copy];
    
    _bornOn            = [bornOn            copy];
    _gender            =  gender                 ;
    _lookingForGenders = [[NSSet setWithSet:lookingForGenders] retain];
    
    _phone             = [phone             copy];
    _myDescription     = [myDescription     copy];
    _occupation        = [occupation        copy];
    _hobby             = [hobby             copy];
    _mainLocation      = [mainLocation      copy];
    
    _lastKnownLocation = [lastKnownLocation copy];
    _distanceInMeeters =  distanceInMeeters      ;
    
    _messages          = [[NSArray arrayWithArray:messages] retain];

    return self;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Infrastructure
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (void) dealloc
{
    [_email             release];
    [_password          release];

    [_offlineSince      release];
    
    [_rejectedOn        release];
    
    [_nick              release];
    [_mood              release];
    [_gravatarCode      release];
    
    [_bornOn            release];
    [_lookingForGenders release];
    
    [_phone             release];
    [_myDescription     release];
    [_occupation        release];
    [_hobby             release];
    [_mainLocation      release];
    
    [_lastKnownLocation release];
    
    [_messages          release];
    
	[super dealloc];
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@end
@implementation SnaMutablePerson

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Properties
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (NSString            *) email             { return _email            ; }
- (NSString            *) password          { return _password         ; }

- (SnaVisibilityStatus *) visibilityStatus  { return _visibilityStatus ; }
- (NSDate              *) offlineSince      { return _offlineSince     ; }

- (SnaFriendshipStatus *) friendshipStatus  { return _friendshipStatus ; }
- (NSDate              *) rejectedOn        { return _rejectedOn       ; }

- (NSString            *) nick              { return _nick             ; }
- (NSString            *) mood              { return _mood             ; }
- (NSString            *) gravatarCode      { return _gravatarCode     ; }

- (NSDate              *) bornOn            { return _bornOn           ; }
- (SnaGender           *) gender            { return _gender           ; }
- (NSMutableSet        *) lookingForGenders { return _lookingForGenders; }

- (NSString            *) phone             { return _phone            ; }
- (NSString            *) myDescription     { return _myDescription    ; }
- (NSString            *) occupation        { return _occupation       ; }
- (NSString            *) hobby             { return _hobby            ; }
- (NSString            *) mainLocation      { return _mainLocation     ; }

- (SnaLocation         *) lastKnownLocation { return _lastKnownLocation; }
- (NSInteger            ) distanceInMeeters { return _distanceInMeeters; }

- (NSMutableArray      *) messages          { return _messages         ; }

- (void) setEmail            :(NSString            *)value
{
    [_email release];
    
    _email = [value copy];
}
- (void) setPassword         :(NSString            *)value
{
    [_password release];
    
    _password = [value copy];
}

- (void) setVisibilityStatus :(SnaVisibilityStatus *)value
{
    _visibilityStatus = value;
}
- (void) setOfflineSince     :(NSDate              *)value
{
    [_offlineSince release];
    
    _offlineSince = [value copy];
}

- (void) setFriendshipStatus :(SnaFriendshipStatus *)value
{
    _friendshipStatus = value;
}
- (void) setRejectedOn       :(NSDate              *)value
{
    [_rejectedOn release];
    
    _rejectedOn = [value copy];
}

- (void) setNick             :(NSString            *)value
{
    [_nick release];
    
    _nick = [value copy];
}
- (void) setMood             :(NSString            *)value
{
    [_mood release];
    
    _mood = [value copy];
}
- (void) setGravatarCode     :(NSString            *)value
{
    [_gravatarCode release];
    
    _gravatarCode = [value copy];
}

- (void) setBornOn           :(NSDate              *)value
{
    [_bornOn release];
    
    _bornOn = [value copy];
}
- (void) setGender           :(SnaGender           *)value
{
    _gender = value;
}

- (void) setPhone            :(NSString            *)value
{
    [_phone release];
    
    _phone = [value copy];
}
- (void) setMyDescription    :(NSString            *)value
{
    [_myDescription release];
    
    _myDescription = [value copy];
}
- (void) setOccupation       :(NSString            *)value
{
    [_occupation release];
    
    _occupation = [value copy];
}
- (void) setHobby            :(NSString            *)value
{
    [_hobby release];
    
    _hobby = [value copy];
}
- (void) setMainLocation     :(NSString            *)value
{
    [_mainLocation release];
    
    _mainLocation = [value copy];
}

- (void) setLastKnownLocation:(SnaLocation         *)value
{
    [_lastKnownLocation release];
    
    _lastKnownLocation = [value copy];
}
- (void) setDistanceInMeeters:(NSInteger            )value
{
    _distanceInMeeters = value;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Constructors
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (id) init
{
    return [self initWithEmail:nil
                      password:nil

              visibilityStatus:nil
                  offlineSince:nil

              friendshipStatus:nil
                    rejectedOn:nil

                          nick:nil
                          mood:nil
                  gravatarCode:nil

                        bornOn:nil
                        gender:nil
             lookingForGenders:nil

                         phone:nil
                 myDescription:nil
                    occupation:nil
                         hobby:nil
                  mainLocation:nil

             lastKnownLocation:nil
             distanceInMeeters:0

                      messages:nil];
    
}
- (id) initWithEmail:(NSString            *)email
            password:(NSString            *)password

    visibilityStatus:(SnaVisibilityStatus *)visibilityStatus
        offlineSince:(NSDate              *)offlineSince

    friendshipStatus:(SnaFriendshipStatus *)friendshipStatus
          rejectedOn:(NSDate              *)rejectedOn

                nick:(NSString            *)nick
                mood:(NSString            *)mood
        gravatarCode:(NSString            *)gravatarCode

              bornOn:(NSDate              *)bornOn
              gender:(SnaGender           *)gender
   lookingForGenders:(NSSet               *)lookingForGenders

               phone:(NSString            *)phone
       myDescription:(NSString            *)myDescription
          occupation:(NSString            *)occupation
               hobby:(NSString            *)hobby
        mainLocation:(NSString            *)mainLocation

   lastKnownLocation:(SnaLocation         *)lastKnownLocation
   distanceInMeeters:(NSInteger            )distanceInMeeters
{
    return [self initWithEmail:email
                      password:password
            
              visibilityStatus:visibilityStatus
                  offlineSince:offlineSince
            
              friendshipStatus:friendshipStatus
                    rejectedOn:rejectedOn
            
                          nick:nick
                          mood:mood
                  gravatarCode:gravatarCode
            
                        bornOn:bornOn
                        gender:gender
             lookingForGenders:lookingForGenders
            
                         phone:phone
                 myDescription:myDescription
                    occupation:occupation
                         hobby:hobby
                  mainLocation:mainLocation
            
             lastKnownLocation:lastKnownLocation
             distanceInMeeters:distanceInMeeters
            
                      messages:[NSArray array]];
}
- (id) initWithEmail:(NSString            *)email
            password:(NSString            *)password

    visibilityStatus:(SnaVisibilityStatus *)visibilityStatus
        offlineSince:(NSDate              *)offlineSince

    friendshipStatus:(SnaFriendshipStatus *)friendshipStatus
          rejectedOn:(NSDate              *)rejectedOn

                nick:(NSString            *)nick
                mood:(NSString            *)mood
        gravatarCode:(NSString            *)gravatarCode

              bornOn:(NSDate              *)bornOn
              gender:(SnaGender           *)gender
   lookingForGenders:(NSSet               *)lookingForGenders

               phone:(NSString            *)phone
       myDescription:(NSString            *)myDescription
          occupation:(NSString            *)occupation
               hobby:(NSString            *)hobby
        mainLocation:(NSString            *)mainLocation

   lastKnownLocation:(SnaLocation         *)lastKnownLocation
   distanceInMeeters:(NSInteger            )distanceInMeeters

            messages:(NSArray             *)messages
{
    self = [super _init];
    
    [FxAssert isNotNullValue:self];
    
    _email             = [email                    copy];
    _password          = [password                 copy];
    
    _visibilityStatus  =  visibilityStatus              ;
    _offlineSince      = [offlineSince             copy];
    
    _friendshipStatus  =  friendshipStatus              ;
    _rejectedOn        = [rejectedOn               copy];
    
    _nick              = [nick                     copy];
    _mood              = [mood                     copy];
    _gravatarCode      = [gravatarCode             copy];
    
    _bornOn            = [bornOn                   copy];
    _gender            =  gender                        ;
    _lookingForGenders = [[NSMutableSet setWithSet:lookingForGenders] retain];
    
    _phone             = [phone                    copy];
    _myDescription     = [myDescription            copy];
    _occupation        = [occupation               copy];
    _hobby             = [hobby                    copy];
    _mainLocation      = [mainLocation             copy];
    
    _lastKnownLocation = [lastKnownLocation        copy];
    _distanceInMeeters =  distanceInMeeters             ;
    
    _messages          = [[NSMutableArray arrayWithArray:messages] retain];

    return self;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Infrastructure
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (void) dealloc
{
    [_email             release];
    [_password          release];
    
    [_offlineSince      release];
    
    [_rejectedOn        release];
    
    [_nick              release];
    [_mood              release];
    [_gravatarCode      release];
    
    [_bornOn            release];
    [_lookingForGenders release];
    
    [_phone             release];
    [_myDescription     release];
    [_occupation        release];
    [_hobby             release];
    [_mainLocation      release];
    
    [_lastKnownLocation release];
    
    [_messages          release];

	[super dealloc];
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@end
