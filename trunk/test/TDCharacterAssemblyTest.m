//
//  TDCharacterAssemblyTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/15/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDCharacterAssemblyTest.h"

@implementation TDCharacterAssemblyTest

- (void)testAbc {
    s = @"abc";
    a = [TDCharacterAssembly assemblyWithString:s];

    TDAssertNotNil(a);
    TDAssertEquals((int)3, (int)s.length);
    TDAssertEquals(0, a.objectsConsumed);
    TDAssertEquals(3, a.objectsRemaining);
    TDAssertEquals(YES, [a hasMore]);
    
    id obj = [a next];
    TDAssertEqualObjects(obj, [NSNumber numberWithInteger:'a']);
    TDAssertEquals((int)3, (int)s.length);
    TDAssertEquals(1, a.objectsConsumed);
    TDAssertEquals(2, a.objectsRemaining);
    TDAssertEquals(YES, [a hasMore]);

    obj = [a next];
    TDAssertEqualObjects(obj, [NSNumber numberWithInteger:'b']);
    TDAssertEquals((int)3, (int)s.length);
    TDAssertEquals(2, a.objectsConsumed);
    TDAssertEquals(1, a.objectsRemaining);
    TDAssertEquals(YES, [a hasMore]);

    obj = [a next];
    TDAssertEqualObjects(obj, [NSNumber numberWithInteger:'c']);
    TDAssertEquals((int)3, (int)s.length);
    TDAssertEquals(3, a.objectsConsumed);
    TDAssertEquals(0, a.objectsRemaining);
    TDAssertEquals(NO, [a hasMore]);

    obj = [a next];
    TDAssertNil(obj);
    TDAssertEquals((int)3, (int)s.length);
    TDAssertEquals(3, a.objectsConsumed);
    TDAssertEquals(0, a.objectsRemaining);
    TDAssertEquals(NO, [a hasMore]);
}

@end
