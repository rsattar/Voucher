//
//  Voucher.h
//  Voucher
//
//  Created by Rizwan Sattar on 11/7/15.
//  Copyright © 2015 Rizwan Sattar. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for Voucher.
FOUNDATION_EXPORT double VoucherVersionNumber;

//! Project version string for Voucher.
FOUNDATION_EXPORT const unsigned char VoucherVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Voucher/PublicHeader.h>

// NOTE: In Xcode 7.1, if two frameworks have the same module name ("Voucher"),
// then sometimes one of the frameworks (in my case, tvOS) doesn't compile correctly,
// complaining of the inclusion of "non-modular headers". So make these
// non modular import calls here.
//#import "VoucherStreamsController.h"
//#import "VoucherClient.h"
//#import "VoucherServer.h"
#import <Voucher/VoucherCommon.h>
#import <Voucher/VoucherStreamsController.h>
#import <Voucher/VoucherClient.h>
#import <Voucher/VoucherServer.h>

