//
//  HauthClient.m
//  Hauth
//
//  Created by Rizwan Sattar on 11/7/15.
//  Copyright © 2015 Rizwan Sattar. All rights reserved.
//

#import "HauthClient.h"
#import "HauthCommon.h"

@interface HauthClient () <NSNetServiceBrowserDelegate, NSNetServiceDelegate, NSStreamDelegate>

@property (copy, nonatomic) NSString *displayName;
@property (copy, nonatomic) NSString *appId;
@property (assign, nonatomic) BOOL isListening;

@property (copy, nonatomic) HauthClientCompletionHandler completionHandler;

// Browsing
@property (strong, nonatomic) NSNetServiceBrowser *browser;
@property (copy, nonatomic) NSString *serviceName;
@property (strong, nonatomic) NSMutableArray <NSNetService *> *currentlyAvailableServices;

@property (strong, nonatomic) NSNetService *server;

@end

@implementation HauthClient

- (instancetype)initWithDisplayName:(NSString *)displayName appId:(NSString *)appId
{
    self = [super init];
    if (self) {
        self.displayName = displayName;
        self.appId = appId;
        NSString *appString = [self.appId stringByReplacingOccurrencesOfString:@"." withString:@"_"];
        self.serviceName = [NSString stringWithFormat:kHauthServiceNameFormat, appString];
    }
    return self;
}

- (void)dealloc
{
    [self stopListening];
}

- (void)startListeningWithCompletion:(HauthClientCompletionHandler)completionHandler
{
    if (self.isListening) {
        [self stopListening];
    }

    self.currentlyAvailableServices = [NSMutableArray arrayWithCapacity:2];

    self.completionHandler = completionHandler;

    self.browser = [[NSNetServiceBrowser alloc] init];
    self.browser.includesPeerToPeer = YES;
    self.browser.delegate = self;
    [self.browser searchForServicesOfType:self.serviceName inDomain:@"local"];
}

- (void)stopListening
{
    if (!self.isListening) {
        return;
    }

    [self.currentlyAvailableServices removeAllObjects];

    [self.browser stop];
    self.browser.delegate = nil;
    self.browser = nil;

    self.completionHandler = nil;
}


#pragma mark - Services

- (void)selectService:(NSNetService *)service
{
    NSAssert(self.currentlyAvailableServices.count > 0,
             @"Tried to select a service when none were available");
    if (service == nil) {
        service = self.currentlyAvailableServices[0];
    }
    NSAssert([self.currentlyAvailableServices containsObject:service],
             @"Tried to select a service which we don't know about");

    self.server = service;
    self.server.delegate = self;

    NSInputStream *inputStream;
    NSOutputStream *outputStream;

    BOOL success = [self.server getInputStream:&inputStream outputStream:&outputStream];
    if (success) {
        self.inputStream = inputStream;
        self.outputStream = outputStream;

        [self openStreams];

        [self sendAuthRequest];
    }
}

- (void)sendAuthRequest
{
    NSDictionary *requestDict = @{@"displayName" : self.displayName};
    NSData *requestData = [NSKeyedArchiver archivedDataWithRootObject:requestDict];
    [self sendData:requestData];
}


- (void)handleReceivedData:(NSData *)data
{
    [super handleReceivedData:data];
    NSDictionary *responseDict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSData *tokenData = responseDict[@"tokenData"];
    NSString *responderDisplayName = responseDict[@"displayName"];
    if (self.completionHandler) {
        self.completionHandler(tokenData, responderDisplayName, nil);
    }
}

#pragma mark - NSNetServiceBrowserDelegate

/* Sent to the NSNetServiceBrowser instance's delegate before the instance begins a search. The delegate will not receive this message if the instance is unable to begin a search. Instead, the delegate will receive the -netServiceBrowser:didNotSearch: message.
 */
- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)browser
{
    NSLog(@"Browser will search");
}

/* Sent to the NSNetServiceBrowser instance's delegate when the instance's previous running search request has stopped.
 */
- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)browser
{
    NSLog(@"Browser did stop search");
}

/* Sent to the NSNetServiceBrowser instance's delegate when an error in searching for domains or services has occurred. The error dictionary will contain two key/value pairs representing the error domain and code (see the NSNetServicesError enumeration above for error code constants). It is possible for an error to occur after a search has been started successfully.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didNotSearch:(NSDictionary<NSString *, NSNumber *> *)errorDict
{
    NSLog(@"\nBrowser did not search:");
    for (NSString *errorDomain in errorDict) {
        NSNumber *errorCode = errorDict[errorDomain];
        NSLog(@"    '%@': %@", errorDomain, errorCode);
    }
}

/* Sent to the NSNetServiceBrowser instance's delegate for each domain discovered. If there are more domains, moreComing will be YES. If for some reason handling discovered domains requires significant processing, accumulating domains until moreComing is NO and then doing the processing in bulk fashion may be desirable.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindDomain:(NSString *)domainString moreComing:(BOOL)moreComing
{
    NSLog(@"Browser found domain: %@, more coming: %@", domainString, (moreComing ? @"YES" : @"NO"));
}

/* Sent to the NSNetServiceBrowser instance's delegate for each service discovered. If there are more services, moreComing will be YES. If for some reason handling discovered services requires significant processing, accumulating services until moreComing is NO and then doing the processing in bulk fashion may be desirable.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing
{
    NSLog(@"Browser found service: %@, more coming: %@", service.name, (moreComing ? @"YES" : @"NO"));
    if (![self.currentlyAvailableServices containsObject:service]) {
        [self.currentlyAvailableServices addObject:service];
    }
}

/* Sent to the NSNetServiceBrowser instance's delegate when a previously discovered domain is no longer available.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveDomain:(NSString *)domainString moreComing:(BOOL)moreComing
{
    NSLog(@"Browser removed domain: %@, more coming: %@", domainString, (moreComing ? @"YES" : @"NO"));
}

/* Sent to the NSNetServiceBrowser instance's delegate when a previously discovered service is no longer published.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)service moreComing:(BOOL)moreComing
{
    NSLog(@"Browser removed service: %@, more coming: %@", service.name, (moreComing ? @"YES" : @"NO"));
    if ([self.currentlyAvailableServices containsObject:service]) {
        [self.currentlyAvailableServices removeObject:service];
    }
}

@end
