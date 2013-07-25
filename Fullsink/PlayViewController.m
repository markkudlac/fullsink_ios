//
//  PlayViewController.m
//  Fullsink
//
//  Created by Mark Kudlac on 13-07-21.
//  Copyright (c) 2013 Mark Kudlac. All rights reserved.
//

#import "PlayViewController.h"
#import "SRWebSocket.h"

#include <ifaddrs.h>
#include <arpa/inet.h>
#import <TargetConditionals.h>


@interface PlayViewController () <SRWebSocketDelegate>

@end

@implementation PlayViewController {
    
    SRWebSocket *_webSocket;
    NSMutableArray *_messages;

}

@synthesize inText;
@synthesize playing;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    playing = NO;
    NSString *song = @"Electric.mp3";
    [[self class] transferHtmltoDoc];

   //        [self openWebSocket];
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //    path = [[NSBundle mainBundle] pathForResource:@"MyAudio" ofType:@"mp3"];
    inText.text = song;
        NSString *path = [documentsDirectory stringByAppendingPathComponent:song];
//    NSString *path = @"http://192.168.1.100:8080/FullSink/Madworld.mp3";
    NSLog(@"\nDocuments Path: %@ \n", path);
        NSURL *url = [[NSURL alloc] initFileURLWithPath: path];
//    NSURL *url = [NSURL URLWithString: path];
    
        [self setupAVPlayerForURL:url];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)buttonPressed:(id)Sender {
    
//    NSLog(@"This is the IP Address : %@\n\n", [self getIPAddress]);
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"newindex" ofType:@"html"];
//    NSLog([NSString stringWithFormat: @"Assets path : %@\n", path]);

    
    if (!playing) {
        [player play];
        [Sender setTitle:@"Pause" forState:UIControlStateNormal];
        playing = YES;
    } else {
        [player pause];
        [Sender setTitle:@"Play" forState:UIControlStateNormal];
        playing = NO;
    }
    
//    [_webSocket send: @"CONNECT:Mark K"];
}


- (IBAction)sliderPressed:(id)Sender {
    
    NSLog([NSString stringWithFormat:@"Slider down : %f", [(UISlider *)Sender value]]);
}


- (IBAction)sliderReleased:(id)Sender {
    
    NSLog([NSString stringWithFormat:@"Slider up : %f", [(UISlider *)Sender value]]);
   
    
}




+(void) transferHtmltoDoc {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"newindex.html"];
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:@"FlSkHtml/newindex.html"];
    NSLog(@"Source Path: %@\n Documents Path: %@ \n Folder Path: %@", sourcePath, documentsDirectory, folderPath);
    
    NSError *error;
    
    if([[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:folderPath error:&error]){
        NSLog(@"File successfully copied");
    } else {
        NSLog(@"Error description-%@ \n", [error localizedDescription]);
        NSLog(@"Error reason-%@", [error localizedFailureReason]);
    }}


-(void) setupAVPlayerForURL: (NSURL*) url {
    AVAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    AVPlayerItem *anItem = [AVPlayerItem playerItemWithAsset:asset];
    
    player = [AVPlayer playerWithPlayerItem:anItem];
    [player addObserver:self forKeyPath:@"status" options:0 context:nil];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == player && [keyPath isEqualToString:@"status"]) {
        if (player.status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayer Failed");
        } else if (player.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayer Ready to Play");
        } else if (player.status == AVPlayerItemStatusUnknown) {
            NSLog(@"AVPlayer Unknown");
        }
    }
}


- (NSString *)getIPAddress
{
    NSString *address = @"error";
    NSString *if_name;
    
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    
    #if TARGET_IPHONE_SIMULATOR
        if_name = @"en1";
    #else
       if_name = @"en0";
    #endif
    
    // retrieve the current interfaces - returns 0 on success
   
    if (0 == getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:if_name]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}




#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
   
//    [_webSocket send: @"Another message"];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@":( Websocket Failed With Error %@", error);
    
    _webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSLog(@"Received \"%@\" ", message);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
        _webSocket = nil;
}



- (void) openWebSocket {
    
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:
                        [NSURL URLWithString:@"ws://192.168.1.100:8887"]]];
    _webSocket.delegate = self;
    
    NSLog(@"Opening Connection");
    [_webSocket open];
    
}

@end
