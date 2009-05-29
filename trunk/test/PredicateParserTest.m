//
//  PredicateParserTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/27/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "PredicateParserTest.h"

@implementation PredicateParserTest

- (id)valueForAttributeKey:(NSString *)key {
    return [d objectForKey:key];
}


- (CGFloat)floatForAttributeKey:(NSString *)key {
    return [[d objectForKey:key] floatValue];
}


- (BOOL)boolForAttributeKey:(NSString *)key {
    return [[d objectForKey:key] boolValue];
}


- (void)setUp {
    d = [NSMutableDictionary dictionary];
    p = [[[PredicateParser alloc] initWithDelegate:self] autorelease];
}


- (void)testEq {
    [d setValue:[NSNumber numberWithFloat:1.0] forKey:@"foo"];

    s = @"foo = 1.0";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [p bestMatchFor:a];
    TDEqualObjects(@"[TRUEPREDICATE]foo/=/1.0^", [a description]);
}


- (void)testBools {
    s = @"true";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [p bestMatchFor:a];
    TDEqualObjects(@"[TRUEPREDICATE]true^", [a description]);
    
    s = @"not true";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [p bestMatchFor:a];
    TDEqualObjects(@"[NOT TRUEPREDICATE]not/true^", [a description]);

    s = @"false";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [p bestMatchFor:a];
    TDEqualObjects(@"[FALSEPREDICATE]false^", [a description]);
    
    s = @"not false";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [p bestMatchFor:a];
    TDEqualObjects(@"[NOT FALSEPREDICATE]not/false^", [a description]);
    
    s = @"true and false";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [p bestMatchFor:a];
    TDEqualObjects(@"[TRUEPREDICATE AND FALSEPREDICATE]true/and/false^", [a description]);
    
    s = @"not true and false";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [p bestMatchFor:a];
    TDEqualObjects(@"[(NOT TRUEPREDICATE) AND FALSEPREDICATE]not/true/and/false^", [a description]);
    
    s = @"not true and not false";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [p bestMatchFor:a];
    TDEqualObjects(@"[(NOT TRUEPREDICATE) AND (NOT FALSEPREDICATE)]not/true/and/not/false^", [a description]);
    
    s = @"true or false";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [p bestMatchFor:a];
    TDEqualObjects(@"[TRUEPREDICATE OR FALSEPREDICATE]true/or/false^", [a description]);

    s = @"(true and false) or false";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [p bestMatchFor:a];
    TDEqualObjects(@"[(TRUEPREDICATE AND FALSEPREDICATE) OR FALSEPREDICATE](/true/and/false/)/or/false^", [a description]);

    s = @"(true and false) or not false";
    a = [TDTokenAssembly assemblyWithString:s];
    a = [p bestMatchFor:a];
    TDEqualObjects(@"[(TRUEPREDICATE AND FALSEPREDICATE) OR (NOT FALSEPREDICATE)](/true/and/false/)/or/not/false^", [a description]);
}

@end
