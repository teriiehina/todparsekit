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
    
    TDAssertTrue([tas hasMore]);
    NSArray *a = [tas nextTokenArray];
    TDAssertNotNil(a);
    TDAssertEquals((NSUInteger)2, a.count);
    TDAssertEqualObjects(@"I", [[a objectAtIndex:0] stringValue]);
    TDAssertEqualObjects(@"came", [[a objectAtIndex:1] stringValue]);

    TDAssertTrue([tas hasMore]);
    a = [tas nextTokenArray];
    TDAssertNotNil(a);
    TDAssertEquals((NSUInteger)2, a.count);
    TDAssertEqualObjects(@"I", [[a objectAtIndex:0] stringValue]);
    TDAssertEqualObjects(@"saw", [[a objectAtIndex:1] stringValue]);

    TDAssertTrue([tas hasMore]);
    a = [tas nextTokenArray];
    TDAssertNotNil(a);
    TDAssertEquals((NSUInteger)5, a.count);
    TDAssertEqualObjects(@"I", [[a objectAtIndex:0] stringValue]);
    TDAssertEqualObjects(@"left", [[a objectAtIndex:1] stringValue]);
    TDAssertEqualObjects(@"in", [[a objectAtIndex:2] stringValue]);
    TDAssertEqualObjects(@"peace", [[a objectAtIndex:3] stringValue]);
    TDAssertEqualObjects(@".", [[a objectAtIndex:4] stringValue]);

    TDAssertFalse([tas hasMore]);
    a = [tas nextTokenArray];
    TDAssertNil(a);
}
@end
