//
//  TDSpecificCharTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/15/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDSpecificCharTest.h"


@implementation TDSpecificCharTest

- (void)test123 {
	s = @"123";
	a = [TDCharacterAssembly assemblyWithString:s];
	
	STAssertEqualObjects(@"[]^123", [a description], @"");
	p = [TDSpecificChar specificCharWithChar:'1'];
	
	result = [p bestMatchFor:a];
	STAssertNotNil(a, @"");
	STAssertEqualObjects(@"[1]1^23", [result description], @"");
	STAssertTrue([a hasMore], @"");
}


- (void)testAbc {
	s = @"abc";
	a = [TDCharacterAssembly assemblyWithString:s];
	
	STAssertEqualObjects(@"[]^abc", [a description], @"");
	p = [TDSpecificChar specificCharWithChar:'1'];
	
	result = [p bestMatchFor:a];
	STAssertNotNil(a, @"");
	STAssertNil(result, @"");
	STAssertTrue([a hasMore], @"");
}


- (void)testRepetition {
	s = @"aaa";
	a = [TDCharacterAssembly assemblyWithString:s];
	
	STAssertEqualObjects(@"[]^aaa", [a description], @"");
	p = [TDSpecificChar specificCharWithChar:'a'];
	TDParser *r = [TDRepetition repetitionWithSubparser:p];
	
	result = [r bestMatchFor:a];
	STAssertNotNil(a, @"");
	STAssertEqualObjects(@"[a, a, a]aaa^", [result description], @"");
	STAssertFalse([result hasMore], @"");
}

@end
