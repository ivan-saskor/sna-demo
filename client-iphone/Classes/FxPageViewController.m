
#import "FxPageViewController.h"

@implementation FxPageViewController

@synthesize backTitle = _backTitle;

- (void) viewWillAppear:(BOOL)animated
{
    if (self.backTitle != nil)
    {
        self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle: self.backTitle style: UIBarButtonItemStyleBordered target: nil action: nil] autorelease];
    }
    
    [super viewWillAppear:animated];
}
- (void) viewDidUnload
{
    [super viewDidUnload];
    
    self.navigationItem.backBarButtonItem = nil;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void) flipViewController:(UIViewController *)viewController
{
    UINavigationController *navigationController = self.navigationController;
    [[self retain] autorelease];
    
    [UIView beginAnimations:nil context:nil];
    {
        [UIView setAnimationDuration: 0.50];
        
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:navigationController.view cache:YES];
        
        [navigationController popViewControllerAnimated:NO];
        [navigationController pushViewController:viewController animated:NO];
    }
    [UIView commitAnimations];
}

- (void) dealloc
{
    [_backTitle release];
    
    [super dealloc];
}

@end
