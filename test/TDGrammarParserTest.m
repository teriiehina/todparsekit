//
//  TDGrammarParserTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/12/08.
//  Copyright 2008 Todd Ditchendorf All rights reserved.
//

#import "TDGrammarParserTest.h"

@implementation TDGrammarParserTest

- (void)setUp {
    p = [[TDGrammarParser alloc] init];
}


- (void)tearDown {
    [p release];
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


- (void)test2 {
    s = @"foo bar baz;";
    res = [p parse:s];
    TDNotNil(res);
    s = @"foo bar baz;";
    a = [p completeMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[Sequence]foo/bar/baz/;^", [a description]);
}


// phrase            = atomicValue | '(' expression ')'
- (void)testPhraseFoo {
    s = @"foo";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [[p.phraseParser completeMatchFor:a] pop];
    TDNotNil(res);
    TDEqualObjects([res class], [TDLiteral class]);
    TDLiteral *l = (TDLiteral *)res;
    TDEqualObjects(l.string, @"foo");
}


- (void)testPhraseParenFooParen {
    s = @"(foo)";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [[p.phraseParser completeMatchFor:a] pop];
    TDNotNil(res);
    TDEqualObjects([res class], [TDLiteral class]);
    TDLiteral *l = (TDLiteral *)res;
    TDEqualObjects(l.string, @"foo");
}


- (void)testPhraseParen47Dot8Paren {
    s = @"(47.8)";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [[p.phraseParser completeMatchFor:a] pop];
    TDNotNil(res);
    TDEqualObjects([res class], [TDLiteral class]);
    TDLiteral *l = (TDLiteral *)res;
    TDEqualObjects(l.string, @"47.8");
}


- (void)testTermFooBar {
    s = @"foo bar";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [[p.termParser bestMatchFor:a] pop];
    
    // Seq(foo, bar)
    TDNotNil(res);
    TDEqualObjects([res class], [TDSequence class]);
    TDSequence *seq = (TDSequence *)res;
    TDEquals((NSUInteger)2, seq.subparsers.count);
    
    TDLiteral *l1 = [seq.subparsers objectAtIndex:0];
    TDEqualObjects([l1 class], [TDLiteral class]);
    TDEqualObjects(l1.string, @"foo");
    
    TDLiteral *l2 = [seq.subparsers objectAtIndex:1];
    TDEqualObjects([l2 class], [TDLiteral class]);
    TDEqualObjects(l2.string, @"bar");
}


- (void)testTermFooBarBaz {
    s = @"foo bar baz";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [[p.termParser bestMatchFor:a] pop];
    
    // Seq(Seq(foo, bar), baz)
    // Seq(foo, bar, baz)
    TDNotNil(res);
    TDEqualObjects([res class], [TDSequence class]);
    TDSequence *seq = (TDSequence *)res;
    TDEquals((NSUInteger)3, seq.subparsers.count);
    
//    TDSequence *s1 = [seq.subparsers objectAtIndex:0];
//    TDEqualObjects([s1 class], [TDSequence class]);
//
    TDLiteral *l1 = [seq.subparsers objectAtIndex:0];
    TDEqualObjects([l1 class], [TDLiteral class]);
    TDEqualObjects(l1.string, @"foo");
//    
//    TDLiteral *l2 = [s1.subparsers objectAtIndex:1];
//    TDEqualObjects([l2 class], [TDLiteral class]);
//    TDEqualObjects(l2.string, @"bar");
//
//    TDLiteral *l3 = [seq.subparsers objectAtIndex:1];
//    TDEqualObjects([l3 class], [TDLiteral class]);
//    TDEqualObjects(l3.string, @"baz");
}


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
