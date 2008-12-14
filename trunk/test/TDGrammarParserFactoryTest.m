//
//  TDGrammarParserFactoryTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/12/08.
//  Copyright 2008 Todd Ditchendorf All rights reserved.
//

#import "TDGrammarParserFactoryTest.h"
#import <TDParseKit/TDParseKit.h>

@implementation TDGrammarParserFactoryTest

- (void)setUp {
    gp = [[[TDGrammarParserFactory alloc] init] autorelease];
    TDSequence *seq = [TDSequence sequence];
    [seq add:gp.expressionParser];
    exprSeq = seq;
}


- (void)testStartLiteral {
    s = @"start = 'bar';";
    lp = [TDGrammarParserFactory parserForGrammar:s];
    TDNotNil(lp);
    NSLog(@"lp: %@", lp);
    TDTrue([lp isKindOfClass:[TDParser class]]);
    s = @"bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [lp bestMatchFor:a];
    TDEqualObjects(@"[bar]bar^", [res description]);
}


- (void)testExprHelloPlus {
    s = @"'hello'+";
    // use the result parser
    exprSeq = [TDGrammarParserFactory parserForExpression:s];
    TDNotNil(exprSeq);
    TDTrue([exprSeq isKindOfClass:[TDSequence class]]);
    s = @"hello hello";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"[hello, hello]hello/hello^", [res description]);    
}


- (void)testExprHelloStar {
    s = @"'hello'*";
    // use the result parser
    exprSeq = [TDGrammarParserFactory parserForExpression:s];
    TDNotNil(exprSeq);
    TDTrue([exprSeq isKindOfClass:[TDRepetition class]]);
    s = @"hello hello hello";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"[hello, hello, hello]hello/hello/hello^", [res description]);    
}


- (void)testExprHelloQuestion {
    s = @"'hello'?";
    // use the result parser
    exprSeq = [TDGrammarParserFactory parserForExpression:s];
    TDNotNil(exprSeq);
    TDTrue([exprSeq isKindOfClass:[TDAlternation class]]);
    s = @"hello hello hello";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"[hello]hello^hello/hello", [res description]);    
}


- (void)testExprOhHaiThereQuestion {
    s = @"'oh'? 'hai'? 'there'?";
    // use the result parser
    exprSeq = [TDGrammarParserFactory parserForExpression:s];
    TDNotNil(exprSeq);
    TDTrue([exprSeq isKindOfClass:[TDSequence class]]);
    s = @"there";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"[there]there^", [res description]);    
}


- (void)testExprFooBar {
    s = @"'foo' 'bar'";
    a = [TDTokenAssembly assemblyWithString:s];

    res = [exprSeq bestMatchFor:a];
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
    exprSeq = [TDGrammarParserFactory parserForExpression:s];
    TDNotNil(exprSeq);
    TDTrue([exprSeq isKindOfClass:[TDSequence class]]);
    s = @"foo bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"[foo, bar]foo/bar^", [res description]);
}


- (void)testExprFooBarBaz {
    s = @"'foo' 'bar' 'baz'";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
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
    exprSeq = [TDGrammarParserFactory parserForExpression:s];
    TDNotNil(exprSeq);
    TDTrue([exprSeq isKindOfClass:[TDSequence class]]);
    s = @"foo bar baz";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"[foo, bar, baz]foo/bar/baz^", [res description]);
}


- (void)testExprFooOrBar {
    s = @"'foo'|'bar'";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
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
    exprSeq = [TDGrammarParserFactory parserForExpression:s];
    TDNotNil(exprSeq);
    TDTrue([exprSeq isKindOfClass:[TDAlternation class]]);
    s = @"bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"[bar]bar^", [res description]);

    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"[foo]foo^", [res description]);
}


//- (void)testExpr4Or7 {
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
//    p = [TDGrammarParserFactory parserForGrammar:s];
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


- (void)testExprFooOrBarStar {
    s = @"'foo'|'bar'*";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
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
    exprSeq = [TDGrammarParserFactory parserForExpression:s];
    TDNotNil(exprSeq);
    TDTrue([exprSeq isKindOfClass:[TDAlternation class]]);
    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"[foo]foo^", [res description]);

    s = @"foo foo";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"[foo]foo^foo", [res description]);
    
    s = @"bar bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"[bar, bar]bar/bar^", [res description]);
}


- (void)testExprFooOrBarPlus {
    s = @"'foo'|'bar'+";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
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
    exprSeq = [TDGrammarParserFactory parserForExpression:s];
    TDNotNil(exprSeq);
    TDTrue([exprSeq isKindOfClass:[TDAlternation class]]);
    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"[foo]foo^", [res description]);

    s = @"foo foo";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"[foo]foo^foo", [res description]);
    
    s = @"foo bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"[foo]foo^bar", [res description]);

    s = @"bar bar bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"[bar, bar, bar]bar/bar/bar^", [res description]);
}


