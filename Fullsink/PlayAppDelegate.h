//
//  PlayAppDelegate.h
//  Fullsink
//
//  Created by Mark Kudlac on 13-07-21.
//  Copyright (c) 2013 Mark Kudlac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlayViewController;
@class   HTTPServer;

@interface PlayAppDelegate : UIResponder <UIApplicationDelegate>
{
	HTTPServer *httpServer;
}


@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PlayViewController *viewController;

@end
