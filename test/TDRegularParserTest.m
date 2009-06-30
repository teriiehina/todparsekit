//
//  PKRegularParserTest.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDRegularParserTest.h"

@implementation TDRegularParserTest

- (void)setUp {
    p = [TDRegularParser parser];
}


- (void)testAabPlus {
    s = @"aab+";
    // use the result parser
    p = [TDRegularParser parserFromGrammar:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[PKSequence class]]);
    s = @"aabbbb";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = (TDCharacterAssembly *)[p bestMatchFor:a];
    TDEqualObjects(@"[a, a, b, b, b, b]aabbbb^", [res description]);
}


- (void)testAabStar {
    s = @"aab*";
    // use the result parser
    p = [TDRegularParser parserFromGrammar:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[PKSequence class]]);
    s = @"aabbbb";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = (TDCharacterAssembly *)[p bestMatchFor:a];
    TDEqualObjects(@"[a, a, b, b, b, b]aabbbb^", [res description]);
}


- (void)testAabQuestion {
    s = @"aab?";
    // use the result parser
    p = [TDRegularParser parserFromGrammar:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[PKSequence class]]);
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
    PKSequence *seq = [res pop];
    TDTrue([seq isMemberOfClass:[PKSequence class]]);
    TDEquals((NSUInteger)2, seq.subparsers.count);
    
    TDSpecificChar *c = [seq.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"a", c.string);
    c = [seq.subparsers objectAtIndex:1];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"b", c.string);

    // use the result parser
    p = [TDRegularParser parserFromGrammar:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[PKSequence class]]);
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
    PKSequence *seq = [res pop];
    TDTrue([seq isMemberOfClass:[PKSequence class]]);
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
    p = [TDRegularParser parserFromGrammar:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[PKSequence class]]);
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
    PKAlternation *alt = [res pop];
    TDTrue([alt isMemberOfClass:[PKAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDSpecificChar *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"a", c.string);
    c = [alt.subparsers objectAtIndex:1];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"b", c.string);

    // use the result parser
    p = [TDRegularParser parserFromGrammar:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[PKAlternation class]]);
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
    PKAlternation *alt = [res pop];
    TDTrue([alt isMemberOfClass:[PKAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDSpecificChar *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"4", c.string);
    c = [alt.subparsers objectAtIndex:1];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"7", c.string);
    
    // use the result parser
    p = [TDRegularParser parserFromGrammar:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[PKAlternation class]]);
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
    PKAlternation *alt = [res pop];
    TDTrue([alt isMemberOfClass:[PKAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDSpecificChar *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"a", c.string);
    
    PKRepetition *rep = [alt.subparsers objectAtIndex:1];
    TDEqualObjects([PKRepetition class], [rep class]);
    c = (TDSpecificChar *)rep.subparser;
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"b", c.string);
    
    // use the result parser
    p = [TDRegularParser parserFromGrammar:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[PKAlternation class]]);
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
    PKAlternation *alt = [res pop];
    TDTrue([alt isMemberOfClass:[PKAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDSpecificChar *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"a", c.string);
    
    PKSequence *seq = [alt.subparsers objectAtIndex:1];
    TDEqualObjects([PKSequence class], [seq class]);
    
    c = [seq.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"b", c.string);
    
    PKRepetition *rep = [seq.subparsers objectAtIndex:1];
    TDEqualObjects([PKRepetition class], [rep class]);
    c = (TDSpecificChar *)rep.subparser;
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"b", c.string);
    
    // use the result parser
    p = [TDRegularParser parserFromGrammar:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[PKAlternation class]]);
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
    PKAlternation *alt = [res pop];
    TDTrue([alt isMemberOfClass:[PKAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDSpecificChar *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"a", c.string);
    
    alt = [alt.subparsers objectAtIndex:1];
    TDEqualObjects([PKAlternation class], [alt class]);
    
    PKEmpty *e = [alt.subparsers objectAtIndex:0];
    TDTrue([e isMemberOfClass:[PKEmpty class]]);
    
    c = (TDSpecificChar *)[alt.subparsers objectAtIndex:1];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"b", c.string);
    
    // use the result parser
    p = [TDRegularParser parserFromGrammar:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[PKAlternation class]]);
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
    PKRepetition *rep = [res pop];
    TDTrue([rep isMemberOfClass:[PKRepetition class]]);
    
    PKAlternation *alt = (PKAlternation *)rep.subparser;
    TDTrue([alt isMemberOfClass:[PKAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDSpecificChar *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"a", c.string);
    
    c = [alt.subparsers objectAtIndex:1];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"b", c.string);

    // use the result parser
    p = [TDRegularParser parserFromGrammar:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[PKRepetition class]]);
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
    PKSequence *seq = [res pop];
    TDTrue([seq isMemberOfClass:[PKSequence class]]);

    TDEquals((NSUInteger)2, seq.subparsers.count);

    PKAlternation *alt = [seq.subparsers objectAtIndex:0];
    TDTrue([alt isMemberOfClass:[PKAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDSpecificChar *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"a", c.string);
    
    c = [alt.subparsers objectAtIndex:1];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"b", c.string);

    PKRepetition *rep = [seq.subparsers objectAtIndex:1];
    TDTrue([rep isMemberOfClass:[PKRepetition class]]);
    
    alt = (PKAlternation *)rep.subparser;
    TDEqualObjects([PKAlternation class], [alt class]);

    c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"a", c.string);
    
    c = [alt.subparsers objectAtIndex:1];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"b", c.string);

    // use the result parser
    p = [TDRegularParser parserFromGrammar:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[PKSequence class]]);
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
    PKAlternation *alt = [res pop];
    TDTrue([alt isMemberOfClass:[PKAlternation class]]);
    
    TDEquals((NSUInteger)2, alt.subparsers.count);
    PKEmpty *e = [alt.subparsers objectAtIndex:0];
    TDTrue([PKEmpty class] == [e class]);
    
    alt = [alt.subparsers objectAtIndex:1];
    TDTrue([alt isMemberOfClass:[PKAlternation class]]);
    TDEquals((NSUInteger)2, alt.subparsers.count);
    
    TDSpecificChar *c = [alt.subparsers objectAtIndex:0];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"a", c.string);
    
    c = [alt.subparsers objectAtIndex:1];
    TDTrue([c isMemberOfClass:[TDSpecificChar class]]);
    TDEqualObjects(@"b", c.string);
    
    // use the result parser
    p = [TDRegularParser parserFromGrammar:s];
    TDNotNil(p);
    TDTrue([p isKindOfClass:[PKAlternation class]]);
    s = @"bbbaaa";
    a = [TDCharacterAssembly assemblyWithString:s];
    res = (TDCharacterAssembly *)[p bestMatchFor:a];
    TDEqualObjects(@"[b]b^bbaaa", [res description]);
}

@end
