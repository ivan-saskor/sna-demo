enum FriendshipStatus
{
    Self,
    Friend,
    Alien,
    WaitingForHim,
    WaitingForMe,
    Rejected
}
enum Gender
{
    Male,
    Female,
    Other
}
enum VisibilityStatus
{
    Offline,
    Online,
    ContactMe
}
class Location
{
    Decimal[3.4] Longitude;                             // must be: NotNull and InRange(-180.0000, +180.0000)
    Decimal[2.4] Latitude;                              // must be: NotNull and InRange( -90.0000,  +90.0000)
}
class Person
{
                String              Email;              //                  must be: NotNull and NotEmpty                           // Must be: unique in database
                String              Password;           //                  must be: NotNull and NotEmpty

                VisibilityStatus    VisibilityStatus;   //                  must be: NotNull
    calculated  Datetime            OfflineSince;       // can be: Null     must be: (Null    if this.VisibilityStatus == Offline)
                                                        //                       and (NotNull if this.VisibilityStatus != Offline)
    
    calculated  FriendshipStatus    FriendshipStatus;   //                  must be: NotNull
    calculated  datetime            RejectedOn;         // can be: Null     must be: (Null    if this.FriendshipStatus == Rejected)
                                                        //                       and (NotNull if this.FriendshipStatus != Rejected)
    
                string              Nick;               //                  must be: NotNull and NotEmpty
                string              Mood;               // can be: Empty    must be: NotNull
                string              GravatarCode;       // can be: Null     must be: Null or NotEmpty

                date                BornOn;             // can be: Null
                Gender              Gender;             // can be: Null
                Gender[]            LookingForGenders;  // can be: Empty    must be: NotNull

                string              Phone;              // can be: Empty    must be: NotNull
                string              Description;        // can be: Empty    must be: NotNull
                string              Ocupation;          // can be: Empty    must be: NotNull
                string              Hoby;               // can be: Empty    must be: NotNull
                string              MainLocation;       // can be: Empty    must be: NotNull

                Location            LastKnownLocation;  // can be: Null
    calculated  integer             DistanceInMeters;   // can be: Null     must be: (Null                    if this.LastKnownLocation == NULL and currentUser.LastKnownLocation == NULL)
                                                        //                       and (NotNull                 if this.LastKnownLocation != NULL or  currentUser.LastKnownLocation != NULL)
                                                        //                       and (GreaterThanOrEqualTo(0) if NotNull)
}

class Profile
{
    VisibilityStatus    VisibilityStatus;       //                  must be: NotNull

    string              Nick;                   //                  must be: NotNull and NotEmpty
    string              Mood;                   // can be: Empty    must be: NotNull
    string              GravatarCode;           // can be: Null     must be: Null or NotEmpty
    
    date                BornOn;                 // can be: Null
    Gender              Gender;                 // can be: Null
    Gender[]            LookingForGenders;      // can be: Empty    must be: NotNull
    
    string              Phone;                  // can be: Empty    must be: NotNull
    string              Description;            // can be: Empty    must be: NotNull
    string              Ocupation;              // can be: Empty    must be: NotNull
    string              Hoby;                   // can be: Empty    must be: NotNull
    string              MainLocation;           // can be: Empty    must be: NotNull
    
    Location            LastKnownLocation;      // can be: Null
}
class Message
{
    string              Id;                     //                  must be: NotNull and NotEmpty    // Must be: unique in database
    
    string              FromEmail;              //                  must be: NotNull and NotEmpty
    string              ToEmail;                //                  must be: NotNull and NotEmpty
    
    string              Text;                   //                  must be: NotNull and NotEmpty
    
    datetime            SentOn;                 //                  must be: NotNull
    datetime            ReadOn;                 // can be: Null     must be: GreaterThanOrEqualTo(this.SentOn) if NotNull
}

class Data
{
    string[]            NearbyPersonsEmails;    // must be: NotNull

    Person[]            Persons;                // must be: NotNull and NotEmpty
    Message[]           Messages;               // must be: NotNull
}
class DataWithMessageIdentifier extends ApiData
{
    string              MessageId;              // must be: NotNull and NotEmpty    // Must be: unique in database
}

class Service
{
    Data                        GetData()                                                   // GET  /api/data
    
    Data                        RegisterProfile     (Profile profile)                       // POST /api/profile + profileJson
    Data                        UpdateProfile       (Profile profile)                       // PUT  /api/profile + profileJson

    DataWithMessageIdentifier   RequestFriendship   (string personEmail, string message)    // POST /api/persons/{personEmail}/request-friendship + message
    DataWithMessageIdentifier   RejectFriendship    (string personEmail, string message)    // POST /api/persons/{personEmail}/reject-friendship  + message
    
    DataWithMessageIdentifier   SendMessage         (string message)                        // POST /api/messages + message
    Data                        MarkMessageAsRead   (string messageId)                      // PUT /api/messages/{messageId}/mark-as-read
}


