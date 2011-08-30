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
    Invisible,
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
    string              Email;                  //                  must be: NotNull and NotEmpty                           // Must be: unique in database
    string              Password;               //                  must be: NotNull and NotEmpty
    
    VisibilityStatus    VisibilityStatus;       //                  must be: NotNull and (notEqual(Invisible) if this != currentUser)
                                                //                                   and (notEqual(Offline)   it this == currentUser)
    datetime            OfflineSince;           // can be: Null     must be: (Null    if this.VisibilityStatus == Offline)
                                                //                       and (NotNull if this.VisibilityStatus != Offline)
    
    FriendshipStatus    FriendshipStatus;       //                  must be: NotNull and (   equal(Self) if this == currentUser)
                                                //                                   and (notEqual(Self) if this != currentUser)
    datetime            RejectedOn;             // can be: Null     must be: (Null    if this.FriendshipStatus == Rejected)
                                                //                       and (NotNull if this.FriendshipStatus != Rejected)
    
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
    integer             DistanceInMeters;       // can be: Null     must be: (Null                    if this.LastKnownLocation == NULL or  currentUser.LastKnownLocation == NULL)
                                                //                       and (NotNull                 if this.LastKnownLocation != NULL and currentUser.LastKnownLocation != NULL)
                                                //                       and (GreaterThanOrEqualTo(0) if NotNull)
}
Data : OBJECT
{
    SearchResults : Person[]
}

Message
{
    Id      : Integer
    FromId  : Integer
    ToId    : Integer
    From    : Person
    To      : String
    Text    : String
    SentOn  : DateTime
    ReadOn  : DateTime [Nullable]
}

Person_Relation
{
    From            : Person
    To              : Person
    RelationStatus  : PersonRelationStatus
}
PersonRelationStatus : ENUM
{
    Friend
    WaitingFor
    Rejected
}

Person_Friend
{
    Person  : Person
    To      : Person
}
Person_WaitingFor
{
    Person  : Person
    To      : Person
}
Person_Rejected
{
    Person  : Person
    To      : Person
}
































snaEntities     = SocialNetworkApplication.Domain.Entities
{
LoginDetails
{
email		: string
password	: string
}
UserProfile
{
}
}
snaServices     = SocialNetworkApplication.Domain.Services
{
Repository : IRepository
{
_currentUser : snaEntities = null

isUserLoggedIn : bool = _currentUser != null

currentUser : snaEntities
{
get
{
assert _currentUser != null

return _currentUser
}
}

login(loginDetails : snaEntities::LoginDetails)
{
data = _serverConnector.getData(loginDetails)

_currentUser = data.userProfile
}

createLoginDetails() : snaEntities::LoginDetails
{
new snaEntities::LoginDetails
}
}
}
snaApplication  = SocialNetworkApplication.Ui.Application
{
Navigator : INavigator
{
openLoginPopup() : snaPopups::LoginPopup.Result
}
}
snaPages        = SocialNetworkApplication.Ui.Pages
{
HomePage
{
Model
{
}
View
{
}
Controller
{
}
}
SearchResultsPage
{
Model
{
}
View
{
}
Controller
{
}
}
PersonPage
{
Model
{
}
View
{
}
Controller
{
}
}
}
snaPopups       = SocialNetworkApplication.Ui.Popups
{
LoginPopup
{
Result
{
SUCCES,
CANCELED
}
Model
{
loginDetails : snaEntities::LoginDetails
}
View
{
"Email"     TextBox <== _model.loginDetails.email
"Password"  TextBox <== _model.loginDetails.password

"Login"     Button  ==> _controller.login
"Cancel"    Button  ==> _controller.cancel
}
Controller
{
_repository : snaServices::IRepository

init
{
assert !_repository.isUserLoggedIn

_model = new snaPopups::LoginPopup.Model
(
_repository.createLoginDetails()
)
}
viewWillApear
{
assert !_repository.isUserLoggedIn
}

login
{
assert !_repository.isUserLoggedIn

_repository.login(model.loginDetails)

assert _repository.isUserLoggedIn

this.close(snaPopups::LoginPopup.Result.SUCCES)
}
cancel
{
this.close(snaPopups::LoginPopup.Result.CANCELED)
}
}
}
ChangeMoodPopup
{
}
ProcessContactRequestPopup
{
}
ProcessIncommingMessagePopup
{
}
}
