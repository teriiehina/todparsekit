//
//  TDMinusTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/26/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDExclusionTest.h"

@implementation TDExclusionTest

- (void)testFoo {
    PKWord *word = [PKWord word];
    TDLiteral *foo = [TDLiteral literalWithString:@"foo"];
    PKExclusion *ex = [PKExclusion exclusion];
    [ex add:word];
    [ex add:foo];
    
    s = @"bar";
    a = [PKTokenAssembly assemblyWithString:s];
    res = [ex bestMatchFor:a];
    TDEqualObjects(@"[bar]bar^", [res description]);
    
    s = @"foo";
    a = [PKTokenAssembly assemblyWithString:s];
    res = [ex bestMatchFor:a];
    NSLog(@"res: %@", res);
    TDNil(res);

    s = @"wee";
    a = [PKTokenAssembly assemblyWithString:s];
    res = [ex bestMatchFor:a];
    TDEqualObjects(@"[wee]wee^", [res description]);
}


- (void)testAlt {
    PKWord *word = [PKWord word];
    PKAlternation *list = [PKAlternation alternation];
    [list add:[TDLiteral literalWithString:@"foo"]];
    [list add:[TDLiteral literalWithString:@"bar"]];
    
    PKExclusion *ex = [PKExclusion exclusion];
    [ex add:word];
    [ex add:list];
    
    s = @"baz";
    a = [PKTokenAssembly assemblyWithString:s];
    res = [ex bestMatchFor:a];
    TDEqualObjects(@"[baz]baz^", [res description]);
    
    s = @"foo";
    a = [PKTokenAssembly assemblyWithString:s];
    res = [ex bestMatchFor:a];
    TDNil(res);

    s = @"wee";
    a = [PKTokenAssembly assemblyWithString:s];
    res = [ex bestMatchFor:a];
    TDEqualObjects(@"[wee]wee^", [res description]);
}


- (void)testAlt2 {
    PKAlternation *ok = [PKAlternation alternation];
    [ok add:[TDLiteral literalWithString:@"foo"]];
    [ok add:[TDLiteral literalWithString:@"baz"]];
    
    PKAlternation *list = [PKAlternation alternation];
    [list add:[TDLiteral literalWithString:@"foo"]];
    [list add:[TDLiteral literalWithString:@"bar"]];
    
    PKExclusion *ex = [PKExclusion exclusion];
    [ex add:ok];
    [ex add:list];
    
    s = @"baz";
    a = [PKTokenAssembly assemblyWithString:s];
    res = [ex bestMatchFor:a];
    TDEqualObjects(@"[baz]baz^", [res description]);
    
    s = @"foo";
    a = [PKTokenAssembly assemblyWithString:s];
    res = [ex bestMatchFor:a];
    TDNil(res);

    s = @"wee";
    a = [PKTokenAssembly assemblyWithString:s];
    res = [ex bestMatchFor:a];
    TDNil(res);
}

@end
