#import <Foundation/Foundation.h>
#import "_Domain.h"

@interface ServerConnector : NSObject
{
    @private NSMutableArray     *_persons;
    @private NSMutableArray     *_messages;
    
    @private NSData             *_data;
    
    @private NSString           *_urlPrefix;
    
}

- (id)initWithUrlPrefix:(NSString *)prefix;

- (BOOL)sendDataRequestForEmail:(NSString *)email withPassword:(NSString *)password;

- (NSMutableArray *)getPersons;
- (NSMutableArray *)getMessages;

- (void)populatePersons;
- (void)populateMessages;
- (SnaMutablePerson *)FindPersonByEmail:(NSString *)email;
- (SnaMutableMessage *)FindMessageById:(NSString *)id;

- (NSData *)sendFriendshipRequestFrom:(SnaPerson *)person1 to:(SnaPerson *)person2 withMessage:(NSString *)message;
- (NSData *)rejectFriendshipFor:(SnaPerson *)person1 to:(SnaPerson *)person2 withMessage:(NSString *)message;
- (void)sendMessageFrom:(SnaPerson *)person1 to:(SnaPerson *)person2 withText:(NSString *)text;
- (void)markMessage:(SnaMessage *)message asReadForPerson:(SnaPerson *) person;

- (BOOL)createProfileForPerson:(SnaPerson *) person;
- (BOOL)updateProfileForPerson:(SnaPerson *) person;

- (NSData *)sendGetRequestWithURL:(NSString *)url httpParams:(NSDictionary *)params;
- (NSData *)sendPostRequestWithURL:(NSString *)url httpParams:(NSDictionary *)params httpBodyParams:(NSDictionary *) bodyParams;
- (NSData *)sendPutRequestWithURL:(NSString *)url httpParams:(NSDictionary *)params httpBodyParams:(NSDictionary *) bodyParams;
@end
