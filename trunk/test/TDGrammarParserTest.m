//
//  TDGrammarParserTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/12/08.
//  Copyright 2008 Todd Ditchendorf All rights reserved.
//

#import "TDGrammarParserTest.h"
#import <TDParseKit/TDParseKit.h>

@implementation TDGrammarParserTest

- (void)setUp {
    p = [TDGrammarParser parser];
}


- (void)testHelloPlus {
    s = @"'hello'+";
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDSequence class]]);
    s = @"hello hello";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[hello, hello]hello/hello^", [res description]);    
}


- (void)testHelloStar {
    s = @"'hello'*";
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDRepetition class]]);
    s = @"hello hello hello";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[hello, hello, hello]hello/hello/hello^", [res description]);    
}


- (void)testHelloQuestion {
    s = @"'hello'?";
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDAlternation class]]);
    s = @"hello hello hello";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[hello]hello^hello/hello", [res description]);    
}


- (void)testOhHaiThereQuestion {
    s = @"'oh'? 'hai'? 'there'?";
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDSequence class]]);
    s = @"there";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[there]there^", [res description]);    
}


- (void)testFooBar {
    s = @"'foo' 'bar'";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Sequence]'foo'/'bar'^", [res description]);
    TDSequence *seq = [res pop];
    TDTrue([seq isMemberOfClass:[TDSequence class]]);
    TDEquals((NSUInteger)2, seq.subparsers.count);
    
    TDLiteral *c = [seq.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDLiteral class]]);
    TDEqualObjects(@"foo", c.string);
    c = [seq.subparsers objectAtIndex:1];
    TDTrue([c isMemberOfClass:[TDLiteral class]]);
    TDEqualObjects(@"bar", c.string);
    
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDSequence class]]);
    s = @"foo bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[foo, bar]foo/bar^", [res description]);
}


- (void)testFooBarBaz {
    s = @"'foo' 'bar' 'baz'";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Sequence]'foo'/'bar'/'baz'^", [res description]);
    TDSequence *seq = [res pop];
    TDTrue([seq isMemberOfClass:[TDSequence class]]);
    TDEquals((NSUInteger)3, seq.subparsers.count);
    
    TDLiteral *c = [seq.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDLiteral class]]);
    TDEqualObjects(@"foo", c.string);
    c = [seq.subparsers objectAtIndex:1];
    TDTrue([c isMemberOfClass:[TDLiteral class]]);
    TDEqualObjects(@"bar", c.string);
    c = [seq.subparsers objectAtIndex:2];
    TDTrue([c isMemberOfClass:[TDLiteral class]]);
    TDEqualObjects(@"baz", c.string);
    
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDSequence class]]);
    s = @"foo bar baz";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[foo, bar, baz]foo/bar/baz^", [res description]);
}


- (void)testFooOrBar {
    s = @"'foo'|'bar'";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Alternation]'foo'/|/'bar'^", [res description]);
    TDAlternation *alt = [res pop];
    TDTrue([alt isMemberOfClass:[TDAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDLiteral *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDLiteral class]]);
    TDEqualObjects(@"foo", c.string);
    c = [alt.subparsers objectAtIndex:1];
    TDTrue([c isMemberOfClass:[TDLiteral class]]);
    TDEqualObjects(@"bar", c.string);
    
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDAlternation class]]);
    s = @"bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[bar]bar^", [res description]);

    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[foo]foo^", [res description]);
}


//- (void)test4Or7 {
//    s = @"4|7";
//    a = [TDTokenAssembly assemblyWithString:s];
//    res = [p bestMatchFor:a];
//    TDNotNil(res);
//    TDEqualObjects(@"[Alternation]4/|/7^", [res description]);
//    TDAlternation *alt = [res pop];
//    TDTrue([alt isMemberOfClass:[TDAlternation class]]);
//    TDEquals((NSUInteger)2, alt.subparsers.count);
//    
//    TDLiteral *c = [alt.subparsers objectAtIndex:0];
//    TDTrue([c isMemberOfClass:[TDLiteral class]]);
//    TDEqualObjects(@"4", c.string);
//    c = [alt.subparsers objectAtIndex:1];
//    TDTrue([c isMemberOfClass:[TDLiteral class]]);
//    TDEqualObjects(@"7", c.string);
//    
//    // use the result parser
//    p = [TDGrammarParser parserForLanguage:s];
//    TDNotNil(p);
//    TDTrue([p isKindOfClass:[TDAlternation class]]);
//    s = @"4";
//    a = [TDTokenAssembly assemblyWithString:s];
//    res = [p bestMatchFor:a];
//    TDEqualObjects(@"[4]4^", [res description]);
//
//    s = @"7";
//    a = [TDTokenAssembly assemblyWithString:s];
//    res = [p bestMatchFor:a];
//    TDEqualObjects(@"[7]7^", [res description]);
//    
//    s = @"7 2";
//    a = [TDTokenAssembly assemblyWithString:s];
//    res = [p bestMatchFor:a];
//    TDEqualObjects(@"[7]7^2", [res description]);
//    
//    s = @"2";
//    a = [TDTokenAssembly assemblyWithString:s];
//    res = [p bestMatchFor:a];
//    TDNil(res);
//}


