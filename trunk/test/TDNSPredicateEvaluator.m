//
//  TDNSPredicateEvaluator.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDNSPredicateEvaluator.h"
#import "TDParserFactory.h"
#import <TDParseKit/TDParseKit.h>

@interface TDNSPredicateEvaluator ()
@property (nonatomic, assign) id <TDKeyPathResolver>resolver;
@end

@implementation TDNSPredicateEvaluator

- (id)initWithKeyPathResolver:(id <TDKeyPathResolver>)r {
    if (self = [super init]) {
        self.resolver = r;
        
        NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"nspredicate" ofType:@"grammar"];
        NSString *s = [NSString stringWithContentsOfFile:path];
        self.parser = [[TDParserFactory factory] parserFromGrammar:s assembler:self];
    }
    return self;
}


- (void)dealloc {
    resolver = nil;
    self.parser = nil;
    [super dealloc];
}


- (BOOL)evaluate:(NSString *)s {
    id result = [parser parse:s];
    return [result boolValue];
}


- (void)workOnComparisonPredicateAssembly:(TDAssembly *)a {
    CGFloat n2 = [[a pop] floatValue];
    NSString *op = [[a pop] stringValue];
    CGFloat n1 = [[a pop] floatValue];
    
    BOOL result = NO;
    if ([op isEqualToString:@"<"]) {
        result = n1 < n2;
    } else if ([op isEqualToString:@">"]) {
        result = n1 > n2;
    } else if ([op isEqualToString:@"="] || [op isEqualToString:@"=="]) {
        result = n1 == n2;
    } else if ([op isEqualToString:@"<="] || [op isEqualToString:@"=<"]) {
        result = n1 <= n2;
    } else if ([op isEqualToString:@">="] || [op isEqualToString:@"=>"]) {
        result = n1 >= n2;
    } else if ([op isEqualToString:@"!="] || [op isEqualToString:@"<>"]) {
        result = n1 != n2;
    }
    
    [a push:[NSNumber numberWithBool:result]];
}


- (void)workOnNumAssembly:(TDAssembly *)a {
    [a push:[NSNumber numberWithFloat:[[a pop] floatValue]]];
}


- (void)workOnTrueAssembly:(TDAssembly *)a {
    [a pop];
    [a push:[NSNumber numberWithBool:YES]];
}


- (void)workOnFalseAssembly:(TDAssembly *)a {
    [a pop];
    [a push:[NSNumber numberWithBool:NO]];
}


- (void)workOnTruePredicateAssembly:(TDAssembly *)a {
    [a pop];
    [a push:[NSNumber numberWithBool:YES]];
}


- (void)workOnFalsePredicateAssembly:(TDAssembly *)a {
    [a pop];
    [a push:[NSNumber numberWithBool:NO]];
}

@synthesize resolver;
@synthesize parser;
@end
