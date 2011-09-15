
#import "SnaApplicationDelegate.h"

#import "_Domain.h"
#import "_Services.h"
#import "_Pages.h"

@implementation SnaApplicationDelegate

@synthesize window               = _window;
@synthesize navigationController = _navigationController;

static SnaApplicationDelegate *_cachedInstance = nil;

+ (SnaApplicationDelegate *) INSTANCE
{
    [FxAssert isNotNullValue:_cachedInstance];
    
    return _cachedInstance;
}

- (id) init
{
    self = [super init];
    
    [FxAssert isNotNullValue:self];

    _cachedInstance = self;
    
    return self;
}

- (void) _flipViewController:(UIViewController *)viewController
{
    [UIView beginAnimations:nil context:nil];
    {
        [UIView setAnimationDuration: 0.50];
        
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.window cache:YES];
        
        self.window.rootViewController = viewController;
    }
    [UIView commitAnimations];
}
- (UIViewController *) _createHomePage
{
    UITabBarController *tbc = [[UITabBarController alloc] init];
    
    NSArray *ctls = [NSArray arrayWithObjects:
        [[[UINavigationController alloc] initWithRootViewController:[[[SnaNearbyPersonsPageController      alloc] init] autorelease]] autorelease],
        [[[UINavigationController alloc] initWithRootViewController:[[[SnaFriendsPageController            alloc] init] autorelease]] autorelease],
        [[[UINavigationController alloc] initWithRootViewController:[[[SnaMessagesPageController           alloc] init] autorelease]] autorelease],
        [[[UINavigationController alloc] initWithRootViewController:[[[SnaFriendshipRequestsPageController alloc] init] autorelease]] autorelease],
        [[[UINavigationController alloc] initWithRootViewController:[[[SnaProfilePageController            alloc] init] autorelease]] autorelease],
        nil
    ];
    
    ((UINavigationController *)[ctls objectAtIndex:0]).tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Nearbys"  image:[UIImage imageNamed:@"NearbyPersons.png"     ] tag:0] autorelease];
    ((UINavigationController *)[ctls objectAtIndex:1]).tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Friends"  image:[UIImage imageNamed:@"Friends.png"           ] tag:1] autorelease];
    ((UINavigationController *)[ctls objectAtIndex:2]).tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Messages" image:[UIImage imageNamed:@"Messages.png"          ] tag:2] autorelease];
    ((UINavigationController *)[ctls objectAtIndex:3]).tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Requests" image:[UIImage imageNamed:@"FriendshipRequests.png"] tag:3] autorelease];
    ((UINavigationController *)[ctls objectAtIndex:4]).tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Profile"  image:[UIImage imageNamed:@"Profile.png"           ] tag:4] autorelease];
    
    tbc.viewControllers = ctls;
    
    tbc.selectedIndex = 4;
    
    return tbc;
}
- (UIViewController *) _createLoginPage
{
    return [[[UINavigationController alloc] initWithRootViewController:[[[SnaLogInPageController alloc] init] autorelease]] autorelease];
}

- (void) flipToLoginPage
{
    [self _flipViewController:[self _createLoginPage]];
}
- (void) flipToHomePage
{
    [self _flipViewController:[self _createHomePage]];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.rootViewController = [self _createHomePage];
    

//    self.window.rootViewController = nc;
    
//    [nc pushViewController:pageController animated:YES];
    
    //self.window.rootViewController = self.navigationController;

//    if ([SnaDataService INSTANCE].currentUser == nil)
//    {
//        SnaLogInPageController *pageController = [[[SnaLogInPageController alloc] init] autorelease];
//        
//        [self.navigationController pushViewController:pageController animated:YES];
//    }
//    else
//    {
//        SnaHomePageController *pageController = [[[SnaHomePageController alloc] init] autorelease];
//        
//        [self.navigationController pushViewController:pageController animated:YES];
//    }

    
    [self.window makeKeyAndVisible];

    return YES;
}

- (void) applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}
- (void) applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}

- (void) applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}
- (void) applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void) applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -
#pragma mark Memory management

- (void) applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void) dealloc
{
	[_navigationController release];
	[_window               release];

	[super dealloc];
}

@end
