//
//  TDXMLParserTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDXMLParserTest.h"

@implementation TDXMLParserTest

- (void)setUp {
	NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"xml" ofType:@"grammar"];
	g = [NSString stringWithContentsOfFile:path];
    factory = [TDParserFactory factory];
	p = [factory parserFromGrammar:g assembler:self];
    t = p.tokenizer;
}


- (void)testSTag {
	t.string = @"<foo>";
    res = [[p parserNamed:@"sTag"] bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
	TDEqualObjects(@"[<, foo, >]</foo/>^", [res description]);

	t.string = @"<foo >";
    res = [[p parserNamed:@"sTag"] bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
	TDEqualObjects(@"[<, foo,  , >]</foo/ />^", [res description]);
    
	t.string = @"<foo \t>";
    res = [[p parserNamed:@"sTag"] bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
	TDEqualObjects(@"[<, foo,  \t, >]</foo/ \t/>^", [res description]);
    
	t.string = @"<foo \n >";
    res = [[p parserNamed:@"sTag"] bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
	TDEqualObjects(@"[<, foo,  \n , >]</foo/ \n />^", [res description]);
    
	t.string = @"<foo bar='baz'>";
    res = [[p parserNamed:@"sTag"] bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
	TDEqualObjects(@"[<, foo,  , bar, =, 'baz', >]</foo/ /bar/=/'baz'/>^", [res description]);
}


- (void)testSmallSTagGrammar {
    g = @"@reportsWhitespaceTokens=YES;@start=sTag;sTag='<' name (S attribute)* S? '>';name=/[^-:\\.]\\w+/;attribute=name eq attValue;eq=S? '=' S?;attValue=QuotedString;";
    p = [factory parserFromGrammar:g assembler:nil];
    t = p.tokenizer;

    t.string = @"<foo>";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [p bestMatchFor:a];
	TDEqualObjects(@"[<, foo, >]</foo/>^", [res description]);

    t.string = @"<foo >";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [p bestMatchFor:a];
	TDEqualObjects(@"[<, foo,  , >]</foo/ />^", [res description]);

    t.string = @"<foo \n>";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [p bestMatchFor:a];
	TDEqualObjects(@"[<, foo,  \n, >]</foo/ \n/>^", [res description]);

    t.string = @"< foo>";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [p bestMatchFor:a];
	TDNil(res);
}


- (void)testETag {
	t.string = @"</foo>";
//    res = [[p parserNamed:@"eTag"] bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
	//TDEqualObjects(@"[</, foo, >]<//foo/>^", [res description]);
}


- (void)test1 {
	t.string = @"<foo></foo>";
    res = [[p parserNamed:@"element"] bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
//    TDEqualObjects(@"[<, foo, >, </, foo, >]</foo/>/<//foo/>^", [res description]);

	t.string = @"<foo/>";
    res = [[p parserNamed:@"emptyElemTag"] bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[<, foo, />]</foo//>^", [res description]);
}

@end
