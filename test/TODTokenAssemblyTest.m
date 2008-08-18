//
//  TODTokenAssemblyTest.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODTokenAssemblyTest.h"


@implementation TODTokenAssemblyTest

- (void)setUp {
}


- (void)tearDown {
	[p release];
}


#pragma mark -

- (void)testWordOhSpaceHaiExclamation {
	s = @"oh hai!";
	a = [TODTokenAssembly assemblyWithString:s];

	STAssertEquals(3, a.length, @"");

	STAssertEquals(0, a.objectsConsumed, @"");
	STAssertEquals(3, a.objectsRemaining, @"");
	STAssertEqualObjects(@"[]^oh/hai/!", [a description], @"");
	STAssertTrue([a hasMore], @"");
	STAssertEqualObjects(@"oh", [[a next] stringValue], @"");

	STAssertEquals(1, a.objectsConsumed, @"");
	STAssertEquals(2, a.objectsRemaining, @"");
	STAssertEqualObjects(@"[]oh^hai/!", [a description], @"");
	STAssertTrue([a hasMore], @"");
	STAssertEqualObjects(@"hai", [[a next] stringValue], @"");

	STAssertEquals(2, a.objectsConsumed, @"");
	STAssertEquals(1, a.objectsRemaining, @"");
	STAssertEqualObjects(@"[]oh/hai^!", [a description], @"");
	STAssertTrue([a hasMore], @"");
	STAssertEqualObjects(@"!", [[a next] stringValue], @"");

	STAssertEquals(3, a.objectsConsumed, @"");
	STAssertEquals(0, a.objectsRemaining, @"");
	STAssertEqualObjects(@"[]oh/hai/!^", [a description], @"");
	STAssertFalse([a hasMore], @"");
	STAssertNil([[a next] stringValue], @"");

	STAssertEquals(3, a.objectsConsumed, @"");
	STAssertEquals(0, a.objectsRemaining, @"");
	STAssertEqualObjects(@"[]oh/hai/!^", [a description], @"");
	STAssertFalse([a hasMore], @"");
	STAssertNil([[a next] stringValue], @"");

	STAssertEquals(3, a.length, @"");
}


- (void)testBestMatchForWordFoobar {
	s = @"foobar";
	a = [TODTokenAssembly assemblyWithString:s];

	STAssertEquals(1, a.length, @"");
	STAssertEqualObjects(@"[]^foobar", [a description], @"");
	
	p = [[TODWord alloc] init];
	TODAssembly *result = [p bestMatchFor:a];
	STAssertEqualObjects(@"[foobar]foobar^", [result description], @"");
	STAssertFalse(result == a, @"");


	result = [p bestMatchFor:result];
	STAssertNil(result, @"");
}


- (void)testCompleteMatchForWordFoobar {
	s = @"foobar";
	a = [TODTokenAssembly assemblyWithString:s];
	
	STAssertEquals(1, a.length, @"");
	STAssertEqualObjects(@"[]^foobar", [a description], @"");
	
	p = [[TODWord alloc] init];
	TODAssembly *result = [p completeMatchFor:a];
	STAssertEqualObjects(@"[foobar]foobar^", [result description], @"");
	STAssertFalse(result == a, @"");
}


- (void)testBestMatchForWordFooSpaceBar {
	s = @"foo bar";
	a = [TODTokenAssembly assemblyWithString:s];
	
	STAssertEquals(2, a.length, @"");
	STAssertEqualObjects(@"[]^foo/bar", [a description], @"");
	
	p = [[TODWord alloc] init];
	TODAssembly *result = [p bestMatchFor:a];
	STAssertEqualObjects(@"[foo]foo^bar", [result description], @"");
	STAssertFalse(result == a, @"");
}


- (void)testCompleteMatchForWordFooSpaceBar {
	s = @"foo bar";
	a = [TODTokenAssembly assemblyWithString:s];
	
	STAssertEquals(2, a.length, @"");
	STAssertEqualObjects(@"[]^foo/bar", [a description], @"");
	
	p = [[TODWord alloc] init];
	TODAssembly *result = [p completeMatchFor:a];
	STAssertNil(result, @"");
}


- (void)testBestMatchForNumFoobar {
	s = @"foobar";
	a = [TODTokenAssembly assemblyWithString:s];
	
	STAssertEquals(1, a.length, @"");
	STAssertEqualObjects(@"[]^foobar", [a description], @"");
	
	p = [[TODNum alloc] init];
	TODAssembly *result = [p bestMatchFor:a];
	STAssertNil(result, @"");
}


