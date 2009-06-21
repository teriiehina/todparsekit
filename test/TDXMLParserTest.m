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
    TDParser *sTag = [p parserNamed:@"sTag"];
    
	t.string = @"<foo>";
    res = [sTag bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
	TDEqualObjects(@"[<, foo, >]</foo/>^", [res description]);

	t.string = @"<foo >";
    res = [sTag bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
	TDEqualObjects(@"[<, foo,  , >]</foo/ />^", [res description]);
    
	t.string = @"<foo \t>";
    res = [sTag bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
	TDEqualObjects(@"[<, foo,  \t, >]</foo/ \t/>^", [res description]);
    
	t.string = @"<foo \n >";
    res = [sTag bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
	TDEqualObjects(@"[<, foo,  \n , >]</foo/ \n />^", [res description]);
    
	t.string = @"<foo bar='baz'>";
    res = [sTag bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
	TDEqualObjects(@"[<, foo,  , bar, =, 'baz', >]</foo/ /bar/=/'baz'/>^", [res description]);

	t.string = @"<foo bar='baz' baz='bat'>";
    res = [sTag bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
	TDEqualObjects(@"[<, foo,  , bar, =, 'baz',  , baz, =, 'bat', >]</foo/ /bar/=/'baz'/ /baz/=/'bat'/>^", [res description]);
    
	t.string = @"<foo bar='baz' baz=\t'bat'>";
    res = [sTag bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
	TDEqualObjects(@"[<, foo,  , bar, =, 'baz',  , baz, =, \t, 'bat', >]</foo/ /bar/=/'baz'/ /baz/=/\t/'bat'/>^", [res description]);
}


- (void)testSmallSTagGrammar {
    g = @"@delimitState='<';@reportsWhitespaceTokens=YES;@start=sTag;sTag='<' name (S attribute)* S? '>';name=/[^-:\\.]\\w+/;attribute=name eq attValue;eq=S? '=' S?;attValue=QuotedString;";
    TDParser *sTag = [factory parserFromGrammar:g assembler:nil];
    t = sTag.tokenizer;

    t.string = @"<foo>";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [sTag bestMatchFor:a];
	TDEqualObjects(@"[<, foo, >]</foo/>^", [res description]);

    t.string = @"<foo >";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [sTag bestMatchFor:a];
	TDEqualObjects(@"[<, foo,  , >]</foo/ />^", [res description]);

    t.string = @"<foo \n>";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [sTag bestMatchFor:a];
	TDEqualObjects(@"[<, foo,  \n, >]</foo/ \n/>^", [res description]);

    t.string = @"< foo>";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [sTag bestMatchFor:a];
	TDNil(res);
}


- (void)testSmallETagGrammar {
    g = @"@symbols='</';@delimitState='<';@reportsWhitespaceTokens=YES;@start=eTag;eTag = '</' name S? '>';name=/[^-:\\.]\\w+/;";
    TDParser *eTag = [factory parserFromGrammar:g assembler:nil];
    t = eTag.tokenizer;
    
    t.string = @"</foo>";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [eTag bestMatchFor:a];
	TDEqualObjects(@"[</, foo, >]<//foo/>^", [res description]);
    
    t.string = @"</foo >";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [eTag bestMatchFor:a];
	TDEqualObjects(@"[</, foo,  , >]<//foo/ />^", [res description]);
    
    t.string = @"</ foo>";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [eTag bestMatchFor:a];
	TDNil(res);

    t.string = @"< /foo>";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [eTag bestMatchFor:a];
	TDNil(res);
}
    
    
- (void)testETag {
	t.string = @"</foo>";
//    res = [[p parserNamed:@"eTag"] bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
//    TDEqualObjects(@"[</, foo, >]<//foo/>^", [res description]);
}


- (void)test1 {
	t.string = @"<foo></foo>";
    res = [[p parserNamed:@"element"] bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
//    TDEqualObjects(@"[<, foo, >, </, foo, >]</foo/>/<//foo/>^", [res description]);

	t.string = @"<foo/>";
    res = [[p parserNamed:@"emptyElemTag"] bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[<, foo, />]</foo//>^", [res description]);
}


- (void)testSmallEmptyElemTagGrammar {
    g = @"@delimitState='<';@symbols='/>';@reportsWhitespaceTokens=YES;@start=emptyElemTag;emptyElemTag='<' name (S attribute)* S? '/>';name=/[^-:\\.]\\w+/;attribute=name eq attValue;eq=S? '=' S?;attValue=QuotedString;";
    TDParser *emptyElemTag = [factory parserFromGrammar:g assembler:nil];
    t = emptyElemTag.tokenizer;
    
    t.string = @"<foo/>";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [emptyElemTag bestMatchFor:a];
	TDEqualObjects(@"[<, foo, />]</foo//>^", [res description]);
    
    t.string = @"<foo />";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [emptyElemTag bestMatchFor:a];
	TDEqualObjects(@"[<, foo,  , />]</foo/ //>^", [res description]);
    
    t.string = @"<foo bar='baz'/>";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [emptyElemTag bestMatchFor:a];
	TDEqualObjects(@"[<, foo,  , bar, =, 'baz', />]</foo/ /bar/=/'baz'//>^", [res description]);
    
}    
@end
