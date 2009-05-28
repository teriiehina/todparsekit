//
//  PredicateParserTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/27/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "PredicateParserTest.h"

@implementation PredicateParserTest

- (void)testFoo {
    PredicateParser *p = [PredicateParser parser];
    NSString *s = @"true and false";
    TDAssembly *a = [TDTokenAssembly assemblyWithString:s];
    a = [p bestMatchFor:a];
    TDEqualObjects(@"[true, false]true/and/false^", [a description]);
}

@end
