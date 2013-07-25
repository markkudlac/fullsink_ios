#import "MyHTTPConnection.h"
#import "GCDAsyncSocket.h"
#import "MyWebSocket.h"
#import "HTTPLogging.h"

// Log levels: off, error, warn, info, verbose
// Other flags: trace
static const int httpLogLevel = HTTP_LOG_LEVEL_WARN; // | HTTP_LOG_FLAG_TRACE;


@implementation MyHTTPConnection


- (WebSocket *)webSocketForURI:(NSString *)path
{
		HTTPLogInfo(@"MyHTTPConnection: Creating MyWebSocket...");
		
		return [[MyWebSocket alloc] initWithRequest:request socket:asyncSocket];		
}

@end
