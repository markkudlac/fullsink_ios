//
//  PlayViewController.h
//  Fullsink
//
//  Created by Mark Kudlac on 13-07-21.
//  Copyright (c) 2013 Mark Kudlac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AudioToolbox/AudioToolbox.h>


@interface PlayViewController : UIViewController {
    
    UITextField *inText;
    
    AVPlayer *player;
    Boolean playing;
    
}

@property (nonatomic, retain) IBOutlet UITextField *inText;

@property Boolean playing;

- (IBAction)buttonPressed:(id)Sender;

- (IBAction)sliderPressed:(id)Sender;
- (IBAction)sliderReleased:(id)Sender;

+(void) transferHtmltoDoc;

-(void) setupAVPlayerForURL: (NSURL*) url;
-(NSString *) getIPAddress;

@end
