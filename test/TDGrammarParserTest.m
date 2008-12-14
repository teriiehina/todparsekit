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
    s = @"hello+";
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
    s = @"hello*";
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
    s = @"hello?";
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDAlternation class]]);
    s = @"hello hello hello";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[hello]hello^hello/hello", [res description]);    
}


- (void)testFooBar {
    s = @"foo bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Sequence]foo/bar^", [res description]);
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
    s = @"foo bar baz";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Sequence]foo/bar/baz^", [res description]);
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
    s = @"foo|bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Alternation]foo/|/bar^", [res description]);
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


- (void)test4Or7 {
    s = @"4|7";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Alternation]4/|/7^", [res description]);
    TDAlternation *alt = [res pop];
    TDTrue([alt isMemberOfClass:[TDAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDLiteral *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDLiteral class]]);
    TDEqualObjects(@"4", c.string);
    c = [alt.subparsers objectAtIndex:1];
    TDTrue([c isMemberOfClass:[TDLiteral class]]);
    TDEqualObjects(@"7", c.string);
    
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDAlternation class]]);
    s = @"4";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[4]4^", [res description]);

    s = @"7";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[7]7^", [res description]);
    
    s = @"7 2";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDEqualObjects(@"[7]7^2", [res description]);
    
    s = @"2";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNil(res);
}


- (void)testFooOrBarStar {
    s = @"foo|bar*";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Alternation]foo/|/bar/*^", [res description]);
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
    s = @"foo|bar+";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Alternation]foo/|/bar/+^", [res description]);
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
    s = @"foo|bar?";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Alternation]foo/|/bar/?^", [res description]);
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
    s = @"(foo|bar)*";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Repetition](/foo/|/bar/)/*^", [res description]);
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
    s = @"(foo|bar)+";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Sequence](/foo/|/bar/)/+^", [res description]);
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
    s = @"(foo|bar)?";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Alternation](/foo/|/bar/)/?^", [res description]);
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


































//- (void)test1 {
//    s = @"$baz = bar; ($baz|foo)*;";
//    res = [p parse:s];
//    TDNotNil(res);
//    s = @"bar foo bar foo";
//    a = [res completeMatchFor:[TDTokenAssembly assemblyWithString:s]];
//    TDEqualObjects(@"[bar, foo, bar, foo]bar/foo/bar/foo^", [a description]);
//
//    s = @"$baz = bar; ($baz|foo)+;";
//    res = [p parse:s];
//    s = @"bar foo bar foo";
//    a = [res completeMatchFor:[TDTokenAssembly assemblyWithString:s]];
//    TDEqualObjects(@"[bar, foo, bar, foo]bar/foo/bar/foo^", [a description]);
//}


//- (void)test2 {
//    s = @"foo bar baz;";
//    res = [p parse:s];
//    TDNotNil(res);
//    s = @"foo bar baz;";
//    a = [p completeMatchFor:[TDTokenAssembly assemblyWithString:s]];
//    TDEqualObjects(@"[Sequence]foo/bar/baz/;^", [a description]);
//}
//
//
//// phrase            = atomicValue | '(' expression ')'
//- (void)testPhraseFoo {
//    s = @"foo";
//    p.tokenizer.string = s;
//    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
//    res = [[p.phraseParser completeMatchFor:a] pop];
//    TDNotNil(res);
//    TDEqualObjects([res class], [TDLiteral class]);
//    TDLiteral *l = (TDLiteral *)res;
//    TDEqualObjects(l.string, @"foo");
//}
//
//
//- (void)testPhraseParenFooParen {
//    s = @"(foo)";
//    p.tokenizer.string = s;
//    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
//    res = [[p.phraseParser completeMatchFor:a] pop];
//    TDNotNil(res);
//    TDEqualObjects([res class], [TDLiteral class]);
//    TDLiteral *l = (TDLiteral *)res;
//    TDEqualObjects(l.string, @"foo");
//}
//
//
//- (void)testPhraseParen47Dot8Paren {
//    s = @"(47.8)";
//    p.tokenizer.string = s;
//    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
//    res = [[p.phraseParser completeMatchFor:a] pop];
//    TDNotNil(res);
//    TDEqualObjects([res class], [TDLiteral class]);
//    TDLiteral *l = (TDLiteral *)res;
//    TDEqualObjects(l.string, @"47.8");
//}
//
//
//- (void)testTermFooBar {
//    s = @"foo bar";
//    p.tokenizer.string = s;
//    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
//    res = [[p.termParser bestMatchFor:a] pop];
//    
//    // Seq(foo, bar)
//    TDNotNil(res);
//    TDEqualObjects([res class], [TDSequence class]);
//    TDSequence *seq = (TDSequence *)res;
//    TDEquals((NSUInteger)2, seq.subparsers.count);
//    
//    TDLiteral *l1 = [seq.subparsers objectAtIndex:0];
//    TDEqualObjects([l1 class], [TDLiteral class]);
//    TDEqualObjects(l1.string, @"foo");
//    
//    TDLiteral *l2 = [seq.subparsers objectAtIndex:1];
//    TDEqualObjects([l2 class], [TDLiteral class]);
//    TDEqualObjects(l2.string, @"bar");
//}
//

//- (void)testTermFooBarBaz {
//    s = @"foo bar baz";
//    p.tokenizer.string = s;
//    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
//    res = [[p.termParser bestMatchFor:a] pop];
//    
//    // Seq(Seq(foo, bar), baz)
//    // Seq(foo, bar, baz)
//    TDNotNil(res);
//    TDEqualObjects([res class], [TDSequence class]);
//    TDSequence *seq = (TDSequence *)res;
//    TDEquals((NSUInteger)3, seq.subparsers.count);
//    
//    TDSequence *s1 = [seq.subparsers objectAtIndex:0];
//    TDEqualObjects([s1 class], [TDSequence class]);
//
//    TDLiteral *l1 = [seq.subparsers objectAtIndex:0];
//    TDEqualObjects([l1 class], [TDLiteral class]);
//    TDEqualObjects(l1.string, @"foo");
//    
//    TDLiteral *l2 = [s1.subparsers objectAtIndex:1];
//    TDEqualObjects([l2 class], [TDLiteral class]);
//    TDEqualObjects(l2.string, @"bar");
//
//    TDLiteral *l3 = [seq.subparsers objectAtIndex:1];
//    TDEqualObjects([l3 class], [TDLiteral class]);
//    TDEqualObjects(l3.string, @"baz");
//}


//- (void)testExpressionFooOrBar {
//    s = @"foo|bar";
//    p.tokenizer.string = s;
//    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
//    res = [[p.expressionParser bestMatchFor:a] pop];
//    
//    // Alt(foo, bar)
//    TDNotNil(res);
//    TDEqualObjects([res class], [TDAlternation class]);
//    TDAlternation *alt = (TDAlternation *)res;
//    TDEquals((NSUInteger)2, alt.subparsers.count);
//
//    TDLiteral *l1 = [alt.subparsers objectAtIndex:0];
//    TDEqualObjects([l1 class], [TDLiteral class]);
//    TDEqualObjects(l1.string, @"foo");
//
//    TDLiteral *l2 = [alt.subparsers objectAtIndex:1];
//    TDEqualObjects([l2 class], [TDLiteral class]);
//    TDEqualObjects(l2.string, @"bar");
//}

@end
