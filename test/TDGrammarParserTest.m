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


//- (void)test {
//    s = @"1aa(2|3)*";
//    a = [TDCharacterAssembly assemblyWithString:s];
//    res = [p completeMatchFor:a];
////    NSLog(@"result: %@", result);
//}

- (void)testAabPlus {
    s = @"aab+";
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDSequence class]]);
    s = @"aabbbb";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = (TDCharacterAssembly *)[p bestMatchFor:a];
    TDEqualObjects(@"[a, a, b, b, b, b]aabbbb^", [res description]);    
}


- (void)testAabStar {
    s = @"aab*";
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDSequence class]]);
    s = @"aabbbb";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = (TDCharacterAssembly *)[p bestMatchFor:a];
    TDEqualObjects(@"[a, a, b, b, b, b]aabbbb^", [res description]);    
}


- (void)testAabQuestion {
    s = @"aab?";
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDSequence class]]);
    s = @"aabbbb";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = (TDCharacterAssembly *)[p bestMatchFor:a];
    TDEqualObjects(@"[a, a, b]aab^bbb", [res description]);    
}


- (void)testAb {
    s = @"ab";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Sequence]ab^", [res description]);
    TDSequence *seq = [res pop];
    TDTrue([seq isMemberOfClass:[TDSequence class]]);
    TDEquals((NSUInteger)2, seq.subparsers.count);
    
    TDSpecificChar *c = [seq.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"a", c.string);
    c = [seq.subparsers objectAtIndex:1];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"b", c.string);
    
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDSequence class]]);
    s = @"ab";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = (TDCharacterAssembly *)[p bestMatchFor:a];
    TDEqualObjects(@"[a, b]ab^", [res description]);
}


- (void)testAbc {
    s = @"abc";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Sequence]abc^", [res description]);
    TDSequence *seq = [res pop];
    TDTrue([seq isMemberOfClass:[TDSequence class]]);
    TDEquals((NSUInteger)3, seq.subparsers.count);
    
    TDSpecificChar *c = [seq.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"a", c.string);
    c = [seq.subparsers objectAtIndex:1];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"b", c.string);
    c = [seq.subparsers objectAtIndex:2];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"c", c.string);
    
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDSequence class]]);
    s = @"abc";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = (TDCharacterAssembly *)[p bestMatchFor:a];
    TDEqualObjects(@"[a, b, c]abc^", [res description]);
}


- (void)testAOrB {
    s = @"a|b";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Alternation]a|b^", [res description]);
    TDAlternation *alt = [res pop];
    TDTrue([alt isMemberOfClass:[TDAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDSpecificChar *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"a", c.string);
    c = [alt.subparsers objectAtIndex:1];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"b", c.string);
    
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDAlternation class]]);
    s = @"b";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = (TDCharacterAssembly *)[p bestMatchFor:a];
    TDEqualObjects(@"[b]b^", [res description]);
}


- (void)test4Or7 {
    s = @"4|7";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Alternation]4|7^", [res description]);
    TDAlternation *alt = [res pop];
    TDTrue([alt isMemberOfClass:[TDAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDSpecificChar *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"4", c.string);
    c = [alt.subparsers objectAtIndex:1];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"7", c.string);
    
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDAlternation class]]);
    s = @"4";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = (TDCharacterAssembly *)[p bestMatchFor:a];
    TDEqualObjects(@"[4]4^", [res description]);
}


- (void)testAOrBStar {
    s = @"a|b*";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Alternation]a|b*^", [res description]);
    TDAlternation *alt = [res pop];
    TDTrue([alt isMemberOfClass:[TDAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDSpecificChar *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"a", c.string);
    
    TDRepetition *rep = [alt.subparsers objectAtIndex:1];
    TDEqualObjects([TDRepetition class], [rep class]);
    c = (TDSpecificChar *)rep.subparser;
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"b", c.string);
    
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDAlternation class]]);
    s = @"bbb";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = (TDCharacterAssembly *)[p bestMatchFor:a];
    TDEqualObjects(@"[b, b, b]bbb^", [res description]);
}


