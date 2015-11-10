//
//  VoucherTests.m
//  VoucherTests
//
//  Created by Rizwan Sattar on 11/7/15.
//  Copyright © 2015 Rizwan Sattar. All rights reserved.
//

#import <XCTest/XCTest.h>

// Things to test:
// Server:
// - Can publish given good name and unique id
// - cannot publish with invalid name and unique id
// - Can start or resume serving if/after airplane mode
// Client:
// - Can start browsing with good name + id
// - Cannot start browing bad name and/or id
// - Can start or resume browsing if/after airplane mode
// -
// Integration tests of both:
// - Client connects to server, then disconnects after opening streams
//      => Server should resume serving, ready to receive connections
//      => Client should be able to connect to next server
// - Client connects to server, client sends data, then disconnects while server is waiting for user response
// - Client connects to server, server stops publishing, then resumes publishing
// - Client up first;, then server comes online
// - Server up first, then client comes online

@interface VoucherTests : XCTestCase

@end

@implementation VoucherTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
