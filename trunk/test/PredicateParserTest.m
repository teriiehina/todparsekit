//
//  PredicateParserTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/27/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "PredicateParserTest.h"

@implementation PredicateParserTest

- (void)setUp {
    p = [PredicateParser parser];
}


- (void)testTrueAndFalse {
    s = @"true";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [p bestMatchFor:a];
    TDEqualObjects(@"[TRUEPREDICATE]true^", [a description]);
    
    s = @"false";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [p bestMatchFor:a];
    TDEqualObjects(@"[FALSEPREDICATE]false^", [a description]);
    
    s = @"true and false";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [p bestMatchFor:a];
    TDEqualObjects(@"[TRUEPREDICATE AND FALSEPREDICATE]true/and/false^", [a description]);

    s = @"true or false";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [p bestMatchFor:a];
    TDEqualObjects(@"[TRUEPREDICATE OR FALSEPREDICATE]true/or/false^", [a description]);

    s = @"(true and false) or false";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [p bestMatchFor:a];
    TDEqualObjects(@"[(TRUEPREDICATE AND FALSEPREDICATE) OR FALSEPREDICATE](/true/and/false/)/or/false^", [a description]);
}

@end
