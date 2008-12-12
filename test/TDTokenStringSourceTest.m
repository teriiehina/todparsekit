//
//  TDTokenStringSourceTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/12/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDTokenStringSourceTest.h"

@implementation TDTokenStringSourceTest

- (void)setUp {
}


- (void)testFoo {
    d = @";";
    s = @"I came; I saw; I left in peace.;";
    t = [[[TDTokenizer alloc] initWithString:s] autorelease];
    tss = [[[TDTokenStringSource alloc] initWithTokenizer:t delimiter:d] autorelease];
    
    STAssertTrue([tss hasMore], @"");
    NSArray *a = [tss nextTokenString];
    STAssertNotNil(a, @"");
    STAssertEquals((NSUInteger)2, a.count, @"");
    STAssertEqualObjects(@"I", [[a objectAtIndex:0] stringValue], @"");
    STAssertEqualObjects(@"came", [[a objectAtIndex:1] stringValue], @"");

    STAssertTrue([tss hasMore], @"");
    a = [tss nextTokenString];
    STAssertNotNil(a, @"");
    STAssertEquals((NSUInteger)2, a.count, @"");
    STAssertEqualObjects(@"I", [[a objectAtIndex:0] stringValue], @"");
    STAssertEqualObjects(@"saw", [[a objectAtIndex:1] stringValue], @"");

    STAssertTrue([tss hasMore], @"");
    a = [tss nextTokenString];
    STAssertNotNil(a, @"");
    STAssertEquals((NSUInteger)5, a.count, @"");
    STAssertEqualObjects(@"I", [[a objectAtIndex:0] stringValue], @"");
    STAssertEqualObjects(@"left", [[a objectAtIndex:1] stringValue], @"");
    STAssertEqualObjects(@"in", [[a objectAtIndex:2] stringValue], @"");
    STAssertEqualObjects(@"peace", [[a objectAtIndex:3] stringValue], @"");
    STAssertEqualObjects(@".", [[a objectAtIndex:4] stringValue], @"");

    STAssertFalse([tss hasMore], @"");
    a = [tss nextTokenString];
    STAssertNil(a, @"");
}
@end
