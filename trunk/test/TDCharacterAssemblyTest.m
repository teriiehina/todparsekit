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

	STAssertNotNil(a, @"");
	STAssertEquals((int)3, (int)s.length, @"");
	STAssertEquals(0, a.objectsConsumed, @"");
	STAssertEquals(3, a.objectsRemaining, @"");
	STAssertEquals(YES, [a hasMore], @"");
	
	id obj = [a next];
	STAssertEqualObjects(obj, [NSNumber numberWithInteger:'a'], @"");
	STAssertEquals((int)3, (int)s.length, @"");
	STAssertEquals(1, a.objectsConsumed, @"");
	STAssertEquals(2, a.objectsRemaining, @"");
	STAssertEquals(YES, [a hasMore], @"");

	obj = [a next];
	STAssertEqualObjects(obj, [NSNumber numberWithInteger:'b'], @"");
	STAssertEquals((int)3, (int)s.length, @"");
	STAssertEquals(2, a.objectsConsumed, @"");
	STAssertEquals(1, a.objectsRemaining, @"");
	STAssertEquals(YES, [a hasMore], @"");

	obj = [a next];
	STAssertEqualObjects(obj, [NSNumber numberWithInteger:'c'], @"");
	STAssertEquals((int)3, (int)s.length, @"");
	STAssertEquals(3, a.objectsConsumed, @"");
	STAssertEquals(0, a.objectsRemaining, @"");
	STAssertEquals(NO, [a hasMore], @"");

	obj = [a next];
	STAssertNil(obj, @"");
	STAssertEquals((int)3, (int)s.length, @"");
	STAssertEquals(3, a.objectsConsumed, @"");
	STAssertEquals(0, a.objectsRemaining, @"");
	STAssertEquals(NO, [a hasMore], @"");
}

@end
