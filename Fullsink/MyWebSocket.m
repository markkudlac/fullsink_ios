#import "MyWebSocket.h"
#import "HTTPLogging.h"

// Log levels: off, error, warn, info, verbose
// Other flags : trace
static const int httpLogLevel = HTTP_LOG_LEVEL_WARN | HTTP_LOG_FLAG_TRACE;


@implementation MyWebSocket

- (void)didOpen
{
    NSLog(@"MyWebSocket didOpen");
	HTTPLogTrace();
	
	[super didOpen];
	
	[self sendMessage:@"Welcome to my WebSocket"];
}

- (void)didReceiveMessage:(NSString *)msg
{
    NSLog(@"MyWebSocket didReceiveMessage");
	HTTPLogTrace2(@"%@[%p]: didReceiveMessage: %@", THIS_FILE, self, msg);
	
	[self sendMessage:[NSString stringWithFormat:@"%@", [NSDate date]]];
}

- (void)didClose
{
    NSLog(@"MyWebSocket didClose");
	HTTPLogTrace();
	
	[super didClose];
}

@end
