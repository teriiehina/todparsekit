//
//  TDNSPredicateEvaluatorTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDNSPredicateEvaluatorTest.h"

@implementation TDNSPredicateEvaluatorTest

- (id)resolvedValueForKeyPath:(NSString *)kp {
    id result = [d objectForKey:kp];
    if (!result) {
        result = [NSNumber numberWithBool:NO];
    }
    return result;
}


- (void)setUp {
    d = [NSMutableDictionary dictionary];
    eval = [[[TDNSPredicateEvaluator alloc] initWithKeyPathResolver:self] autorelease];
}


- (void)testKeyPath {
    [d setObject:[NSNumber numberWithBool:YES] forKey:@"foo"];
    [d setObject:[NSNumber numberWithBool:NO] forKey:@"baz"];
    
    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [[eval.parser parserNamed:@"keyPath"] completeMatchFor:a];
    TDEqualObjects(@"[1]foo^", [res description]);

    s = @"bar";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [[eval.parser parserNamed:@"keyPath"] completeMatchFor:a];
    TDEqualObjects(@"[0]bar^", [res description]);

    s = @"baz";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [[eval.parser parserNamed:@"keyPath"] completeMatchFor:a];
    TDEqualObjects(@"[0]baz^", [res description]);
}    


- (void)testNegatedPredicate {
    s = @"not 0 < 2";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [eval.parser completeMatchFor:a];
    TDEqualObjects(@"[0]not/0/</2^", [res description]);

    s = @"! 0 < 2";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [eval.parser completeMatchFor:a];
    TDEqualObjects(@"[0]!/0/</2^", [res description]);
}


- (void)testStringTest {
    s = @"'foo' BEGINSWITH 'f'";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [eval.parser completeMatchFor:a];
    TDEqualObjects(@"[1]'foo'/BEGINSWITH/'f'^", [res description]);

    s = @"'foo' BEGINSWITH 'o'";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [eval.parser completeMatchFor:a];
    TDEqualObjects(@"[0]'foo'/BEGINSWITH/'o'^", [res description]);

    s = @"'foo' ENDSWITH 'f'";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [eval.parser completeMatchFor:a];
    TDEqualObjects(@"[0]'foo'/ENDSWITH/'f'^", [res description]);
    
    s = @"'foo' ENDSWITH 'o'";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [eval.parser completeMatchFor:a];
    TDEqualObjects(@"[1]'foo'/ENDSWITH/'o'^", [res description]);

    s = @"'foo' CONTAINS 'fo'";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [eval.parser completeMatchFor:a];
    TDEqualObjects(@"[1]'foo'/CONTAINS/'fo'^", [res description]);
    
    s = @"'foo' CONTAINS '-'";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [eval.parser completeMatchFor:a];
    TDEqualObjects(@"[0]'foo'/CONTAINS/'-'^", [res description]);
}

    
- (void)testComparison {
    s = @"1 < 2";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [eval.parser completeMatchFor:a];
    TDEqualObjects(@"[1]1/</2^", [res description]);

    s = @"1 > 2";
    a = [TDTokenAssembly assemblyWithString:s];    
    res = [eval.parser completeMatchFor:a];
    TDEqualObjects(@"[0]1/>/2^", [res description]);
    
    s = @"1 != 2";
    a = [TDTokenAssembly assemblyWithString:s];    
    res = [eval.parser completeMatchFor:a];
    TDEqualObjects(@"[1]1/!=/2^", [res description]);
    
    s = @"1 == 2";
    a = [TDTokenAssembly assemblyWithString:s];    
    res = [eval.parser completeMatchFor:a];
    TDEqualObjects(@"[0]1/==/2^", [res description]);

    s = @"1 = 2";
    a = [TDTokenAssembly assemblyWithString:s];    
    res = [eval.parser completeMatchFor:a];
    TDEqualObjects(@"[0]1/=/2^", [res description]);
}


- (void)testArray {
    s = @"{1, 3}";
    a = [TDTokenAssembly assemblyWithString:s];
    
    res = [[eval.parser parserNamed:@"array"] completeMatchFor:a];
    NSArray *array = [res pop];
    TDEquals((NSUInteger)2, array.count);
    TDEqualObjects([array objectAtIndex:0], [NSNumber numberWithInteger:1]);
    TDEqualObjects([array objectAtIndex:1], [NSNumber numberWithInteger:3]);
}


- (void)testTrue {
    s = @"true";
    a = [TDTokenAssembly assemblyWithString:s];
    
    res = [[eval.parser parserNamed:@"bool"] completeMatchFor:a];
    TDEqualObjects(@"[1]true^", [res description]);
}


- (void)testFalse {
    s = @"false";
    a = [TDTokenAssembly assemblyWithString:s];
    
    res = [[eval.parser parserNamed:@"bool"] completeMatchFor:a];
    TDEqualObjects(@"[0]false^", [res description]);
}


- (void)testTruePredicate {
    s = @"TRUEPREDICATE";
    a = [TDTokenAssembly assemblyWithString:s];
    
    res = [eval.parser completeMatchFor:a];
    TDEqualObjects(@"[1]TRUEPREDICATE^", [res description]);
}


- (void)testFalsePredicate {
    s = @"FALSEPREDICATE";
    a = [TDTokenAssembly assemblyWithString:s];
    
    res = [eval.parser completeMatchFor:a];
    TDEqualObjects(@"[0]FALSEPREDICATE^", [res description]);
}


- (void)testCollectionTest {
    s = @"1 IN {1}";
    a = [TDTokenAssembly assemblyWithString:s];
    
    res = [eval.parser completeMatchFor:a];
    TDEqualObjects(@"[1]1/IN/{/1/}^", [res description]);
}    
    

- (void)testOr {
    s = @"TRUEPREDICATE OR FALSEPREDICATE";
    a = [TDTokenAssembly assemblyWithString:s];
    
    res = [eval.parser completeMatchFor:a];
    TDEqualObjects(@"[1]TRUEPREDICATE/OR/FALSEPREDICATE^", [res description]);
}    


- (void)testAnd {
    s = @"TRUEPREDICATE AND FALSEPREDICATE";
    a = [TDTokenAssembly assemblyWithString:s];
    
    res = [eval.parser completeMatchFor:a];
    TDEqualObjects(@"[0]TRUEPREDICATE/AND/FALSEPREDICATE^", [res description]);
}    


- (void)testCompoundExpr {
    s = @"(TRUEPREDICATE)";
    a = [TDTokenAssembly assemblyWithString:s];
    
    res = [eval.parser completeMatchFor:a];
    TDEqualObjects(@"[1](/TRUEPREDICATE/)^", [res description]);
}    

@end
