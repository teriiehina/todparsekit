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
