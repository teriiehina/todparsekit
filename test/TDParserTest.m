//
//  TDParserTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDParserTest.h"


@implementation TDParserTest

- (void)setUp {
}


- (void)tearDown {
}


#pragma mark -

- (void)testMath {
	s = @"2 4 6 8";
	a = [TDTokenAssembly assemblyWithString:s];
	
	p = [TDRepetition repetitionWithSubparser:[TDNum num]];
	
	TDAssembly *result = [p completeMatchFor:a];
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[2, 4, 6, 8]2/4/6/8^", [result description], @"");
}


- (void)testMiniMath {
	s = @"4.5 - 5.6 - 222.0";
	a = [TDTokenAssembly assemblyWithString:s];
	
	TDParser *num = [TDNum num];
	
	TDSequence *minusNum = [TDSequence sequence];
	[minusNum add:[[TDSymbol symbolWithString:@"-"] discard]];
	[minusNum add:[TDNum num]];
	
	TDRepetition *m = [TDRepetition repetitionWithSubparser:minusNum];
	
	TDSequence *e = [TDSequence sequence];
	[e add:num];
	[e add:m];
	
//	TDAssembly *result = [e completeMatchFor:a];
//	TDAssembly *result = [m completeMatchFor:a];
//	STAssertNotNil(result, @"");
//	//STAssertEqualObjects(@"[4.5, 5.6, 222.0]4.5/5.6/222.0^", [result description], @"");
//	STAssertEqualObjects(@"[4.5, 5.6, 222.0]4.5/-/5.6/-/222.0^", [result description], @"");
}
//
//
//- (void)testMiniMathWithBrackets {
//	s = @"[4.5 - 5.6 - 222.0]";
//	a = [TDTokenAssembly assemblyWithString:s];
//	
//	TDParser *num = [TDNum num];
//	
//	TDSequence *minusNum = [TDSequence sequence];
//	[minusNum add:[[TDSymbol symbolWithString:@"-"] discard]];
//	[minusNum add:[TDNum num]];
//	
//	TDRepetition *m = [TDRepetition repetitionWithSubparser:minusNum];
//	
//	TDSequence *e = [TDSequence sequence];
//	[e add:[[TDSymbol symbolWithString:@"["] discard]];
//	[e add:num];
//	[e add:m];
//	[e add:[[TDSymbol symbolWithString:@"]"] discard]];
//	
//	TDAssembly *result = [e completeMatchFor:a];
//	STAssertNotNil(result, @"");
//	//STAssertEqualObjects(@"[4.5, 5.6, 222.0]4.5/5.6/222.0^", [result description], @"");
//	STAssertEqualObjects(@"[4.5, 5.6, 222.0][/4.5/-/5.6/-/222.0/]^", [result description], @"");
//}
//
//
//- (void)testHotHotSteamingHotCoffee {
//	TDAlternation *adjective = [TDAlternation alternation];
//	[adjective add:[TDLiteral literalWithString:@"hot"]];
//	[adjective add:[TDLiteral literalWithString:@"steaming"]];
//
//	TDRepetition *adjectives = [TDRepetition repetitionWithSubparser:adjective];
//	
//	TDSequence *sentence = [TDSequence sequence];
//	[sentence add:adjectives];
//	[sentence add:[TDLiteral literalWithString:@"coffee"]];
//
//	s = @"hot hot steaming hot coffee";
//	a = [TDTokenAssembly assemblyWithString:s];
//	
//	TDAssembly *result = [sentence bestMatchFor:a];
//	
//	STAssertNotNil(result, @"");
//	STAssertEqualObjects(@"[hot, hot, steaming, hot, coffee]hot/hot/steaming/hot/coffee^", [result description], @"");
//}
//	
//
//- (void)testList {
//	TDAssembly *result = nil;
//
//	TDSequence *commaTerm = [TDSequence sequence];
//	[commaTerm add:[[TDSymbol symbolWithString:@","] discard]];
//	[commaTerm add:[TDWord word]];
//
//	TDSequence *actualList = [TDSequence sequence];
//	[actualList add:[TDWord word]];
//	[actualList add:[TDRepetition repetitionWithSubparser:commaTerm]];
//	
//	TDSequence *list = [TDSequence sequence];
//	[list add:[[TDSymbol symbolWithString:@"["] discard]];
//	[list add:actualList];
//	[list add:[[TDSymbol symbolWithString:@"]"] discard]];
//
//	s = @"[foo, bar, baz]";
//	a = [TDTokenAssembly assemblyWithString:s];
//
//	result = [list bestMatchFor:a];
//	STAssertNotNil(result, @"");
//	//STAssertEqualObjects(@"[foo, bar, baz]foo/bar/baz^", [result description], @"");
//	STAssertEqualObjects(@"[foo, bar, baz][/foo/,/bar/,/baz/]^", [result description], @"");
//}
//
//
//- (void)testJavaScriptStatement {
//	s = @"123 'boo'";
//	a = [TDTokenAssembly assemblyWithString:s];
//	
//	TDAlternation *literals = [TDAlternation alternation];
//	[literals add:[TDQuotedString quotedString]];
//	[literals add:[TDNum num]];
//	
//	TDAssembly *result = [literals bestMatchFor:a];
//	STAssertNotNil(result, @"");
//	STAssertEqualObjects(@"[123]123^'boo'", [result description], @"");
//}
//
//
//- (void)testStuff {
//	s = @"";
//	a = [TDTokenAssembly assemblyWithString:s];
//	
//	
//}


@end
