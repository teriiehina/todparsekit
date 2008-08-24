//
//  TDSequenceTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDSequenceTest.h"

@interface TDParser ()
- (NSSet *)allMatchesFor:(NSSet *)inAssemblies;
@end

@implementation TDSequenceTest

- (void)tearDown {
}

- (void)testDiscard {
	s = @"foo -";
	a = [TDTokenAssembly assemblyWithString:s];
	
	p = [TDSequence sequence];
	[p add:[TDLiteral literalWithString:@"foo"]];
	[p add:[[TDSymbol symbolWithString:@"-"] discard]];
	
	TDAssembly *result = [p bestMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[foo]foo/-^", [result description], @"");
}


- (void)testDiscard2 {
	s = @"foo foo -";
	a = [TDTokenAssembly assemblyWithString:s];
	
	p = [TDSequence sequence];
	[p add:[TDLiteral literalWithString:@"foo"]];
	[p add:[TDLiteral literalWithString:@"foo"]];
	[p add:[[TDSymbol symbolWithString:@"-"] discard]];
	
	TDAssembly *result = [p bestMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[foo, foo]foo/foo/-^", [result description], @"");
}


- (void)testDiscard3 {
	s = @"foo - foo";
	a = [TDTokenAssembly assemblyWithString:s];
	
	p = [TDSequence sequence];
	[p add:[TDLiteral literalWithString:@"foo"]];
	[p add:[[TDSymbol symbolWithString:@"-"] discard]];
	[p add:[TDLiteral literalWithString:@"foo"]];
	
	TDAssembly *result = [p bestMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[foo, foo]foo/-/foo^", [result description], @"");
}


- (void)testDiscard1 {
	s = @"- foo";
	a = [TDTokenAssembly assemblyWithString:s];
	
	p = [TDSequence sequence];
	[p add:[[TDSymbol symbolWithString:@"-"] discard]];
	[p add:[TDLiteral literalWithString:@"foo"]];
	
	TDAssembly *result = [p bestMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[foo]-/foo^", [result description], @"");
}


- (void)testDiscard4 {
	s = @"- foo -";
	a = [TDTokenAssembly assemblyWithString:s];
	
	p = [TDSequence sequence];
	[p add:[[TDSymbol symbolWithString:@"-"] discard]];
	[p add:[TDLiteral literalWithString:@"foo"]];
	[p add:[[TDSymbol symbolWithString:@"-"] discard]];
	
	TDAssembly *result = [p bestMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[foo]-/foo/-^", [result description], @"");
}


- (void)testDiscard5 {
	s = @"- foo + foo";
	a = [TDTokenAssembly assemblyWithString:s];
	
	p = [TDSequence sequence];
	[p add:[[TDSymbol symbolWithString:@"-"] discard]];
	[p add:[TDLiteral literalWithString:@"foo"]];
	[p add:[[TDSymbol symbolWithString:@"+"] discard]];
	[p add:[TDLiteral literalWithString:@"foo"]];
	
	TDAssembly *result = [p bestMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[foo, foo]-/foo/+/foo^", [result description], @"");
}


- (void)testTrueLiteralBestMatchForFooSpaceBarSpaceBaz {
	s = @"foo bar baz";
	a = [TDTokenAssembly assemblyWithString:s];
	
	p = [TDSequence sequence];
	[p add:[TDLiteral literalWithString:@"foo"]];
	[p add:[TDLiteral literalWithString:@"bar"]];
	[p add:[TDLiteral literalWithString:@"baz"]];
	
	TDAssembly *result = [p bestMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[foo, bar, baz]foo/bar/baz^", [result description], @"");
}


//- (void)testTrueLiteralBestMatchForFooSpaceBarSpaceBaz1 {
//	s = @"foo bar baz";
//	a = [TDTokenAssembly assemblyWithString:s];
//	
//	p = [TDSequence sequence];
//	[p add:[TDLiteral literalWithString:@"foo"]];
//	[p add:[TDLiteral literalWithString:@"baz"]];
//	[p add:[TDLiteral literalWithString:@"bar"]];
//	
//	TDAssembly *result = [p bestMatchFor:a];
//	
//	STAssertNotNil(result, @"");
//	STAssertEqualObjects(@"[foo]foo^bar/baz", [result description], @"");
//}


//- (void)testFalseLiteralBestMatchForFooSpaceBarSpaceBaz {
//	s = @"foo bar baz";
//	a = [TDTokenAssembly assemblyWithString:s];
//	
//	p = [TDSequence sequence];
//	[p add:[TDLiteral literalWithString:@"foo"]];
//	[p add:[TDLiteral literalWithString:@"foo"]];
//	[p add:[TDLiteral literalWithString:@"baz"]];
//	
//	TDAssembly *result = [p bestMatchFor:a];
//	STAssertNotNil(result, @"");
//	STAssertEqualObjects(@"[foo]foo^bar/baz", [result description], @"");
//}


- (void)testTrueLiteralCompleteMatchForFooSpaceBarSpaceBaz {
	s = @"foo bar baz";
	a = [TDTokenAssembly assemblyWithString:s];
	
	p = [TDSequence sequence];
	[p add:[TDLiteral literalWithString:@"foo"]];
	[p add:[TDLiteral literalWithString:@"bar"]];
	[p add:[TDLiteral literalWithString:@"baz"]];
	
	TDAssembly *result = [p completeMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[foo, bar, baz]foo/bar/baz^", [result description], @"");
}


- (void)testTrueLiteralCompleteMatchForFooSpaceBarSpaceBaz1 {
	s = @"foo bar baz";
	a = [TDTokenAssembly assemblyWithString:s];
	
	p = [TDSequence sequence];
	[p add:[TDLiteral literalWithString:@"foo"]];
	[p add:[TDWord word]];
	[p add:[TDLiteral literalWithString:@"baz"]];
	
	TDAssembly *result = [p completeMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[foo, bar, baz]foo/bar/baz^", [result description], @"");
}


- (void)testFalseLiteralCompleteMatchForFooSpaceBarSpaceBaz {
	s = @"foo bar baz";
	a = [TDTokenAssembly assemblyWithString:s];
	
	p = [TDSequence sequence];
	[p add:[TDLiteral literalWithString:@"foo"]];
	[p add:[TDLiteral literalWithString:@"foo"]];
	[p add:[TDLiteral literalWithString:@"baz"]];
	
	TDAssembly *result = [p completeMatchFor:a];
	STAssertNil(result, @"");
}


- (void)testFalseLiteralCompleteMatchForFooSpaceBarSpaceBaz1 {
	s = @"foo bar baz";
	a = [TDTokenAssembly assemblyWithString:s];
	
	p = [TDSequence sequence];
	[p add:[TDLiteral literalWithString:@"foo"]];
	[p add:[TDNum num]];
	[p add:[TDLiteral literalWithString:@"baz"]];
	
	TDAssembly *result = [p completeMatchFor:a];
	STAssertNil(result, @"");
}


- (void)testTrueLiteralAllMatchsForFooSpaceBarSpaceBaz {
	s = @"foo bar baz";
	a = [TDTokenAssembly assemblyWithString:s];
	
	p = [TDSequence sequence];
	[p add:[TDLiteral literalWithString:@"foo"]];
	[p add:[TDLiteral literalWithString:@"bar"]];
	[p add:[TDLiteral literalWithString:@"baz"]];
	
	TDAssembly *result = [p bestMatchFor:a];
	
	STAssertNotNil(result, @"");
}


//- (void)testFalseLiteralAllMatchsForFooSpaceBarSpaceBaz {
//	s = @"foo bar baz";
//	a = [TDTokenAssembly assemblyWithString:s];
//	
//	p = [TDSequence sequence];
//	[p add:[TDLiteral literalWithString:@"foo"]];
//	[p add:[TDLiteral literalWithString:@"123"]];
//	[p add:[TDLiteral literalWithString:@"baz"]];
//	
//	NSSet *result = [p allMatchesFor:[NSSet setWithObject:a]];
//	
//	STAssertNotNil(result, @"");
//	NSInteger c = result.count;
//	STAssertEquals(1, c, @"");
//}
//
@end
