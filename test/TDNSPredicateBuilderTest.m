//
//  PredicateParserTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/27/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDNSPredicateBuilderTest.h"

@implementation TDNSPredicateBuilderTest

- (void)setUp {
    b = [[[TDNSPredicateBuilder alloc] init] autorelease];
}


- (void)testEq {
    // test numbers
    s = @"foo = 1.0";
    a = [b.exprParser bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo == 1]foo/=/1.0^", [a description]);
    
    s = @"foo = -1.0";
    a = [b.exprParser bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo == -1]foo/=/-1.0^", [a description]);
    
    
    // test bools
    s = @"foo = true";
    a = [b.exprParser bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo == 1]foo/=/true^", [a description]);
    
    s = @"foo = false";
    a = [b.exprParser bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo == 0]foo/=/false^", [a description]);
    
    
    // test strings
    s = @"foo = 'bar'";
    a = [b.exprParser bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo == \"bar\"]foo/=/'bar'^", [a description]);
    
    s = @"foo = 'baz'";
    a = [b.exprParser bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo == \"baz\"]foo/=/'baz'^", [a description]);
}


- (void)testNe {
    // test numbers
    s = @"foo != 1.0";
    a = [b.exprParser bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo != 1]foo/!=/1.0^", [a description]);
    
    s = @"foo != 1.00";
    a = [b.exprParser bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo != 1]foo/!=/1.00^", [a description]);
    
    
    // test bools
    s = @"foo != true";
    a = [b.exprParser bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo != 1]foo/!=/true^", [a description]);
    
    s = @"foo != false";
    a = [b.exprParser bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo != 0]foo/!=/false^", [a description]);
        
    
    // test strings
    s = @"foo != 'bar'";
    a = [b.exprParser bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo != \"bar\"]foo/!=/'bar'^", [a description]);
    
    s = @"foo != 'baz'";
    a = [b.exprParser bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo != \"baz\"]foo/!=/'baz'^", [a description]);
}


- (void)testGt {
    s = @"foo > 42";
    a = [b.exprParser bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo > 42]foo/>/42^", [a description]);
}


- (void)testLt {
    s = @"foo < .3";
    a = [b.exprParser bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo < 0.3]foo/</.3^", [a description]);
}


- (void)testGteq {
    s = @"foo >= 42";
    a = [b.exprParser bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo >= 42]foo/>=/42^", [a description]);
}


- (void)testLteq {
    s = @"foo <= .3";
    a = [b.exprParser bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo <= 0.3]foo/<=/.3^", [a description]);
}


- (void)testBeginswith {
    s = @"foo beginswith 'bar'";
    a = [b.exprParser bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo BEGINSWITH \"bar\"]foo/beginswith/'bar'^", [a description]);
}


- (void)testContains {
    s = @"foo contains 'baz'";
    a = [b.exprParser bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo CONTAINS \"baz\"]foo/contains/'baz'^", [a description]);
}


- (void)testEndswith {
    s = @"foo endswith 'baz'";
    a = [b.exprParser bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo ENDSWITH \"baz\"]foo/endswith/'baz'^", [a description]);
}


- (void)testMatches {
    s = @"foo matches 'baz'";
    a = [b.exprParser bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo MATCHES \"baz\"]foo/matches/'baz'^", [a description]);
}


- (void)testUnqotedString {
    s = @"foo matches bar";
    a = [b.exprParser bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo MATCHES \"bar\"]foo/matches/bar^", [a description]);

    s = @"foo matches bar baz";
    a = [b.exprParser bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo MATCHES \"bar baz\"]foo/matches/bar/baz^", [a description]);

    s = @"foo matches foo bar baz";
    a = [b.exprParser bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo MATCHES \"foo bar baz\"]foo/matches/foo/bar/baz^", [a description]);

    s = @"foo matches bar and baz contains bat";
    a = [b.exprParser bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo MATCHES \"bar\" AND baz CONTAINS \"bat\"]foo/matches/bar/and/baz/contains/bat^", [a description]);

    s = @"foo matches foo bar and baz contains bat";
    a = [b.exprParser bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo MATCHES \"foo bar\" AND baz CONTAINS \"bat\"]foo/matches/foo/bar/and/baz/contains/bat^", [a description]);
}


- (void)testBools {
    s = @"true";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [b.exprParser bestMatchFor:a];
    TDEqualObjects(@"[TRUEPREDICATE]true^", [a description]);
    
    s = @"not true";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [b.exprParser bestMatchFor:a];
    TDEqualObjects(@"[NOT TRUEPREDICATE]not/true^", [a description]);

    s = @"false";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [b.exprParser bestMatchFor:a];
    TDEqualObjects(@"[FALSEPREDICATE]false^", [a description]);
    
    s = @"not false";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [b.exprParser bestMatchFor:a];
    TDEqualObjects(@"[NOT FALSEPREDICATE]not/false^", [a description]);
    
    s = @"true and false";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [b.exprParser bestMatchFor:a];
    TDEqualObjects(@"[TRUEPREDICATE AND FALSEPREDICATE]true/and/false^", [a description]);
    
    s = @"not true and false";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [b.exprParser bestMatchFor:a];
    TDEqualObjects(@"[(NOT TRUEPREDICATE) AND FALSEPREDICATE]not/true/and/false^", [a description]);
    
    s = @"not true and not false";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [b.exprParser bestMatchFor:a];
    TDEqualObjects(@"[(NOT TRUEPREDICATE) AND (NOT FALSEPREDICATE)]not/true/and/not/false^", [a description]);
    
    s = @"true or false";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [b.exprParser bestMatchFor:a];
    TDEqualObjects(@"[TRUEPREDICATE OR FALSEPREDICATE]true/or/false^", [a description]);

    s = @"(true and false) or false";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [b.exprParser bestMatchFor:a];
    TDEqualObjects(@"[(TRUEPREDICATE AND FALSEPREDICATE) OR FALSEPREDICATE](/true/and/false/)/or/false^", [a description]);

    s = @"(true and false) or not false";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [b.exprParser bestMatchFor:a];
    TDEqualObjects(@"[(TRUEPREDICATE AND FALSEPREDICATE) OR (NOT FALSEPREDICATE)](/true/and/false/)/or/not/false^", [a description]);
}

@end
