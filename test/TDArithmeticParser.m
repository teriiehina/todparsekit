//
//  TDArithmeticParser.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/25/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDArithmeticParser.h"

/*
 expr           = term (plusTerm | minusTerm)*
 term           = factor (timesFactor | divFactor)*
 plusTerm       = '+' term
 minusTerm      = '-' term
 factor         = phrase exponentFactor | phrase
 timesFactor	= '*' factor
 divFactor      = '/' factor
 exponentFactor = '^' factor
 phrase         = '(' expr ')' | Num
*/

@implementation TDArithmeticParser

- (id)init {
    if (self = [super init]) {
        [self add:self.exprParser];
    }
    return self;
}


- (void)dealloc {
    self.exprParser = nil;
    self.termParser = nil;
    self.plusTermParser = nil;
    self.minusTermParser = nil;
    self.factorParser = nil;
    self.timesFactorParser = nil;
    self.divFactorParser = nil;
    self.exponentFactorParser = nil;
    self.phraseParser = nil;
    [super dealloc];
}


- (CGFloat)parse:(NSString *)s {
    PKAssembly *a = [TDTokenAssembly assemblyWithString:s];
    a = [self completeMatchFor:a];
//    NSLog(@"\n\na: %@\n\n", a);
    NSNumber *n = [a pop];
    return (CGFloat)[n floatValue];
}


// expr            = term (plusTerm | minusTerm)*
- (PKCollectionParser *)exprParser {
    if (!exprParser) {
        self.exprParser = [PKSequence sequence];
        [exprParser add:self.termParser];
        
        PKAlternation *a = [PKAlternation alternation];
        [a add:self.plusTermParser];
        [a add:self.minusTermParser];
        
        [exprParser add:[PKRepetition repetitionWithSubparser:a]];
    }
    return exprParser;
}


// term            = factor (timesFactor | divFactor)*
- (PKCollectionParser *)termParser {
    if (!termParser) {
        self.termParser = [PKSequence sequence];
        [termParser add:self.factorParser];
        
        PKAlternation *a = [PKAlternation alternation];
        [a add:self.timesFactorParser];
        [a add:self.divFactorParser];
        
        [termParser add:[PKRepetition repetitionWithSubparser:a]];
    }
    return termParser;
}


// plusTerm        = '+' term
- (PKCollectionParser *)plusTermParser {
    if (!plusTermParser) {
        self.plusTermParser = [PKSequence sequence];
        [plusTermParser add:[[TDSymbol symbolWithString:@"+"] discard]];
        [plusTermParser add:self.termParser];
        [plusTermParser setAssembler:self selector:@selector(workOnPlus:)];
    }
    return plusTermParser;
}


// minusTerm    = '-' term
- (PKCollectionParser *)minusTermParser {
    if (!minusTermParser) {
        self.minusTermParser = [PKSequence sequence];
        [minusTermParser add:[[TDSymbol symbolWithString:@"-"] discard]];
        [minusTermParser add:self.termParser];
        [minusTermParser setAssembler:self selector:@selector(workOnMinus:)];
    }
    return minusTermParser;
}


// factor        = phrase exponentFactor | phrase
- (PKCollectionParser *)factorParser {
    if (!factorParser) {
        self.factorParser = [PKAlternation alternation];
        
        PKSequence *s = [PKSequence sequence];
        [s add:self.phraseParser];
        [s add:self.exponentFactorParser];
        
        [factorParser add:s];
        [factorParser add:self.phraseParser];
    }
    return factorParser;
}


// timesFactor    = '*' factor
- (PKCollectionParser *)timesFactorParser {
    if (!timesFactorParser) {
        self.timesFactorParser = [PKSequence sequence];
        [timesFactorParser add:[[TDSymbol symbolWithString:@"*"] discard]];
        [timesFactorParser add:self.factorParser];
        [timesFactorParser setAssembler:self selector:@selector(workOnTimes:)];
    }
    return timesFactorParser;
}


// divFactor    = '/' factor
- (PKCollectionParser *)divFactorParser {
    if (!divFactorParser) {
        self.divFactorParser = [PKSequence sequence];
        [divFactorParser add:[[TDSymbol symbolWithString:@"/"] discard]];
        [divFactorParser add:self.factorParser];
        [divFactorParser setAssembler:self selector:@selector(workOnDivide:)];
    }
    return divFactorParser;
}


// exponentFactor    = '^' factor
- (PKCollectionParser *)exponentFactorParser {
    if (!exponentFactorParser) {
        self.exponentFactorParser = [PKSequence sequence];
        [exponentFactorParser add:[[TDSymbol symbolWithString:@"^"] discard]];
        [exponentFactorParser add:self.factorParser];
        [exponentFactorParser setAssembler:self selector:@selector(workOnExp:)];
    }
    return exponentFactorParser;
}


// phrase        = '(' expr ')' | Num
- (PKCollectionParser *)phraseParser {
    if (!phraseParser) {
        self.phraseParser = [PKAlternation alternation];
        
        PKSequence *s = [PKSequence sequence];
        [s add:[[TDSymbol symbolWithString:@"("] discard]];
        [s add:self.exprParser];
        [s add:[[TDSymbol symbolWithString:@")"] discard]];
        
        [phraseParser add:s];
        
        TDNum *n = [TDNum num];
        [phraseParser add:n];
    }
    return phraseParser;
}


#pragma mark -
#pragma mark Assembler

- (void)workOnPlus:(PKAssembly *)a {
    TDToken *tok2 = [a pop];
    TDToken *tok1 = [a pop];
    [a push:[NSNumber numberWithDouble:tok1.floatValue + tok2.floatValue]];
}


- (void)workOnMinus:(PKAssembly *)a {
    TDToken *tok2 = [a pop];
    TDToken *tok1 = [a pop];
    [a push:[NSNumber numberWithDouble:tok1.floatValue - tok2.floatValue]];
}


- (void)workOnTimes:(PKAssembly *)a {
    TDToken *tok2 = [a pop];
    TDToken *tok1 = [a pop];
    [a push:[NSNumber numberWithDouble:tok1.floatValue * tok2.floatValue]];
}


- (void)workOnDivide:(PKAssembly *)a {
    TDToken *tok2 = [a pop];
    TDToken *tok1 = [a pop];
    [a push:[NSNumber numberWithDouble:tok1.floatValue / tok2.floatValue]];
}


- (void)workOnExp:(PKAssembly *)a {
    TDToken *tok2 = [a pop];
    TDToken *tok1 = [a pop];
    
    CGFloat n1 = tok1.floatValue;
    CGFloat n2 = tok2.floatValue;
    
    CGFloat res = n1;
    NSUInteger i = 1;
    for ( ; i < n2; i++) {
        res *= n1;
    }
    
    [a push:[NSNumber numberWithDouble:res]];
}

@synthesize exprParser;
@synthesize termParser;
@synthesize plusTermParser;
@synthesize minusTermParser;
@synthesize factorParser;
@synthesize timesFactorParser;
@synthesize divFactorParser;
@synthesize exponentFactorParser;
@synthesize phraseParser;
@end