- (void)testAOrBPlus {
    s = @"a|b+";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Alternation]a|b+^", [res description]);
    TDAlternation *alt = [res pop];
    TDTrue([alt isMemberOfClass:[TDAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDSpecificChar *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"a", c.string);
    
    TDSequence *seq = [alt.subparsers objectAtIndex:1];
    TDEqualObjects([TDSequence class], [seq class]);
    
    c = [seq.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"b", c.string);
    
    TDRepetition *rep = [seq.subparsers objectAtIndex:1];
    TDEqualObjects([TDRepetition class], [rep class]);
    c = (TDSpecificChar *)rep.subparser;
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"b", c.string);
    
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDAlternation class]]);
    s = @"bbb";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = (TDCharacterAssembly *)[p bestMatchFor:a];
    TDEqualObjects(@"[b, b, b]bbb^", [res description]);
    
    s = @"abbb";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = (TDCharacterAssembly *)[p bestMatchFor:a];
    TDEqualObjects(@"[a]a^bbb", [res description]);
}


- (void)testAOrBQuestion {
    s = @"a|b?";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Alternation]a|b?^", [res description]);
    TDAlternation *alt = [res pop];
    TDTrue([alt isMemberOfClass:[TDAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDSpecificChar *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"a", c.string);
    
    alt = [alt.subparsers objectAtIndex:1];
    TDEqualObjects([TDAlternation class], [alt class]);
    
    TDEmpty *e = [alt.subparsers objectAtIndex:0];
    TDTrue([e isMemberOfClass:[TDEmpty class]]);
    
    c = (TDSpecificChar *)[alt.subparsers objectAtIndex:1];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"b", c.string);
    
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDAlternation class]]);
    s = @"bbb";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = (TDCharacterAssembly *)[p bestMatchFor:a];
    TDEqualObjects(@"[b]b^bb", [res description]);
    
    s = @"abbb";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = (TDCharacterAssembly *)[p bestMatchFor:a];
    TDEqualObjects(@"[a]a^bbb", [res description]);
}


- (void)testParenAOrBParenStar {
    s = @"(a|b)*";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Repetition](a|b)*^", [res description]);
    TDRepetition *rep = [res pop];
    TDTrue([rep isMemberOfClass:[TDRepetition class]]);
    
    TDAlternation *alt = (TDAlternation *)rep.subparser;
    TDTrue([alt isMemberOfClass:[TDAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDSpecificChar *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"a", c.string);
    
    c = [alt.subparsers objectAtIndex:1];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"b", c.string);
    
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDRepetition class]]);
    s = @"bbbaaa";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = (TDCharacterAssembly *)[p bestMatchFor:a];
    TDEqualObjects(@"[b, b, b, a, a, a]bbbaaa^", [res description]);
}


- (void)testParenAOrBParenPlus {
    s = @"(a|b)+";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Sequence](a|b)+^", [res description]);
    TDSequence *seq = [res pop];
    TDTrue([seq isMemberOfClass:[TDSequence class]]);
    
    TDEquals((NSUInteger)2, seq.subparsers.count);
    
    TDAlternation *alt = [seq.subparsers objectAtIndex:0];
    TDTrue([alt isMemberOfClass:[TDAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDSpecificChar *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"a", c.string);
    
    c = [alt.subparsers objectAtIndex:1];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"b", c.string);
    
    TDRepetition *rep = [seq.subparsers objectAtIndex:1];
    TDTrue([rep isMemberOfClass:[TDRepetition class]]);
    
    alt = (TDAlternation *)rep.subparser;
    TDEqualObjects([TDAlternation class], [alt class]);
    
    c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"a", c.string);
    
    c = [alt.subparsers objectAtIndex:1];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"b", c.string);
    
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDSequence class]]);
    s = @"bbbaaa";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = (TDCharacterAssembly *)[p bestMatchFor:a];
    TDEqualObjects(@"[b, b, b, a, a, a]bbbaaa^", [res description]);
}


- (void)testParenAOrBParenQuestion {
    s = @"(a|b)?";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = [p bestMatchFor:a];
    TDNotNil(res);
    TDEqualObjects(@"[Alternation](a|b)?^", [res description]);
    TDAlternation *alt = [res pop];
    TDTrue([alt isMemberOfClass:[TDAlternation class]]);
    
    TDEquals((NSUInteger)2, alt.subparsers.count);
    TDEmpty *e = [alt.subparsers objectAtIndex:0];
    TDTrue([TDEmpty class] == [e class]);
    
    alt = [alt.subparsers objectAtIndex:1];
    TDTrue([alt isMemberOfClass:[TDAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDSpecificChar *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"a", c.string);
    
    c = [alt.subparsers objectAtIndex:1];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"b", c.string);
    
    // use the result parser
    p = [TDGrammarParser parserForLanguage:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[TDAlternation class]]);
    s = @"bbbaaa";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = (TDCharacterAssembly *)[p bestMatchFor:a];
    TDEqualObjects(@"[b]b^bbaaa", [res description]);
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
