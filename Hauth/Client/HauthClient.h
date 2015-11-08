//
//  HauthClient.h
//  Hauth
//
//  Created by Rizwan Sattar on 11/7/15.
//  Copyright © 2015 Rizwan Sattar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HauthStreamsController.h"

typedef void (^HauthClientCompletionHandler)( NSData * _Nullable tokenData, NSString * _Nullable responderDisplayName, NSError * _Nullable error);

@interface HauthClient : HauthStreamsController

@property (readonly, copy, nonatomic, nonnull) NSString *displayName;
@property (readonly, copy, nonatomic, nonnull) NSString *appId;
@property (readonly, assign, nonatomic) BOOL isListening;

- (nullable instancetype)init NS_UNAVAILABLE;
- (nonnull instancetype)initWithDisplayName:(nonnull NSString *)displayName appId:(nonnull NSString *)appId NS_DESIGNATED_INITIALIZER;

- (void)startListeningWithCompletion:(nonnull HauthClientCompletionHandler)completionHandler;
- (void)stopListening;

@end
