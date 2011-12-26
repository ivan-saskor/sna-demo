
#import "_Domain.h"

@interface SnaFriendshipStatus()

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Internal Constructor
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (id) _initWithIdentifier:(NSString *)identifier name:(NSString *)name;

@end
@implementation SnaFriendshipStatus

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Enums
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

+ (SnaFriendshipStatus *) SELF
{
    static SnaFriendshipStatus *cachedResult = nil;
    
    if (cachedResult == nil)
    {
        cachedResult = [[SnaFriendshipStatus alloc] _initWithIdentifier:@"SELF" name:@"Self"];
    }
    
    return cachedResult;
}
+ (SnaFriendshipStatus *) FRIEND
{
    static SnaFriendshipStatus *cachedResult = nil;
    
    if (cachedResult == nil)
    {
        cachedResult = [[SnaFriendshipStatus alloc] _initWithIdentifier:@"FRIEND" name:@"Friend"];
    }
    
    return cachedResult;
}
+ (SnaFriendshipStatus *) ALIEN
{    
    static SnaFriendshipStatus *cachedResult = nil;
    
    if (cachedResult == nil)
    {
        cachedResult = [[SnaFriendshipStatus alloc] _initWithIdentifier:@"ALIEN" name:@"Alien"];
    }
    
    return cachedResult;
}
+ (SnaFriendshipStatus *) WAITING_FOR_HIM
{
    static SnaFriendshipStatus *cachedResult = nil;
    
    if (cachedResult == nil)
    {
        cachedResult = [[SnaFriendshipStatus alloc] _initWithIdentifier:@"WAITING_FOR_HIM" name:@"Waiting for him/her"];
    }
    
    return cachedResult;
}
+ (SnaFriendshipStatus *) WAITING_FOR_ME
{
    static SnaFriendshipStatus *cachedResult = nil;
    
    if (cachedResult == nil)
    {
        cachedResult = [[SnaFriendshipStatus alloc] _initWithIdentifier:@"WAITING_FOR_ME" name:@"Waiting for me"];
    }
    
    return cachedResult;
}
+ (SnaFriendshipStatus *) REJECTED
{
    static SnaFriendshipStatus *cachedResult = nil;
    
    if (cachedResult == nil)
    {
        cachedResult = [[SnaFriendshipStatus alloc] _initWithIdentifier:@"REJECTED" name:@"Rejected"];
    }
    
    return cachedResult;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Values
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

+ (NSArray *) values
{
    static NSArray *cachedResult = nil;
    
    if (cachedResult == nil)
    {
        cachedResult = [[NSArray alloc] initWithObjects:
                        
            [SnaFriendshipStatus SELF           ],
            [SnaFriendshipStatus FRIEND         ],
            [SnaFriendshipStatus ALIEN          ],
            [SnaFriendshipStatus WAITING_FOR_HIM],
            [SnaFriendshipStatus WAITING_FOR_ME ],
            [SnaFriendshipStatus REJECTED       ],
                        
            nil
        ];
    }
    
    return cachedResult;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Properties
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (NSString *) name { return _name; }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Constructors
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (id) init
{
    @throw [FxException unsupportedMethodException];
}

- (id) _initWithIdentifier:(NSString *)identifier name:(NSString *)name;
{
    self = [super initWithIdentifier:identifier];
    
    [FxAssert isNotNullValue:self];
    
    _name = [name copy];
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Infrastructure
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (void) dealloc
{
    [_name release];
    
	[super dealloc];
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@end
