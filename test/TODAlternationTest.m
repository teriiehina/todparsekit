//
//  TODAlternationTest.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODAlternationTest.h"


@implementation TODAlternationTest

- (void)tearDown {
	[a release];
}


- (void)testTrueLiteralBestMatchForFooSpaceBarSpaceBaz {
	s = @"foo baz bar";
	a = [[TODTokenAssembly alloc] initWithString:s];
	
	p = [TODAlternation alternation];
	[p add:[TODLiteral literalWithString:@"foo"]];
	[p add:[TODLiteral literalWithString:@"bar"]];
	[p add:[TODLiteral literalWithString:@"baz"]];
	
	TODAssembly *result = [p bestMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[foo]foo^baz/bar", [result description], @"");
}


- (void)testTrueLiteralBestMatchForFooSpaceBarSpaceBaz1 {
	s = @"123 baz bar";
	a = [[TODTokenAssembly alloc] initWithString:s];
	
	p = [TODAlternation alternation];
	[p add:[TODLiteral literalWithString:@"bar"]];
	[p add:[TODLiteral literalWithString:@"baz"]];
	[p add:[TODNum numWithString:@"123"]];
	
	TODAssembly *result = [p bestMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[123]123^baz/bar", [result description], @"");
}


- (void)testTrueLiteralBestMatchForFooSpaceBarSpaceBaz2 {
	s = @"123 baz bar";
	a = [[TODTokenAssembly alloc] initWithString:s];
	
	p = [TODAlternation alternation];
	[p add:[TODWord word]];
	[p add:[TODLiteral literalWithString:@"baz"]];
	[p add:[TODNum num]];
	
	TODAssembly *result = [p bestMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[123]123^baz/bar", [result description], @"");
}


- (void)testTrueLiteralBestMatchForFooSpaceBarSpaceBaz3 {
	s = @"123 baz bar";
	a = [[TODTokenAssembly alloc] initWithString:s];
	
	p = [TODAlternation alternation];
	[p add:[TODWord word]];
	[p add:[TODLiteral literalWithString:@"foo"]];
	[p add:[TODNum num]];
	
	TODAssembly *result = [p bestMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[123]123^baz/bar", [result description], @"");
}


- (void)testTrueLiteralBestMatchForFooSpaceBarSpaceBaz4 {
	s = @"123 baz bar";
	a = [[TODTokenAssembly alloc] initWithString:s];
	
	p = [TODAlternation alternation];
	[p add:[TODLiteral literalWithString:@"foo"]];
	[p add:[TODLiteral literalWithString:@"baz"]];
	[p add:[TODNum numWithString:@"123"]];
	
	TODAssembly *result = [p bestMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[123]123^baz/bar", [result description], @"");
}

@end
