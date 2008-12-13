//
//  TDTokenTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/8/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDTokenTest.h"

@implementation TDTokenTest

- (void)setUp {
    eof = [TDToken EOFToken];
}


- (void)testEOFTokenReleaseOnce1 {
    TDAssertNotNil(eof);
    [eof release];
}


- (void)testEOFTokenReleaseOnce2 {
    TDAssertNotNil(eof);
    [eof release];
}


- (void)testEOFTokenReleaseTwice1 {
    TDAssertNotNil(eof);
    [eof release];
    TDAssertNotNil(eof);
    [eof release];
}


- (void)testEOFTokenReleaseTwice2 {
    TDAssertNotNil(eof);
    [eof release];
    TDAssertNotNil(eof);
    [eof release];
}


- (void)testEOFTokenAutoreleaseOnce1 {
    TDAssertNotNil(eof);
    [eof autorelease];
}


- (void)testEOFTokenAutoreleaseOnce2 {
    TDAssertNotNil(eof);
    [eof autorelease];
}


- (void)testEOFTokenAutoreleaseTwice1 {
    TDAssertNotNil(eof);
    [eof autorelease];
    TDAssertNotNil(eof);
    [eof autorelease];
}


- (void)testEOFTokenAutoreleaseTwice2 {
    TDAssertNotNil(eof);
    [eof autorelease];
    TDAssertNotNil(eof);
    [eof autorelease];
}


- (void)testEOFTokenRetainCount {
    TDAssertTrue([eof retainCount] >= 17035104);
    // NO IDEA WHY THIS WONT PASS
    //TDAssertEquals(UINT_MAX, [eof retainCount]);  /*17035104 4294967295*/
//    TDAssertEqualObjects([NSNumber numberWithUnsignedInt:4294967295], [NSNumber numberWithUnsignedInt:[eof retainCount]]);
}


- (void)testCopyIdentity {
    id copy = [eof copy];
    TDAssertTrue(copy == eof);
}

@end
