//
//  TDNSPredicateEvaluator.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDNSPredicateEvaluator.h"
#import "TDParserFactory.h"
#import "NSString+TDParseKitAdditions.h"
#import "NSArray+TDParseKitAdditions.h"

@interface TDNSPredicateEvaluator ()
- (void)workOnCollectionPredicateAssembly:(PKAssembly *)a ordered:(NSComparisonResult)ordered;

@property (nonatomic, assign) id <TDKeyPathResolver>resolver;
@property (nonatomic, retain) PKToken *openCurly;
@end

@implementation TDNSPredicateEvaluator

- (id)initWithKeyPathResolver:(id <TDKeyPathResolver>)r {
    if (self = [super init]) {
        self.resolver = r;

        self.openCurly = [PKToken tokenWithTokenType:TDTokenTypeSymbol stringValue:@"{" floatValue:0];

        NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"nspredicate" ofType:@"grammar"];
        NSString *s = [NSString stringWithContentsOfFile:path];
        self.parser = [[TDParserFactory factory] parserFromGrammar:s assembler:self];
    }
    return self;
}


- (void)dealloc {
    resolver = nil;
    self.parser = nil;
    self.openCurly = nil;
    [super dealloc];
}


- (BOOL)evaluate:(NSString *)s {
    id result = [parser parse:s];
    return [result boolValue];
}


- (void)workOnNegatedPredicate:(PKAssembly *)a {
    BOOL b = [[a pop] boolValue];
    [a push:[NSNumber numberWithBool:!b]];
}


- (void)workOnNumComparisonPredicate:(PKAssembly *)a {
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


- (void)workOnCollectionLtPredicate:(PKAssembly *)a {
    [self workOnCollectionPredicateAssembly:a ordered:NSOrderedAscending];
}


- (void)workOnCollectionGtPredicate:(PKAssembly *)a {
    [self workOnCollectionPredicateAssembly:a ordered:NSOrderedDescending];
}


- (void)workOnCollectionEqPredicate:(PKAssembly *)a {
    [self workOnCollectionPredicateAssembly:a ordered:NSOrderedSame];
}


- (void)workOnCollectionPredicateAssembly:(PKAssembly *)a ordered:(NSComparisonResult)ordered {
    id value = [a pop];
    [a pop]; // discard op
    NSArray *array = [a pop];
    NSString *aggOp = [[a pop] stringValue];
    
    BOOL isAny = NSOrderedSame == [aggOp caseInsensitiveCompare:@"ANY"];
    BOOL isSome = NSOrderedSame == [aggOp caseInsensitiveCompare:@"SOME"];
    BOOL isNone = NSOrderedSame == [aggOp caseInsensitiveCompare:@"NONE"];
    BOOL isAll = NSOrderedSame == [aggOp caseInsensitiveCompare:@"ALL"];
    
    BOOL result = NO;
    if (isAny || isSome || isNone) {
        for (id obj in array) {
            if (ordered == [obj compare:value]) {
                result = YES;
                break;
            }
        }
    } else if (isAll) {
        NSInteger c = 0;
        for (id obj in array) {
            if (ordered != [obj compare:value]) {
                break;
            }
            c++;
        }
        result = c == array.count;
    }
    
    if (isNone) {
        result = !result;
    }
    
    [a push:[NSNumber numberWithBool:result]];
}


- (void)workOnString:(PKAssembly *)a {
    NSString *s = [[[a pop] stringValue] stringByTrimmingQuotes];
    [a push:s];
}


- (void)workOnStringTestPredicate:(PKAssembly *)a {
    NSString *s2 = [a pop];
    NSString *op = [[a pop] stringValue];
    NSString *s1 = [a pop];
    
    BOOL result = NO;
    if (NSOrderedSame == [op caseInsensitiveCompare:@"BEGINSWITH"]) {
        result = [s1 hasPrefix:s2];
    } else if (NSOrderedSame == [op caseInsensitiveCompare:@"CONTAINS"]) {
        result = (NSNotFound != [s1 rangeOfString:s2].location);
    } else if (NSOrderedSame == [op caseInsensitiveCompare:@"ENDSWITH"]) {
        result = [s1 hasSuffix:s2];
    } else if (NSOrderedSame == [op caseInsensitiveCompare:@"LIKE"]) {
        result = NSOrderedSame == [s1 caseInsensitiveCompare:s2]; // TODO
    } else if (NSOrderedSame == [op caseInsensitiveCompare:@"MATCHES"]) {
        result = NSOrderedSame == [s1 caseInsensitiveCompare:s2]; // TODO
    }
    
    [a push:[NSNumber numberWithBool:result]];
}


- (void)workOnAndAndTerm:(PKAssembly *)a {
    BOOL b2 = [[a pop] boolValue];
    BOOL b1 = [[a pop] boolValue];
    [a push:[NSNumber numberWithBool:b1 && b2]];
}


- (void)workOnOrOrTerm:(PKAssembly *)a {
    BOOL b2 = [[a pop] boolValue];
    BOOL b1 = [[a pop] boolValue];
    [a push:[NSNumber numberWithBool:b1 || b2]];
}


- (void)workOnArray:(PKAssembly *)a {
    NSArray *objs = [a objectsAbove:openCurly];
    [a pop]; // discard '{'
    [a push:[objs reversedArray]];
}


- (void)workOnCollectionTestPredicate:(PKAssembly *)a {
    NSArray *array = [a pop];
    NSAssert([array isKindOfClass:[NSArray class]], @"");
    id value = [a pop];
    [a push:[NSNumber numberWithBool:[array containsObject:value]]];
}


- (void)workOnKeyPath:(PKAssembly *)a {
    NSString *keyPath = [[a pop] stringValue];
    [a push:[resolver resolvedValueForKeyPath:keyPath]];
}


- (void)workOnNum:(PKAssembly *)a {
    [a push:[NSNumber numberWithFloat:[[a pop] floatValue]]];
}


- (void)workOnTrue:(PKAssembly *)a {
    [a push:[NSNumber numberWithBool:YES]];
}


- (void)workOnFalse:(PKAssembly *)a {
    [a push:[NSNumber numberWithBool:NO]];
}


- (void)workOnTruePredicate:(PKAssembly *)a {
    [a push:[NSNumber numberWithBool:YES]];
}


- (void)workOnFalsePredicate:(PKAssembly *)a {
    [a push:[NSNumber numberWithBool:NO]];
}

@synthesize resolver;
@synthesize parser;
@synthesize openCurly;
@end
