//
//  TODParserTest.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODParserTest.h"


@implementation TODParserTest

- (void)setUp {
}


- (void)tearDown {
}


#pragma mark -

- (void)testMath {
	s = @"2 4 6 8";
	a = [TODTokenAssembly assemblyWithString:s];
	
	p = [TODRepetition repetitionWithSubparser:[TODNum num]];
	
	TODAssembly *result = [p completeMatchFor:a];
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[2, 4, 6, 8]2/4/6/8^", [result description], @"");
}


- (void)testMiniMath {
	s = @"4.5 - 5.6 - 222.0";
	a = [TODTokenAssembly assemblyWithString:s];
	
	TODParser *num = [TODNum num];
	
	TODSequence *minusNum = [TODSequence sequence];
	[minusNum add:[[TODSymbol symbolWithString:@"-"] discard]];
	[minusNum add:[TODNum num]];
	
	TODRepetition *m = [TODRepetition repetitionWithSubparser:minusNum];
	
	TODSequence *e = [TODSequence sequence];
	[e add:num];
	[e add:m];
	
//	TODAssembly *result = [e completeMatchFor:a];
//	TODAssembly *result = [m completeMatchFor:a];
//	STAssertNotNil(result, @"");
//	//STAssertEqualObjects(@"[4.5, 5.6, 222.0]4.5/5.6/222.0^", [result description], @"");
//	STAssertEqualObjects(@"[4.5, 5.6, 222.0]4.5/-/5.6/-/222.0^", [result description], @"");
}
//
//
//- (void)testMiniMathWithBrackets {
//	s = @"[4.5 - 5.6 - 222.0]";
//	a = [TODTokenAssembly assemblyWithString:s];
//	
//	TODParser *num = [TODNum num];
//	
//	TODSequence *minusNum = [TODSequence sequence];
//	[minusNum add:[[TODSymbol symbolWithString:@"-"] discard]];
//	[minusNum add:[TODNum num]];
//	
//	TODRepetition *m = [TODRepetition repetitionWithSubparser:minusNum];
//	
//	TODSequence *e = [TODSequence sequence];
//	[e add:[[TODSymbol symbolWithString:@"["] discard]];
//	[e add:num];
//	[e add:m];
//	[e add:[[TODSymbol symbolWithString:@"]"] discard]];
//	
//	TODAssembly *result = [e completeMatchFor:a];
//	STAssertNotNil(result, @"");
//	//STAssertEqualObjects(@"[4.5, 5.6, 222.0]4.5/5.6/222.0^", [result description], @"");
//	STAssertEqualObjects(@"[4.5, 5.6, 222.0][/4.5/-/5.6/-/222.0/]^", [result description], @"");
//}
//
//
//- (void)testHotHotSteamingHotCoffee {
//	TODAlternation *adjective = [TODAlternation alternation];
//	[adjective add:[TODLiteral literalWithString:@"hot"]];
//	[adjective add:[TODLiteral literalWithString:@"steaming"]];
//
//	TODRepetition *adjectives = [TODRepetition repetitionWithSubparser:adjective];
//	
//	TODSequence *sentence = [TODSequence sequence];
//	[sentence add:adjectives];
//	[sentence add:[TODLiteral literalWithString:@"coffee"]];
//
//	s = @"hot hot steaming hot coffee";
//	a = [TODTokenAssembly assemblyWithString:s];
//	
//	TODAssembly *result = [sentence bestMatchFor:a];
//	
//	STAssertNotNil(result, @"");
//	STAssertEqualObjects(@"[hot, hot, steaming, hot, coffee]hot/hot/steaming/hot/coffee^", [result description], @"");
//}
//	
//
//- (void)testList {
//	TODAssembly *result = nil;
//
//	TODSequence *commaTerm = [TODSequence sequence];
//	[commaTerm add:[[TODSymbol symbolWithString:@","] discard]];
//	[commaTerm add:[TODWord word]];
//
//	TODSequence *actualList = [TODSequence sequence];
//	[actualList add:[TODWord word]];
//	[actualList add:[TODRepetition repetitionWithSubparser:commaTerm]];
//	
//	TODSequence *list = [TODSequence sequence];
//	[list add:[[TODSymbol symbolWithString:@"["] discard]];
//	[list add:actualList];
//	[list add:[[TODSymbol symbolWithString:@"]"] discard]];
//
//	s = @"[foo, bar, baz]";
//	a = [TODTokenAssembly assemblyWithString:s];
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
//	a = [TODTokenAssembly assemblyWithString:s];
//	
//	TODAlternation *literals = [TODAlternation alternation];
//	[literals add:[TODQuotedString quotedString]];
//	[literals add:[TODNum num]];
//	
//	TODAssembly *result = [literals bestMatchFor:a];
//	STAssertNotNil(result, @"");
//	STAssertEqualObjects(@"[123]123^'boo'", [result description], @"");
//}
//
//
//- (void)testStuff {
//	s = @"";
//	a = [TODTokenAssembly assemblyWithString:s];
//	
//	
//}


@end
