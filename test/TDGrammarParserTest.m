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


- (void)test1 {
    //NSString *s = @"foo (bar|baz)*;";
    s = @"$baz = bar; ($baz|foo)*;";
    //NSString *s = @"foo;";
    p = [[[TDGrammarParser alloc] init] autorelease];
    
    //    TDAssembly *a = [p bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    //    NSLog(@"a: %@", a);
    //    NSLog(@"a.target: %@", a.target);
    
    res = [p parse:s];
    //    NSLog(@"res: %@", res);
    //    NSLog(@"res: %@", res.string);
    //    NSLog(@"res.subparsers: %@", res.subparsers);
    //    NSLog(@"res.subparsers 0: %@", [[res.subparsers objectAtIndex:0] string]);
    //    NSLog(@"res.subparsers 1: %@", [[res.subparsers objectAtIndex:1] string]);
    
    s = @"bar foo bar foo";
    a = [res completeMatchFor:[TDTokenAssembly assemblyWithString:s]];
    NSLog(@"\n\na: %@\n\n", a);
}


- (void)test2 {
    //NSString *s = @"foo (bar|baz)*;";
    s = @"foo bar;";
    
    a = [p completeMatchFor:[TDTokenAssembly assemblyWithString:s]];
    NSLog(@"a: %@", a);
    
    //TDParser *res = [p parse:s];
    res = [a pop];
    TDAssertNotNil(res);
    TDAssertNotNil(res);

    NSLog(@"res: %@", res);
    //NSLog(@"res.subparsers: %@", res.subparsers);
//    NSLog(@"res.subparsers 0: %@", [[res.subparsers objectAtIndex:0] string]);
//    NSLog(@"res.subparsers 1: %@", [[res.subparsers objectAtIndex:1] string]);
    
    s = @"foo bar";
    a = [res bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    NSLog(@"\n\na: %@\n\n", a);
    STAssertNotNil(a, @"");
    STAssertEqualObjects(@"[foo, bar]foo/bar^", [a description], @"");
}


// phrase            = atomicValue | '(' expression ')'
- (void)testPhraseFoo {
    s = @"foo";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [[p.phraseParser completeMatchFor:a] pop];
    TDAssertNotNil(res);
    TDAssertEqualObjects([res class], [TDLiteral class]);
    TDLiteral *l = (TDLiteral *)res;
    TDAssertEqualObjects(l.string, @"foo");
}


- (void)testPhraseParenFooParen {
    s = @"(foo)";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [[p.phraseParser completeMatchFor:a] pop];
    TDAssertNotNil(res);
    TDAssertEqualObjects([res class], [TDLiteral class]);
    TDLiteral *l = (TDLiteral *)res;
    TDAssertEqualObjects(l.string, @"foo");
}


- (void)testPhraseParen47Dot8Paren {
    s = @"(47.8)";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [[p.phraseParser completeMatchFor:a] pop];
    TDAssertNotNil(res);
    TDAssertEqualObjects([res class], [TDLiteral class]);
    TDLiteral *n = (TDLiteral *)res;
    TDAssertEqualObjects(n.string, @"47.8");
}


- (void)testTermFooBar {
    s = @"foo bar";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [[p.termParser bestMatchFor:a] pop];
    
    // Seq(foo, bar)
    TDAssertNotNil(res);
    TDAssertEqualObjects([res class], [TDSequence class]);
    TDSequence *seq = (TDSequence *)res;
    TDAssertEquals((NSUInteger)2, seq.subparsers.count);
    
    TDLiteral *l1 = [seq.subparsers objectAtIndex:0];
    TDAssertEqualObjects([l1 class], [TDLiteral class]);
    TDAssertEqualObjects(l1.string, @"foo");
    
    TDLiteral *l2 = [seq.subparsers objectAtIndex:1];
    TDAssertEqualObjects([l2 class], [TDLiteral class]);
    TDAssertEqualObjects(l2.string, @"bar");
}


- (void)testTermFooBarBaz {
    s = @"foo bar baz";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [[p.termParser bestMatchFor:a] pop];
    
    // Seq(Seq(foo, bar), baz)
    TDAssertNotNil(res);
    TDAssertEqualObjects([res class], [TDSequence class]);
    TDSequence *seq = (TDSequence *)res;
    TDAssertEquals((NSUInteger)2, seq.subparsers.count);
    
    TDSequence *s1 = [seq.subparsers objectAtIndex:0];
    TDAssertEqualObjects([s1 class], [TDSequence class]);

    TDLiteral *l1 = [s1.subparsers objectAtIndex:0];
    TDAssertEqualObjects([l1 class], [TDLiteral class]);
    TDAssertEqualObjects(l1.string, @"foo");
    
    TDLiteral *l2 = [s1.subparsers objectAtIndex:1];
    TDAssertEqualObjects([l2 class], [TDLiteral class]);
    TDAssertEqualObjects(l2.string, @"bar");

    TDLiteral *l3 = [seq.subparsers objectAtIndex:1];
    TDAssertEqualObjects([l3 class], [TDLiteral class]);
    TDAssertEqualObjects(l3.string, @"baz");
}


- (void)testExpressionFooOrBar {
    s = @"foo|bar";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [[p.expressionParser bestMatchFor:a] pop];
    
    // Alt(foo, bar)
    TDAssertNotNil(res);
    TDAssertEqualObjects([res class], [TDAlternation class]);
    TDAlternation *alt = (TDAlternation *)res;
    TDAssertEquals((NSUInteger)2, alt.subparsers.count);

    TDLiteral *l1 = [alt.subparsers objectAtIndex:0];
    TDAssertEqualObjects([l1 class], [TDLiteral class]);
    TDAssertEqualObjects(l1.string, @"foo");

    TDLiteral *l2 = [alt.subparsers objectAtIndex:1];
    TDAssertEqualObjects([l2 class], [TDLiteral class]);
    TDAssertEqualObjects(l2.string, @"bar");
}

@end