- (void)testCompleteMatchForNumFoobar {
	s = @"foobar";
	a = [TODTokenAssembly assemblyWithString:s];
	
	STAssertEquals(1, a.length, @"");
	STAssertEqualObjects(@"[]^foobar", [a description], @"");
	
	p = [[TODNum alloc] init];
	TODAssembly *result = [p completeMatchFor:a];
	STAssertNil(result, @"");
}


- (void)testBestMatchForWord123 {
	s = @"123";
	a = [TODTokenAssembly assemblyWithString:s];
	
	STAssertEquals(1, a.length, @"");
	STAssertEqualObjects(@"[]^123", [a description], @"");
	
	p = [[TODWord alloc] init];
	TODAssembly *result = [p bestMatchFor:a];
	STAssertNil(result, @"");
}


- (void)testCompleteMatchForWord123 {
	s = @"123";
	a = [TODTokenAssembly assemblyWithString:s];
	
	
	p = [[TODWord alloc] init];
	TODAssembly *result = [p completeMatchFor:a];
	STAssertNil(result, @"");
	STAssertEquals(1, a.length, @"");
	STAssertEqualObjects(@"[]^123", [a description], @"");
}


- (void)testBestMatchForNum123 {
	s = @"123";
	a = [TODTokenAssembly assemblyWithString:s];
	
	STAssertEquals(1, a.length, @"");
	STAssertEqualObjects(@"[]^123", [a description], @"");
	
	p = [[TODNum alloc] init];
	TODAssembly *result = [p bestMatchFor:a];
	STAssertEqualObjects(@"[123]123^", [result description], @"");
	STAssertFalse(result == a, @"");
}


- (void)testCompleteMatchForNum123 {
	s = @"123";
	a = [TODTokenAssembly assemblyWithString:s];
	
	STAssertEquals(1, a.length, @"");
	STAssertEqualObjects(@"[]^123", [a description], @"");
	
	p = [[TODNum alloc] init];
	TODAssembly *result = [p bestMatchFor:a];
	STAssertEqualObjects(@"[123]123^", [result description], @"");
	STAssertFalse(result == a, @"");
}


- (void)testBestMatchForNum123Space456 {
	s = @"123 456";
	a = [TODTokenAssembly assemblyWithString:s];
	
	STAssertEquals(2, a.length, @"");
	STAssertEqualObjects(@"[]^123/456", [a description], @"");
	
	p = [[TODNum alloc] init];
	TODAssembly *result = [p bestMatchFor:a];
	STAssertEqualObjects(@"[123]123^456", [result description], @"");
	STAssertFalse(result == a, @"");
}


- (void)testCompleteMatchForNum123Space456 {
	s = @"123 456";
	a = [TODTokenAssembly assemblyWithString:s];
	
	STAssertEquals(2, a.length, @"");
	STAssertEqualObjects(@"[]^123/456", [a description], @"");
	
	p = [[TODNum alloc] init];
	TODAssembly *result = [p completeMatchFor:a];
	STAssertNil(result, @"");
}


- (void)testBestMatchForWordFoobarSpace123 {
	s = @"foobar 123";
	a = [TODTokenAssembly assemblyWithString:s];
	
	STAssertEquals(2, a.length, @"");
	STAssertEqualObjects(@"[]^foobar/123", [a description], @"");
	
	p = [[TODWord alloc] init];
	TODAssembly *result = [p bestMatchFor:a];
	STAssertEqualObjects(@"[foobar]foobar^123", [result description], @"");
	STAssertFalse(result == a, @"");
}


- (void)testCompleteMatchForWordFoobarSpace123 {
	s = @"foobar 123";
	a = [TODTokenAssembly assemblyWithString:s];
	
	STAssertEquals(2, a.length, @"");
	STAssertEqualObjects(@"[]^foobar/123", [a description], @"");
	
	p = [[TODWord alloc] init];
	TODAssembly *result = [p completeMatchFor:a];
	STAssertNil(result, @"");
}


- (void)testBestMatchForNum123Space456Foobar {
	s = @"123 456 foobar";
	a = [TODTokenAssembly assemblyWithString:s];

	STAssertEquals(3, a.length, @"");
	STAssertEqualObjects(@"[]^123/456/foobar", [a description], @"");
	
	p = [[TODNum alloc] init];
	TODAssembly *result = [p bestMatchFor:a];
	STAssertEqualObjects(@"[123]123^456/foobar", [result description], @"");
	STAssertFalse(result == a, @"");
}


- (void)testCompleteMatchForNum123Space456Foobar {
	s = @"123 456 foobar";
	a = [TODTokenAssembly assemblyWithString:s];
	
	STAssertEquals(3, a.length, @"");
	STAssertEqualObjects(@"[]^123/456/foobar", [a description], @"");
	
	p = [[TODNum alloc] init];
	TODAssembly *result = [p completeMatchFor:a];
	STAssertNil(result, @"");
}

@end

