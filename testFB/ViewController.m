//
//  ViewController.m
//  testFB
//
//  Created by shawn on 8/1/12.
//  Copyright (c) 2012 shawn. All rights reserved.
//

#import "ViewController.h"
#import "SharedFB.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize loginButton = _loginButton;
@synthesize logoutButton = _logoutButton;
@synthesize feedButton = _feedButton;

- (void)dealloc
{
    self.loginButton = nil;
    self.logoutButton = nil;
    self.feedButton = nil;
    
                       [super  dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        Facebook *facebook = [SharedFB sharedFB];
        facebook.sessionDelegate  = self;
        

        self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *loginImage = [UIImage imageNamed:@"FBLogin.bundle/images/login.png"];
        [self.loginButton setImage:loginImage forState:UIControlStateNormal];
        //[self.loginButton setTitle:@"login to FB" forState:UIControlStateNormal];
        self.loginButton.frame = CGRectMake(100,100,100,100);
        [self.loginButton addTarget:self action:@selector(loginPressed) forControlEvents:UIControlEventTouchUpInside];
        
        self.logoutButton =[UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *logoutImage = [UIImage imageNamed:@"FBLogin.bundle/images/logout.png"];
        [self.logoutButton setImage:logoutImage forState:UIControlStateNormal];
        //[self.logoutButton setTitle:@"logout to" forState:UIControlStateNormal];
        self.logoutButton.frame = CGRectMake(100,100,100,100);
        [self.logoutButton addTarget:self action:@selector(logoutPressed) forControlEvents:UIControlEventTouchUpInside];


        self.feedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.feedButton.frame = CGRectMake(100,220,100,100);
        [self.feedButton setTitle:@"public to your wall" forState:UIControlStateNormal];
        [self.feedButton addTarget:self action:@selector(feedPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.feedButton];
    }
    return self;
}

- (void)_checkAndSetButton
{
    Facebook *facebook = [SharedFB sharedFB];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    if ([SharedFB isAlreadyLogin]){
        if ([self.loginButton superview])  [self.loginButton removeFromSuperview];
        [self.view addSubview:self.logoutButton];
        
        self.feedButton.enabled = YES;
    }else{
        if (self.logoutButton)  [self.logoutButton removeFromSuperview];
        [self.view addSubview:self.loginButton];
        
        self.feedButton.enabled = NO;
    }
}

- (void)_setActivityView
{
    // Activity Indicator
    int xPosition = (self.view.bounds.size.width / 2.0) - 15.0;
    int yPosition = (self.view.bounds.size.height / 2.0) - 15.0;
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(xPosition, yPosition, 30, 30)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:activityIndicator];
    
    // Message Label for showing confirmation and status messages
    CGFloat yLabelViewOffset = self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height-30;
    messageView = [[UIView alloc]
                   initWithFrame:CGRectMake(0, yLabelViewOffset, self.view.bounds.size.width, 30)];
    messageView.backgroundColor = [UIColor lightGrayColor];
    
    UIView *messageInsetView = [[UIView alloc] initWithFrame:CGRectMake(1, 1, self.view.bounds.size.width-1, 28)];
    messageInsetView.backgroundColor = [UIColor colorWithRed:255.0/255.0
                                                       green:248.0/255.0
                                                        blue:228.0/255.0
                                                       alpha:1];
    messageLabel = [[UILabel alloc]
                    initWithFrame:CGRectMake(4, 1, self.view.bounds.size.width-10, 26)];
    messageLabel.text = @"";
    messageLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    messageLabel.backgroundColor = [UIColor colorWithRed:255.0/255.0
                                                   green:248.0/255.0
                                                    blue:228.0/255.0
                                                   alpha:0.6];
    [messageInsetView addSubview:messageLabel];
    [messageView addSubview:messageInsetView];
    [messageInsetView release];
    messageView.hidden = YES;
    [self.view addSubview:messageView];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _setActivityView];
    [self _checkAndSetButton];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}




#pragma make - action
- (void)loginPressed
{
    Facebook *facebook = [SharedFB sharedFB];

        if (![facebook isSessionValid]) {
            [facebook authorize:nil];
        }
}
- (void)logoutPressed
{
    Facebook *facebook = [SharedFB sharedFB];
    [facebook logout];
}

- (void)_apiDialogFeedUser {
    currentAPICall = kDialogFeedUser;
//    SBJSON *jsonWriter = [[SBJSON new] autorelease];
    SBJSON *jsonWriter = [SBJSON new] ;
    
    // The action links to be shown with the post in the feed
    NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      @"Get Started",@"name",@"http://m.facebook.com/apps/myunityapplink/",@"link", nil], nil];
    NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
    // Dialog parameters
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"I'm using my awesome Unity iOS game", @"name",
                                   @"my awesome Unity iOS game.", @"caption",
                                   @"", @"description",
                                   @"http://m.facebook.com/apps/myunityapplink/", @"link",
                                   @"http://cdn1.hark.com/images/000/004/514/4514/original.jpg", @"picture",
                                   actionLinksStr, @"actions",
                                   nil];


        Facebook *facebook = [SharedFB sharedFB];
[facebook dialog:@"feed"   andParams:params   andDelegate:self];
    
}

- (void)feedPressed
{
    [self _apiDialogFeedUser];
}

#pragma mark - FB delegate
- (void)fbDidLogin {
    Facebook *facebook = [SharedFB sharedFB];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    [self _checkAndSetButton];
}

