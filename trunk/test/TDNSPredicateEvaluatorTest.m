//
//  TDNSPredicateEvaluatorTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDNSPredicateEvaluatorTest.h"

@implementation TDNSPredicateEvaluatorTest

- (id)resolveValueForKeyPath:(NSString *)kp {
    return [d objectForKey:kp];
}


- (CGFloat)resolveFloatForKeyPath:(NSString *)kp {
    return [[d objectForKey:kp] floatValue];
}


- (BOOL)resolveBoolForKeyPath:(NSString *)kp {
    return [[d objectForKey:kp] boolValue];
}


- (void)setUp {
    d = [NSMutableDictionary dictionary];
    eval = [[[TDNSPredicateEvaluator alloc] initWithKeyPathResolver:self] autorelease];
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
//
//    res = [[eval.parser parserNamed:@"value"] completeMatchFor:a];
//    TDEqualObjects(@"[0]false^", [res description]);
}


- (void)testTruePredicate {
    s = @"TRUEPREDICATE";
    a = [TDTokenAssembly assemblyWithString:s];
    
    res = [[eval.parser parserNamed:@"boolPredicate"] completeMatchFor:a];
    TDEqualObjects(@"[1]TRUEPREDICATE^", [res description]);
    
    res = [[eval.parser parserNamed:@"actualPredicate"] completeMatchFor:a];
    TDEqualObjects(@"[1]TRUEPREDICATE^", [res description]);
    
    res = [[eval.parser parserNamed:@"predicate"] completeMatchFor:a];
    TDEqualObjects(@"[1]TRUEPREDICATE^", [res description]);
    
    res = [[eval.parser parserNamed:@"primaryExpr"] completeMatchFor:a];
    TDEqualObjects(@"[1]TRUEPREDICATE^", [res description]);
    
    res = [[eval.parser parserNamed:@"andTerm"] completeMatchFor:a];
    TDEqualObjects(@"[1]TRUEPREDICATE^", [res description]);
    
    res = [[eval.parser parserNamed:@"expr"] completeMatchFor:a];
    TDEqualObjects(@"[1]TRUEPREDICATE^", [res description]);
    
    res = [eval.parser completeMatchFor:a];
    TDEqualObjects(@"[1]TRUEPREDICATE^", [res description]);
}


- (void)testFalsePredicate {
    s = @"FALSEPREDICATE";
    a = [TDTokenAssembly assemblyWithString:s];
    
    res = [[eval.parser parserNamed:@"boolPredicate"] completeMatchFor:a];
    TDEqualObjects(@"[0]FALSEPREDICATE^", [res description]);
    
    res = [[eval.parser parserNamed:@"actualPredicate"] completeMatchFor:a];
    TDEqualObjects(@"[0]FALSEPREDICATE^", [res description]);
    
    res = [[eval.parser parserNamed:@"predicate"] completeMatchFor:a];
    TDEqualObjects(@"[0]FALSEPREDICATE^", [res description]);
    
    res = [[eval.parser parserNamed:@"primaryExpr"] completeMatchFor:a];
    TDEqualObjects(@"[0]FALSEPREDICATE^", [res description]);
    
    res = [[eval.parser parserNamed:@"andTerm"] completeMatchFor:a];
    TDEqualObjects(@"[0]FALSEPREDICATE^", [res description]);
    
    res = [[eval.parser parserNamed:@"expr"] completeMatchFor:a];
    TDEqualObjects(@"[0]FALSEPREDICATE^", [res description]);
    
    res = [eval.parser completeMatchFor:a];
    TDEqualObjects(@"[0]FALSEPREDICATE^", [res description]);
}


@end
