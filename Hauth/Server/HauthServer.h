//
//  HauthServer.h
//  Hauth
//
//  Created by Rizwan Sattar on 11/7/15.
//  Copyright © 2015 Rizwan Sattar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HauthStreamsController.h"

typedef void (^HauthServerResponseHandler)(NSData * _Nullable tokenData, NSError * _Nullable error);
typedef void (^HauthServerRequestHandler)(NSString * _Nonnull displayName, HauthServerResponseHandler _Nonnull responseHandler);

@interface HauthServer : HauthStreamsController

@property (readonly, copy, nonatomic, nonnull) NSString *displayName;
@property (readonly, copy, nonatomic, nonnull) NSString *appId;
@property (readonly, assign, nonatomic) BOOL isAdvertising;

- (nullable instancetype)init NS_UNAVAILABLE;
- (nonnull instancetype)initWithDisplayName:(nonnull NSString *)displayName appId:(nonnull NSString *)appId NS_DESIGNATED_INITIALIZER;

- (void)startAdvertisingWithRequestHandler:(nonnull HauthServerRequestHandler)requestHandler;
- (void)stopAdvertising;

@end
