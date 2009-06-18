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


- (void)testTruePredicate {
    s = @"TRUEPREDICATE";
    a = [TDTokenAssembly assemblyWithString:s];

    res = [[eval.parser parserNamed:@"boolPredicate"] completeMatchFor:a];
    TDEqualObjects(@"[TRUEPREDICATE]TRUEPREDICATE^", [res description]);

    res = [[eval.parser parserNamed:@"value"] completeMatchFor:a];
    TDEqualObjects(@"[TRUEPREDICATE]TRUEPREDICATE^", [res description]);

    res = [[eval.parser parserNamed:@"actualPredicate"] completeMatchFor:a];
    TDEqualObjects(@"[TRUEPREDICATE]TRUEPREDICATE^", [res description]);
    
    res = [[eval.parser parserNamed:@"predicate"] completeMatchFor:a];
    TDEqualObjects(@"[TRUEPREDICATE]TRUEPREDICATE^", [res description]);
    
    res = [[eval.parser parserNamed:@"primaryExpr"] completeMatchFor:a];
    TDEqualObjects(@"[TRUEPREDICATE]TRUEPREDICATE^", [res description]);
    
    res = [[eval.parser parserNamed:@"andTerm"] completeMatchFor:a];
    TDEqualObjects(@"[TRUEPREDICATE]TRUEPREDICATE^", [res description]);
    
    res = [[eval.parser parserNamed:@"expr"] completeMatchFor:a];
    TDEqualObjects(@"[TRUEPREDICATE]TRUEPREDICATE^", [res description]);

    res = [eval.parser completeMatchFor:a];
    TDEqualObjects(@"[TRUEPREDICATE]TRUEPREDICATE^", [res description]);
}


@end