- (void) fbDidLogout {
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
    [self _checkAndSetButton];
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSLog(@"token extended");
}

#pragma viwe animate
/*
 * This method shows the activity indicator and
 * deactivates the table to avoid user input.
 */
- (void)showActivityIndicator {
    if (![activityIndicator isAnimating]) {
        //apiTableView.userInteractionEnabled = NO;
        [activityIndicator startAnimating];
    }
}

/*
 * This method hides the activity indicator
 * and enables user interaction once more.
 */
- (void)hideActivityIndicator {
    if ([activityIndicator isAnimating]) {
        [activityIndicator stopAnimating];
        //apiTableView.userInteractionEnabled = YES;
    }
}

/*
 * This method is used to display API confirmation and
 * error messages to the user.
 */
- (void)showMessage:(NSString *)message {
    CGRect labelFrame = messageView.frame;
    labelFrame.origin.y = [UIScreen mainScreen].bounds.size.height - self.navigationController.navigationBar.frame.size.height - 20;
    messageView.frame = labelFrame;
    messageLabel.text = message;
    messageView.hidden = NO;
    
    // Use animation to show the message from the bottom then
    // hide it.
    [UIView animateWithDuration:0.5
                          delay:1.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         CGRect labelFrame = messageView.frame;
                         labelFrame.origin.y -= labelFrame.size.height;
                         messageView.frame = labelFrame;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [UIView animateWithDuration:0.5
                                                   delay:3.0
                                                 options: UIViewAnimationCurveEaseOut
                                              animations:^{
                                                  CGRect labelFrame = messageView.frame;
                                                  labelFrame.origin.y += messageView.frame.size.height;
                                                  messageView.frame = labelFrame;
                                              }
                                              completion:^(BOOL finished){
                                                  if (finished) {
                                                      messageView.hidden = YES;
                                                      messageLabel.text = @"";
                                                  }
                                              }];
                         }
                     }];
}

/*
 * This method hides the message, only needed if view closed
 * and animation still going on.
 */
- (void)hideMessage {
    messageView.hidden = YES;
    messageLabel.text = @"";
}

- (NSDictionary *)parseURLParams:(NSString *)query {
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
	for (NSString *pair in pairs) {
		NSArray *kv = [pair componentsSeparatedByString:@"="];
		NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
		[params setObject:val forKey:[kv objectAtIndex:0]];
	}
    return params;
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    [self hideActivityIndicator];
    NSLog(@"Error message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    [self showMessage:@"Oops, something went haywire."];
}

#pragma mark - FBDialogDelegate Methods

/**
 * Called when a UIServer Dialog successfully return. Using this callback
 * instead of dialogDidComplete: to properly handle successful shares/sends
 * that return ID data back.
 */
- (void)dialogCompleteWithUrl:(NSURL *)url {
    if (![url query]) {
        NSLog(@"User canceled dialog or there was an error");
        return;
    }
    
    NSDictionary *params = [self parseURLParams:[url query]];
    switch (currentAPICall) {
        case kDialogFeedUser:
        case kDialogFeedFriend:
        {
            // Successful posts return a post_id
            if ([params valueForKey:@"post_id"]) {
                [self showMessage:@"Published feed successfully."];
                NSLog(@"Feed post ID: %@", [params valueForKey:@"post_id"]);
            }
            break;
        }
        case kDialogRequestsSendToMany:
        case kDialogRequestsSendToSelect:
        case kDialogRequestsSendToTarget:
        {
            // Successful requests return one or more request_ids.
            // Get any request IDs, will be in the URL in the form
            // request_ids[0]=1001316103543&request_ids[1]=10100303657380180
            NSMutableArray *requestIDs = [[[NSMutableArray alloc] init] autorelease];
            for (NSString *paramKey in params) {
                if ([paramKey hasPrefix:@"request_ids"]) {
                    [requestIDs addObject:[params objectForKey:paramKey]];
                }
            }
            if ([requestIDs count] > 0) {
                [self showMessage:@"Sent request successfully."];
                NSLog(@"Request ID(s): %@", requestIDs);
            }
            break;
        }
        default:
            break;
    }
}

- (void)dialogDidNotComplete:(FBDialog *)dialog {
    NSLog(@"Dialog dismissed.");
}

- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error {
    NSLog(@"Error message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    [self showMessage:@"Oops, something went haywire."];
}

/**
 * Called when the user granted additional permissions.
 *//*
- (void)userDidGrantPermission {
    // After permissions granted follow up with next API call
    switch (currentAPICall) {
        case kDialogPermissionsCheckinForRecent:
        {
            // After the check-in permissions have been
            // granted, save them in app session then
            // retrieve recent check-ins
            [self updateCheckinPermissions];
            [self apiGraphUserCheckins];
            break;
        }
        case kDialogPermissionsCheckinForPlaces:
        {
            // After the check-in permissions have been
            // granted, save them in app session then
            // get nearby locations
            [self updateCheckinPermissions];
            [self getNearby];
            break;
        }
        case kDialogPermissionsExtended:
        {
            // In the sample test for getting user_likes
            // permssions, echo that success.
            [self showMessage:@"Permissions granted."];
            break;
        }
        default:
            break;
    }
}*/

/**
 * Called when the user canceled the authorization dialog.
 */
- (void)userDidNotGrantPermission {
    [self showMessage:@"Extended permissions not granted."];
}

@end