- (void)testFooOrBarStar {
    s = @"'foo'|'bar'*";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Alternation]'foo'/|/'bar'/*^", [res description]);
    TDAlternation *alt = [res pop];
    TDTrue([alt isMemberOfClass:[TDAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDLiteral *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDLiteral class]]);
    TDEqualObjects(@"foo", c.string);
    
    TDRepetition *rep = [alt.subparsers objectAtIndex:1];
    TDEqualObjects([TDRepetition class], [rep class]);
    c = (TDLiteral *)rep.subparser;
    TDTrue([c isMemberOfClass:[TDLiteral class]]);
    TDEqualObjects(@"bar", c.string);
    
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDAlternation class]]);
    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[foo]foo^", [res description]);

    s = @"foo foo";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[foo]foo^foo", [res description]);
    
    s = @"bar bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[bar, bar]bar/bar^", [res description]);
}


- (void)testFooOrBarPlus {
    s = @"'foo'|'bar'+";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Alternation]'foo'/|/'bar'/+^", [res description]);
    TDAlternation *alt = [res pop];
    TDTrue([alt isMemberOfClass:[TDAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDLiteral *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDLiteral class]]);
    TDEqualObjects(@"foo", c.string);
    
    TDSequence *seq = [alt.subparsers objectAtIndex:1];
    TDEqualObjects([TDSequence class], [seq class]);
    
    c = [seq.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDLiteral class]]);
    TDEqualObjects(@"bar", c.string);
    
    TDRepetition *rep = [seq.subparsers objectAtIndex:1];
    TDEqualObjects([TDRepetition class], [rep class]);
    c = (TDLiteral *)rep.subparser;
    TDTrue([c isMemberOfClass:[TDLiteral class]]);
    TDEqualObjects(@"bar", c.string);
    
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDAlternation class]]);
    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[foo]foo^", [res description]);

    s = @"foo foo";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[foo]foo^foo", [res description]);
    
    s = @"foo bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[foo]foo^bar", [res description]);

    s = @"bar bar bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[bar, bar, bar]bar/bar/bar^", [res description]);
}


- (void)testFooOrBarQuestion {
    s = @"'foo'|'bar'?";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Alternation]'foo'/|/'bar'/?^", [res description]);
    TDAlternation *alt = [res pop];
    TDTrue([alt isMemberOfClass:[TDAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDLiteral *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDLiteral class]]);
    TDEqualObjects(@"foo", c.string);
    
    alt = [alt.subparsers objectAtIndex:1];
    TDEqualObjects([TDAlternation class], [alt class]);
    
    TDEmpty *e = [alt.subparsers objectAtIndex:0];
    TDTrue([e isMemberOfClass:[TDEmpty class]]);
    
    c = (TDLiteral *)[alt.subparsers objectAtIndex:1];
    TDTrue([c isMemberOfClass:[TDLiteral class]]);
    TDEqualObjects(@"bar", c.string);
    
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDAlternation class]]);
    s = @"bar bar bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[bar]bar^bar/bar", [res description]);
    
    s = @"foo bar bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[foo]foo^bar/bar", [res description]);
}


- (void)testParenFooOrBarParenStar {
    s = @"('foo'|'bar')*";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Repetition](/'foo'/|/'bar'/)/*^", [res description]);
    TDRepetition *rep = [res pop];
    TDTrue([rep isMemberOfClass:[TDRepetition class]]);
    
    TDAlternation *alt = (TDAlternation *)rep.subparser;
    TDTrue([alt isMemberOfClass:[TDAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDLiteral *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDLiteral class]]);
    TDEqualObjects(@"foo", c.string);
    
    c = [alt.subparsers objectAtIndex:1];
    TDTrue([c isMemberOfClass:[TDLiteral class]]);
    TDEqualObjects(@"bar", c.string);
    
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDRepetition class]]);
    s = @"foo bar bar foo";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[foo, bar, bar, foo]foo/bar/bar/foo^", [res description]);
}


- (void)testParenFooOrBooParenPlus {
    s = @"('foo'|'bar')+";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Sequence](/'foo'/|/'bar'/)/+^", [res description]);
    TDSequence *seq = [res pop];
    TDTrue([seq isMemberOfClass:[TDSequence class]]);
    
    TDEquals((NSUInteger)2, seq.subparsers.count);
    
    TDAlternation *alt = [seq.subparsers objectAtIndex:0];
    TDTrue([alt isMemberOfClass:[TDAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDLiteral *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDLiteral class]]);
    TDEqualObjects(@"foo", c.string);
    
    c = [alt.subparsers objectAtIndex:1];
    TDTrue([c isMemberOfClass:[TDLiteral class]]);
    TDEqualObjects(@"bar", c.string);
    
    TDRepetition *rep = [seq.subparsers objectAtIndex:1];
    TDTrue([rep isMemberOfClass:[TDRepetition class]]);
    
    alt = (TDAlternation *)rep.subparser;
    TDEqualObjects([TDAlternation class], [alt class]);
    
    c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDLiteral class]]);
    TDEqualObjects(@"foo", c.string);
    
    c = [alt.subparsers objectAtIndex:1];
    TDTrue([c isMemberOfClass:[TDLiteral class]]);
    TDEqualObjects(@"bar", c.string);
    
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDSequence class]]);
    s = @"foo foo bar bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[foo, foo, bar, bar]foo/foo/bar/bar^", [res description]);
}


- (void)testParenFooOrBarParenQuestion {
    s = @"('foo'|'bar')?";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Alternation](/'foo'/|/'bar'/)/?^", [res description]);
    TDAlternation *alt = [res pop];
    TDTrue([alt isMemberOfClass:[TDAlternation class]]);
    
    TDEquals((NSUInteger)2, alt.subparsers.count);
    TDEmpty *e = [alt.subparsers objectAtIndex:0];
    TDTrue([TDEmpty class] == [e class]);
    
    alt = [alt.subparsers objectAtIndex:1];
    TDTrue([alt isMemberOfClass:[TDAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDLiteral *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDLiteral class]]);
    TDEqualObjects(@"foo", c.string);
    
    c = [alt.subparsers objectAtIndex:1];
    TDTrue([c isMemberOfClass:[TDLiteral class]]);
    TDEqualObjects(@"bar", c.string);
    
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDAlternation class]]);
    s = @"foo bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[foo]foo^bar", [res description]);

    s = @"bar bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[bar]bar^bar", [res description]);
}


- (void)testWord {
    s = @"Word";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Word]Word^", [res description]);
    TDWord *w = [res pop];
    TDTrue([w isMemberOfClass:[TDWord class]]);
    
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDWord class]]);
    s = @"hello hello";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[hello]hello^hello", [res description]);    
}


- (void)testWordPlus {
    s = @"Word+";
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    s = @"hello hello";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[hello, hello]hello/hello^", [res description]);    
}


- (void)testNum {
    s = @"Num";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Num]Num^", [res description]);
    TDNum *w = [res pop];
    TDTrue([w isMemberOfClass:[TDNum class]]);
    
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDNum class]]);

    s = @"333 444";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[333]333^444", [res description]);    

    s = @"hello hello";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNil(res);
}


- (void)testNumPlus {
    s = @"Num+";
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    s = @"333 444";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[333, 444]333/444^", [res description]);    
}


- (void)testSymbol {
    s = @"Symbol";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Symbol]Symbol^", [res description]);
    TDSymbol *w = [res pop];
    TDTrue([w isMemberOfClass:[TDSymbol class]]);
    
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDSymbol class]]);
    
    s = @"? #";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[?]?^#", [res description]);    
    
    s = @"hello";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNil(res);
}


- (void)testSymbolPlus {
    s = @"Symbol+";
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    s = @"% *";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[%, *]%/*^", [res description]);    
}


- (void)testQuotedString {
    s = @"QuotedString";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[QuotedString]QuotedString^", [res description]);
    TDQuotedString *w = [res pop];
    TDTrue([w isMemberOfClass:[TDQuotedString class]]);
    
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDQuotedString class]]);
    s = @"'hello' 'hello'";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"['hello']'hello'^'hello'", [res description]);    
}


- (void)testQuotedStringPlus {
    s = @"QuotedString+";
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    s = @"'hello' 'hello'";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"['hello', 'hello']'hello'/'hello'^", [res description]);    
}

@end