- (void)testExprFooOrBarQuestion {
    s = @"'foo'|'bar'?";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
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
    exprSeq = [TDGrammarParserFactory parserForExpression:s];
    TDNotNil(exprSeq);
    TDTrue([exprSeq isKindOfClass:[TDAlternation class]]);
    s = @"bar bar bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"[bar]bar^bar/bar", [res description]);
    
    s = @"foo bar bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"[foo]foo^bar/bar", [res description]);
}


- (void)testExprParenFooOrBarParenStar {
    s = @"('foo'|'bar')*";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
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
    exprSeq = [TDGrammarParserFactory parserForExpression:s];
    TDNotNil(exprSeq);
    TDTrue([exprSeq isKindOfClass:[TDRepetition class]]);
    s = @"foo bar bar foo";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"[foo, bar, bar, foo]foo/bar/bar/foo^", [res description]);
}


- (void)testExprParenFooOrBooParenPlus {
    s = @"('foo'|'bar')+";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
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
    exprSeq = [TDGrammarParserFactory parserForExpression:s];
    TDNotNil(exprSeq);
    TDTrue([exprSeq isKindOfClass:[TDSequence class]]);
    s = @"foo foo bar bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"[foo, foo, bar, bar]foo/foo/bar/bar^", [res description]);
}


- (void)testExprParenFooOrBarParenQuestion {
    s = @"('foo'|'bar')?";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
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
    exprSeq = [TDGrammarParserFactory parserForExpression:s];
    TDNotNil(exprSeq);
    TDTrue([exprSeq isKindOfClass:[TDAlternation class]]);
    s = @"foo bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"[foo]foo^bar", [res description]);

    s = @"bar bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"[bar]bar^bar", [res description]);
}


- (void)testExprWord {
    s = @"Word";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Word]Word^", [res description]);
    TDWord *w = [res pop];
    TDTrue([w isMemberOfClass:[TDWord class]]);
    
    // use the result parser
    exprSeq = [TDGrammarParserFactory parserForExpression:s];
    TDNotNil(exprSeq);
    TDTrue([exprSeq isKindOfClass:[TDWord class]]);
    s = @"hello hello";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"[hello]hello^hello", [res description]);    
}


- (void)testExprWordPlus {
    s = @"Word+";
    // use the result parser
    exprSeq = [TDGrammarParserFactory parserForExpression:s];
    TDNotNil(exprSeq);
    s = @"hello hello";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"[hello, hello]hello/hello^", [res description]);    
}


- (void)testExprNum {
    s = @"Num";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Num]Num^", [res description]);
    TDNum *w = [res pop];
    TDTrue([w isMemberOfClass:[TDNum class]]);
    
    // use the result parser
    exprSeq = [TDGrammarParserFactory parserForExpression:s];
    TDNotNil(exprSeq);
    TDTrue([exprSeq isKindOfClass:[TDNum class]]);

    s = @"333 444";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"[333]333^444", [res description]);    

    s = @"hello hello";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDNil(res);
}


- (void)testExprNumPlus {
    s = @"Num+";
    // use the result parser
    exprSeq = [TDGrammarParserFactory parserForExpression:s];
    TDNotNil(exprSeq);
    s = @"333 444";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"[333, 444]333/444^", [res description]);    
}


- (void)testExprSymbol {
    s = @"Symbol";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Symbol]Symbol^", [res description]);
    TDSymbol *w = [res pop];
    TDTrue([w isMemberOfClass:[TDSymbol class]]);
    
    // use the result parser
    exprSeq = [TDGrammarParserFactory parserForExpression:s];
    TDNotNil(exprSeq);
    TDTrue([exprSeq isKindOfClass:[TDSymbol class]]);
    
    s = @"? #";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"[?]?^#", [res description]);    
    
    s = @"hello";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDNil(res);
}


- (void)testExprSymbolPlus {
    s = @"Symbol+";
    // use the result parser
    exprSeq = [TDGrammarParserFactory parserForExpression:s];
    TDNotNil(exprSeq);
    s = @"% *";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"[%, *]%/*^", [res description]);    
}


- (void)testExprQuotedString {
    s = @"QuotedString";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[QuotedString]QuotedString^", [res description]);
    TDQuotedString *w = [res pop];
    TDTrue([w isMemberOfClass:[TDQuotedString class]]);
    
    // use the result parser
    exprSeq = [TDGrammarParserFactory parserForExpression:s];
    TDNotNil(exprSeq);
    TDTrue([exprSeq isKindOfClass:[TDQuotedString class]]);
    s = @"'hello' 'hello'";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"['hello']'hello'^'hello'", [res description]);    
}


- (void)testExprQuotedStringPlus {
    s = @"QuotedString+";
    // use the result parser
    exprSeq = [TDGrammarParserFactory parserForExpression:s];
    TDNotNil(exprSeq);
    s = @"'hello' 'hello'";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [exprSeq bestMatchFor:a];
    TDEqualObjects(@"['hello', 'hello']'hello'/'hello'^", [res description]);    
}

@end