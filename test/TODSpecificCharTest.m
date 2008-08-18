//
//  TODSpecificCharTest.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/15/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODSpecificCharTest.h"


@implementation TODSpecificCharTest

- (void)test123 {
	s = @"123";
	a = [TODCharacterAssembly assemblyWithString:s];
	
	STAssertEqualObjects(@"[]^123", [a description], @"");
	p = [TODSpecificChar specificCharWithChar:'1'];
	
	result = [p bestMatchFor:a];
	STAssertNotNil(a, @"");
	STAssertEqualObjects(@"[1]1^23", [result description], @"");
	STAssertTrue([a hasMore], @"");
}


- (void)testAbc {
	s = @"abc";
	a = [TODCharacterAssembly assemblyWithString:s];
	
	STAssertEqualObjects(@"[]^abc", [a description], @"");
	p = [TODSpecificChar specificCharWithChar:'1'];
	
	result = [p bestMatchFor:a];
	STAssertNotNil(a, @"");
	STAssertNil(result, @"");
	STAssertTrue([a hasMore], @"");
}


- (void)testRepetition {
	s = @"aaa";
	a = [TODCharacterAssembly assemblyWithString:s];
	
	STAssertEqualObjects(@"[]^aaa", [a description], @"");
	p = [TODSpecificChar specificCharWithChar:'a'];
	TODParser *r = [TODRepetition repetitionWithSubparser:p];
	
	result = [r bestMatchFor:a];
	STAssertNotNil(a, @"");
	STAssertEqualObjects(@"[a, a, a]aaa^", [result description], @"");
	STAssertFalse([result hasMore], @"");
}

@end
