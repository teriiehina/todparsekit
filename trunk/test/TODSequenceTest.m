//
//  TODSequenceTest.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODSequenceTest.h"

@interface TODParser ()
- (NSSet *)allMatchesFor:(NSSet *)inAssemblies;
@end

@implementation TODSequenceTest

- (void)tearDown {
}

- (void)testDiscard {
	s = @"foo -";
	a = [TODTokenAssembly assemblyWithString:s];
	
	p = [TODSequence sequence];
	[p add:[TODLiteral literalWithString:@"foo"]];
	[p add:[[TODSymbol symbolWithString:@"-"] discard]];
	
	TODAssembly *result = [p bestMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[foo]foo/-^", [result description], @"");
}


- (void)testDiscard2 {
	s = @"foo foo -";
	a = [TODTokenAssembly assemblyWithString:s];
	
	p = [TODSequence sequence];
	[p add:[TODLiteral literalWithString:@"foo"]];
	[p add:[TODLiteral literalWithString:@"foo"]];
	[p add:[[TODSymbol symbolWithString:@"-"] discard]];
	
	TODAssembly *result = [p bestMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[foo, foo]foo/foo/-^", [result description], @"");
}


- (void)testDiscard3 {
	s = @"foo - foo";
	a = [TODTokenAssembly assemblyWithString:s];
	
	p = [TODSequence sequence];
	[p add:[TODLiteral literalWithString:@"foo"]];
	[p add:[[TODSymbol symbolWithString:@"-"] discard]];
	[p add:[TODLiteral literalWithString:@"foo"]];
	
	TODAssembly *result = [p bestMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[foo, foo]foo/-/foo^", [result description], @"");
}


- (void)testDiscard1 {
	s = @"- foo";
	a = [TODTokenAssembly assemblyWithString:s];
	
	p = [TODSequence sequence];
	[p add:[[TODSymbol symbolWithString:@"-"] discard]];
	[p add:[TODLiteral literalWithString:@"foo"]];
	
	TODAssembly *result = [p bestMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[foo]-/foo^", [result description], @"");
}


- (void)testDiscard4 {
	s = @"- foo -";
	a = [TODTokenAssembly assemblyWithString:s];
	
	p = [TODSequence sequence];
	[p add:[[TODSymbol symbolWithString:@"-"] discard]];
	[p add:[TODLiteral literalWithString:@"foo"]];
	[p add:[[TODSymbol symbolWithString:@"-"] discard]];
	
	TODAssembly *result = [p bestMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[foo]-/foo/-^", [result description], @"");
}


- (void)testDiscard5 {
	s = @"- foo + foo";
	a = [TODTokenAssembly assemblyWithString:s];
	
	p = [TODSequence sequence];
	[p add:[[TODSymbol symbolWithString:@"-"] discard]];
	[p add:[TODLiteral literalWithString:@"foo"]];
	[p add:[[TODSymbol symbolWithString:@"+"] discard]];
	[p add:[TODLiteral literalWithString:@"foo"]];
	
	TODAssembly *result = [p bestMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[foo, foo]-/foo/+/foo^", [result description], @"");
}


- (void)testTrueLiteralBestMatchForFooSpaceBarSpaceBaz {
	s = @"foo bar baz";
	a = [TODTokenAssembly assemblyWithString:s];
	
	p = [TODSequence sequence];
	[p add:[TODLiteral literalWithString:@"foo"]];
	[p add:[TODLiteral literalWithString:@"bar"]];
	[p add:[TODLiteral literalWithString:@"baz"]];
	
	TODAssembly *result = [p bestMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[foo, bar, baz]foo/bar/baz^", [result description], @"");
}


//- (void)testTrueLiteralBestMatchForFooSpaceBarSpaceBaz1 {
//	s = @"foo bar baz";
//	a = [TODTokenAssembly assemblyWithString:s];
//	
//	p = [TODSequence sequence];
//	[p add:[TODLiteral literalWithString:@"foo"]];
//	[p add:[TODLiteral literalWithString:@"baz"]];
//	[p add:[TODLiteral literalWithString:@"bar"]];
//	
//	TODAssembly *result = [p bestMatchFor:a];
//	
//	STAssertNotNil(result, @"");
//	STAssertEqualObjects(@"[foo]foo^bar/baz", [result description], @"");
//}


//- (void)testFalseLiteralBestMatchForFooSpaceBarSpaceBaz {
//	s = @"foo bar baz";
//	a = [TODTokenAssembly assemblyWithString:s];
//	
//	p = [TODSequence sequence];
//	[p add:[TODLiteral literalWithString:@"foo"]];
//	[p add:[TODLiteral literalWithString:@"foo"]];
//	[p add:[TODLiteral literalWithString:@"baz"]];
//	
//	TODAssembly *result = [p bestMatchFor:a];
//	STAssertNotNil(result, @"");
//	STAssertEqualObjects(@"[foo]foo^bar/baz", [result description], @"");
//}


- (void)testTrueLiteralCompleteMatchForFooSpaceBarSpaceBaz {
	s = @"foo bar baz";
	a = [TODTokenAssembly assemblyWithString:s];
	
	p = [TODSequence sequence];
	[p add:[TODLiteral literalWithString:@"foo"]];
	[p add:[TODLiteral literalWithString:@"bar"]];
	[p add:[TODLiteral literalWithString:@"baz"]];
	
	TODAssembly *result = [p completeMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[foo, bar, baz]foo/bar/baz^", [result description], @"");
}


- (void)testTrueLiteralCompleteMatchForFooSpaceBarSpaceBaz1 {
	s = @"foo bar baz";
	a = [TODTokenAssembly assemblyWithString:s];
	
	p = [TODSequence sequence];
	[p add:[TODLiteral literalWithString:@"foo"]];
	[p add:[TODWord word]];
	[p add:[TODLiteral literalWithString:@"baz"]];
	
	TODAssembly *result = [p completeMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[foo, bar, baz]foo/bar/baz^", [result description], @"");
}


- (void)testFalseLiteralCompleteMatchForFooSpaceBarSpaceBaz {
	s = @"foo bar baz";
	a = [TODTokenAssembly assemblyWithString:s];
	
	p = [TODSequence sequence];
	[p add:[TODLiteral literalWithString:@"foo"]];
	[p add:[TODLiteral literalWithString:@"foo"]];
	[p add:[TODLiteral literalWithString:@"baz"]];
	
	TODAssembly *result = [p completeMatchFor:a];
	STAssertNil(result, @"");
}


- (void)testFalseLiteralCompleteMatchForFooSpaceBarSpaceBaz1 {
	s = @"foo bar baz";
	a = [TODTokenAssembly assemblyWithString:s];
	
	p = [TODSequence sequence];
	[p add:[TODLiteral literalWithString:@"foo"]];
	[p add:[TODNum num]];
	[p add:[TODLiteral literalWithString:@"baz"]];
	
	TODAssembly *result = [p completeMatchFor:a];
	STAssertNil(result, @"");
}


- (void)testTrueLiteralAllMatchsForFooSpaceBarSpaceBaz {
	s = @"foo bar baz";
	a = [TODTokenAssembly assemblyWithString:s];
	
	p = [TODSequence sequence];
	[p add:[TODLiteral literalWithString:@"foo"]];
	[p add:[TODLiteral literalWithString:@"bar"]];
	[p add:[TODLiteral literalWithString:@"baz"]];
	
	TODAssembly *result = [p bestMatchFor:a];
	
	STAssertNotNil(result, @"");
}


//- (void)testFalseLiteralAllMatchsForFooSpaceBarSpaceBaz {
//	s = @"foo bar baz";
//	a = [TODTokenAssembly assemblyWithString:s];
//	
//	p = [TODSequence sequence];
//	[p add:[TODLiteral literalWithString:@"foo"]];
//	[p add:[TODLiteral literalWithString:@"123"]];
//	[p add:[TODLiteral literalWithString:@"baz"]];
//	
//	NSSet *result = [p allMatchesFor:[NSSet setWithObject:a]];
//	
//	STAssertNotNil(result, @"");
//	NSInteger c = result.count;
//	STAssertEquals(1, c, @"");
//}
//
@end
