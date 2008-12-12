//
//  TDTokenArraySourceTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/12/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDTokenArraySourceTest.h"

@implementation TDTokenArraySourceTest

- (void)setUp {
}


- (void)testFoo {
    d = @";";
    s = @"I came; I saw; I left in peace.;";
    t = [[[TDTokenizer alloc] initWithString:s] autorelease];
    tas = [[[TDTokenArraySource alloc] initWithTokenizer:t delimiter:d] autorelease];
    
    STAssertTrue([tas hasMore], @"");
    NSArray *a = [tas nextTokenArray];
    STAssertNotNil(a, @"");
    STAssertEquals((NSUInteger)2, a.count, @"");
    STAssertEqualObjects(@"I", [[a objectAtIndex:0] stringValue], @"");
    STAssertEqualObjects(@"came", [[a objectAtIndex:1] stringValue], @"");

    STAssertTrue([tas hasMore], @"");
    a = [tas nextTokenArray];
    STAssertNotNil(a, @"");
    STAssertEquals((NSUInteger)2, a.count, @"");
    STAssertEqualObjects(@"I", [[a objectAtIndex:0] stringValue], @"");
    STAssertEqualObjects(@"saw", [[a objectAtIndex:1] stringValue], @"");

    STAssertTrue([tas hasMore], @"");
    a = [tas nextTokenArray];
    STAssertNotNil(a, @"");
    STAssertEquals((NSUInteger)5, a.count, @"");
    STAssertEqualObjects(@"I", [[a objectAtIndex:0] stringValue], @"");
    STAssertEqualObjects(@"left", [[a objectAtIndex:1] stringValue], @"");
    STAssertEqualObjects(@"in", [[a objectAtIndex:2] stringValue], @"");
    STAssertEqualObjects(@"peace", [[a objectAtIndex:3] stringValue], @"");
    STAssertEqualObjects(@".", [[a objectAtIndex:4] stringValue], @"");

    STAssertFalse([tas hasMore], @"");
    a = [tas nextTokenArray];
    STAssertNil(a, @"");
}
@end
