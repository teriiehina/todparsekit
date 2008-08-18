//
//  TODLiteralTest.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODLiteralTest.h"


@implementation TODLiteralTest

- (void)tearDown {
	[a release];	
}

- (void)testTrueCompleteMatchForLiteral123 {
	s = @"123";
	a = [[TODTokenAssembly alloc] initWithString:s];
	NSLog(@"a: %@", a);
	
	p = [TODNum numWithString:s];
	TODAssembly *result = [p completeMatchFor:a];
	
	// -[TODParser completeMatchFor:]
	// -[TODParser bestMatchFor:]
	// -[TODParser matchAndAssemble:]
	// -[TODTerminal allMatchesFor:]
	// -[TODTerminal matchOneAssembly:]
	// -[TODLiteral qualifies:]
	// -[TODParser best:]
	
	NSLog(@"result: %@", result);
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[123]123^", [result description], @"");
}


- (void)testFalseCompleteMatchForLiteral123 {
	s = @"1234";
	a = [[TODTokenAssembly alloc] initWithString:s];
	
	p = [TODLiteral literalWithString:@"123"];
	TODAssembly *result = [p completeMatchFor:a];
	STAssertNil(result, @"");
	STAssertEqualObjects(@"[]^1234", [a description], @"");
}


- (void)testTrueCompleteMatchForLiteralFoo {
	s = @"Foo";
	a = [[TODTokenAssembly alloc] initWithString:s];
	
	p = [TODLiteral literalWithString:@"Foo"];
	TODAssembly *result = [p completeMatchFor:a];
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[Foo]Foo^", [result description], @"");
}


- (void)testFalseCompleteMatchForLiteralFoo {
	s = @"Foo";
	a = [[TODTokenAssembly alloc] initWithString:s];
	
	p = [TODLiteral literalWithString:@"foo"];
	TODAssembly *result = [p completeMatchFor:a];
	STAssertNil(result, @"");
}


- (void)testFalseCompleteMatchForCaseInsensitiveLiteralFoo {
	s = @"Fool";
	a = [[TODTokenAssembly alloc] initWithString:s];
	
	p = [TODCaseInsensitiveLiteral terminalWithString:@"Foo"];
	TODAssembly *result = [p completeMatchFor:a];
	STAssertNil(result, @"");
}


- (void)testTrueCompleteMatchForCaseInsensitiveLiteralFoo {
	s = @"Foo";
	a = [[TODTokenAssembly alloc] initWithString:s];
		
	p = [TODCaseInsensitiveLiteral terminalWithString:@"foo"];
	TODAssembly *result = [p completeMatchFor:a];
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[Foo]Foo^", [result description], @"");
}

@end
