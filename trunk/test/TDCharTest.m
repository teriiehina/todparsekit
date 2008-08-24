//
//  TDCharTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/15/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDCharTest.h"


@implementation TDCharTest

- (void)test123 {
	s = @"123";
	a = [TDCharacterAssembly assemblyWithString:s];
	
	STAssertEqualObjects(@"[]^123", [a description], @"");
	p = [TDChar char];
	
	result = [p bestMatchFor:a];
	STAssertNotNil(a, @"");
	STAssertEqualObjects(@"[1]1^23", [result description], @"");
	STAssertTrue([a hasMore], @"");
}


- (void)testAbc {
	s = @"abc";
	a = [TDCharacterAssembly assemblyWithString:s];
	
	STAssertEqualObjects(@"[]^abc", [a description], @"");
	p = [TDChar char];
	
	result = [p bestMatchFor:a];
	STAssertNotNil(a, @"");
	STAssertEqualObjects(@"[a]a^bc", [result description], @"");
	STAssertTrue([a hasMore], @"");
}

- (void)testRepetition {
	s = @"abc";
	a = [TDCharacterAssembly assemblyWithString:s];
	
	STAssertEqualObjects(@"[]^abc", [a description], @"");
	p = [TDChar char];
	TDParser *r = [TDRepetition repetitionWithSubparser:p];
	
	result = [r bestMatchFor:a];
	STAssertNotNil(a, @"");
	STAssertEqualObjects(@"[a, b, c]abc^", [result description], @"");
	STAssertFalse([result hasMore], @"");
}


@end
