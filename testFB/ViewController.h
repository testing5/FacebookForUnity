//
//  ViewController.h
//  testFB
//
//  Created by shawn on 8/1/12.
//  Copyright (c) 2012 shawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

typedef enum apiCall {
    kAPILogout,
    kAPIGraphUserPermissionsDelete,
    kDialogPermissionsExtended,
    kDialogRequestsSendToMany,
    kAPIGetAppUsersFriendsNotUsing,
    kAPIGetAppUsersFriendsUsing,
    kAPIFriendsForDialogRequests,
    kDialogRequestsSendToSelect,
    kAPIFriendsForTargetDialogRequests,
    kDialogRequestsSendToTarget,
    kDialogFeedUser,
    kAPIFriendsForDialogFeed,
    kDialogFeedFriend,
    kAPIGraphUserPermissions,
    kAPIGraphMe,
    kAPIGraphUserFriends,
    kDialogPermissionsCheckin,
    kDialogPermissionsCheckinForRecent,
    kDialogPermissionsCheckinForPlaces,
    kAPIGraphSearchPlace,
    kAPIGraphUserCheckins,
    kAPIGraphUserPhotosPost,
    kAPIGraphUserVideosPost,
} apiCall;

@interface ViewController : UIViewController<FBSessionDelegate, FBDialogDelegate>
{
      int currentAPICall;
    UIActivityIndicatorView *activityIndicator;
    UILabel *messageLabel;
    UIView *messageView;
}

@property (nonatomic, retain) UIButton *loginButton;
@property (nonatomic, retain) UIButton *logoutButton;
@property (nonatomic, retain) UIButton *feedButton;
@end
