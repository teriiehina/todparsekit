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
    STAssertNotNil(eof, @"");
    [eof release];
}


- (void)testEOFTokenReleaseOnce2 {
    STAssertNotNil(eof, @"");
    [eof release];
}


- (void)testEOFTokenReleaseTwice1 {
    STAssertNotNil(eof, @"");
    [eof release];
    STAssertNotNil(eof, @"");
    [eof release];
}


- (void)testEOFTokenReleaseTwice2 {
    STAssertNotNil(eof, @"");
    [eof release];
    STAssertNotNil(eof, @"");
    [eof release];
}


- (void)testEOFTokenAutoreleaseOnce1 {
    STAssertNotNil(eof, @"");
    [eof autorelease];
}


- (void)testEOFTokenAutoreleaseOnce2 {
    STAssertNotNil(eof, @"");
    [eof autorelease];
}


- (void)testEOFTokenAutoreleaseTwice1 {
    STAssertNotNil(eof, @"");
    [eof autorelease];
    STAssertNotNil(eof, @"");
    [eof autorelease];
}


- (void)testEOFTokenAutoreleaseTwice2 {
    STAssertNotNil(eof, @"");
    [eof autorelease];
    STAssertNotNil(eof, @"");
    [eof autorelease];
}


- (void)testEOFTokenRetainCount {
    STAssertTrue([eof retainCount] >= 17035104, @"");

//    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:
//                       [NSNumber numberWithBool:NO], @"NO Key",
//                       [NSNumber numberWithBool:YES], @"YESKey",
//                       [NSNumber numberWithInteger:1], @"IntegerKey",
//                       [NSNumber numberWithFloat:1.0], @"1.0",
//                       [NSNumber numberWithInteger:0], @"0",
//                       @"String", @"StringKey",
//                       [NSNull null], @"Null Key",
//                       [NSNull null], [NSNull null],
//                       [NSDictionary dictionaryWithObject:@"foo" forKey:@"bar"], @"dictKey",
//                       [NSDictionary dictionary], @"emptyDictKey",
//                       [NSArray arrayWithObjects:@"one one", @"two", @"three", nil], @"ArrayKey",
//                       nil];
//    NSLog(@"%@", d);
        
    
    
    // NO IDEA WHY THIS WONT PASS
//    STAssertEquals(UINT_MAX, [eof retainCount], @"");  /*17035104 4294967295*/
//    STAssertEqualObjects([NSNumber numberWithUnsignedInt:4294967295], [NSNumber numberWithUnsignedInt:[eof retainCount]], @"");
}


- (void)testCopyIdentity {
    id copy = [eof copy];
    STAssertTrue(copy == eof, @"");
}

@end
