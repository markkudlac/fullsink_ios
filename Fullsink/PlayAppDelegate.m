//
//  PlayAppDelegate.m
//  Fullsink
//
//  Created by Mark Kudlac on 13-07-21.
//  Copyright (c) 2013 Mark Kudlac. All rights reserved.
//

#import "PlayAppDelegate.h"

#import "PlayViewController.h"
#import "HTTPServer.h"
#import "MyHTTPConnection.h"
#import "DDLog.h"
#import "DDTTYLogger.h"

// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation PlayAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[PlayViewController alloc] initWithNibName:@"PlayViewController_iPhone" bundle:nil];
    } else {
        self.viewController = [[PlayViewController alloc] initWithNibName:@"PlayViewController_iPad" bundle:nil];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    // Configure our logging framework.
	// To keep things simple and fast, we're just going to log to the Xcode console.
	[DDLog addLogger:[DDTTYLogger sharedInstance]];
	
//    NSLog(@"Start Server 1");
	// Initalize our http server
	httpServer = [[HTTPServer alloc] init];
    // Tell server to use our custom MyHTTPConnection class.
	[httpServer setConnectionClass:[MyHTTPConnection class]];

    [httpServer setPort:8080];
    
	// Serve files from the standard Sites folder
	//NSString *docRoot = [@"~/Sites" stringByExpandingTildeInPath];
//    NSString *docRoot = @"/Documents/Sites";
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                                    objectAtIndex:0];
    NSString *docRoot = [documentsDirectory stringByAppendingPathComponent:@"FlSkHtml"];
	DDLogInfo(@"Setting document root: %@", docRoot);
	
	[httpServer setDocumentRoot:docRoot];
//	NSLog(@"Start Server 3");
	NSError *error = nil;
	if(![httpServer start:&error])
	{
        NSLog(@"Start Server error");
		DDLogError(@"Error starting HTTP Server: %@", error);
	}
NSLog(@"Start Server 4");
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
