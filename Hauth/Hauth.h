//
//  Hauth.h
//  Hauth
//
//  Created by Rizwan Sattar on 11/7/15.
//  Copyright © 2015 Rizwan Sattar. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for Hauth.
FOUNDATION_EXPORT double HauthVersionNumber;

//! Project version string for Hauth.
FOUNDATION_EXPORT const unsigned char HauthVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Hauth/PublicHeader.h>

// NOTE: In Xcode 7.1, if two frameworks have the same module name ("Hauth"),
// then sometimes one of the frameworks (in my case, tvOS) doesn't compile correctly,
// complaining of the inclusion of "non-modular headers". So make these
// non modular import calls here.
#import "HauthStreamsController.h"
#import "HauthClient.h"
#import "HauthServer.h"
//#import <Hauth/HauthStreamsController.h>
//#import <Hauth/HauthClient.h>
//#import <Hauth/HauthServer.h>

