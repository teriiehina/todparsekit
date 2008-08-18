//
//  TODDigitTest.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/15/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODDigitTest.h"


@implementation TODDigitTest

- (void)test123 {
	s = @"123";
	a = [TODCharacterAssembly assemblyWithString:s];
	
	STAssertEqualObjects(@"[]^123", [a description], @"");
	p = [TODDigit digit];
	
	result = [p bestMatchFor:a];
	STAssertNotNil(a, @"");
	STAssertEqualObjects(@"[1]1^23", [result description], @"");
	STAssertTrue([a hasMore], @"");
}


- (void)testAbc {
	s = @"abc";
	a = [TODCharacterAssembly assemblyWithString:s];
	
	STAssertEqualObjects(@"[]^abc", [a description], @"");
	p = [TODDigit digit];
	
	result = [p bestMatchFor:a];
	STAssertNotNil(a, @"");
	STAssertNil(result, @"");
	STAssertTrue([a hasMore], @"");
}


- (void)testRepetition {
	s = @"123";
	a = [TODCharacterAssembly assemblyWithString:s];
	
	STAssertEqualObjects(@"[]^123", [a description], @"");
	p = [TODDigit digit];
	TODParser *r = [TODRepetition repetitionWithSubparser:p];
	
	result = [r bestMatchFor:a];
	STAssertNotNil(a, @"");
	STAssertEqualObjects(@"[1, 2, 3]123^", [result description], @"");
	STAssertFalse([result hasMore], @"");
}

@end
