//
//  VoucherClient.h
//  Voucher
//
//  Created by Rizwan Sattar on 11/7/15.
//  Copyright © 2015 Rizwan Sattar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VoucherStreamsController.h"

typedef void (^VoucherClientCompletionHandler)( NSData * _Nullable tokenData, NSString * _Nullable responderDisplayName, NSError * _Nullable error);

@interface VoucherClient : VoucherStreamsController

@property (readonly, copy, nonatomic, nonnull) NSString *displayName;
@property (readonly, copy, nonatomic, nonnull) NSString *appId;
@property (readonly, assign, nonatomic) BOOL isListening;

- (nullable instancetype)init NS_UNAVAILABLE;
- (nonnull instancetype)initWithDisplayName:(nonnull NSString *)displayName appId:(nonnull NSString *)appId NS_DESIGNATED_INITIALIZER;

- (void)startListeningWithCompletion:(nonnull VoucherClientCompletionHandler)completionHandler;
- (void)stopListening;

@end
