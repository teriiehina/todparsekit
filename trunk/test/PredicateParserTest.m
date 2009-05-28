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
    s = @"true and false";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [p bestMatchFor:a];
    TDEqualObjects(@"[TRUEPREDICATE, FALSEPREDICATE]true/and/false^", [a description]);
}


@end
