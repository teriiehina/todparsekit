//
//  PredicateParser.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/27/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "PredicateParser.h"

/*
 statement			= exprOrAssignment ';'
 exprOrAssignment	= expression | assigment
 assigment			= declaration '=' expression
 declaration		= '$' Word
 variable			= '$' Word
 expression			= term orTerm*
 term				= factor nextFactor*
 orTerm				= '|' term
 factor				= phrase | phraseStar | phraseQuestion | phrasePlus
 nextFactor			= factor
 phrase				= atomicValue | '(' expression ')'
 phraseStar			= phrase '*'
 phraseQuestion		= phrase '?'
 phrasePlus			= phrase '+'
 atomicValue        = Word | Num | QuotedString | variable
 */


// expression       = term orTerm*
// term             = phrase andPhrase*
// orTerm           = 'or' term
// andPhrase        = 'and' phrase
// phrase           = atomicValue | '(' expression ')'
// atomicValue      = 'true' | 'false'

@implementation PredicateParser

- (id)init {
    if (self = [super init]) {
        [self add:self.expressionParser];
    }
    return self;
}


- (void)dealloc {
    self.expressionParser = nil;
    self.termParser = nil;
    self.orTermParser = nil;
    self.andPhraseParser = nil;
    self.phraseParser = nil;
    self.atomicValueParser = nil;
    self.trueParser = nil;
    self.falseParser = nil;
    [super dealloc];
}



// expression       = term orTerm*
- (TDCollectionParser *)expressionParser {
    if (!expressionParser) {
        self.expressionParser = [TDSequence sequence];
        [expressionParser add:self.termParser];
        [expressionParser add:[TDRepetition repetitionWithSubparser:self.orTermParser]];
    }
    return expressionParser;
}


// term             = phrase andPhrase*
- (TDCollectionParser *)termParser {
    if (!termParser) {
        self.termParser = [TDSequence sequence];
        [termParser add:self.phraseParser];
        [termParser add:[TDRepetition repetitionWithSubparser:self.andPhraseParser]];
    }
    return termParser;
}


// orTerm           = 'or' term
- (TDCollectionParser *)orTermParser {
    if (!orTermParser) {
        self.orTermParser = [TDSequence sequence];
        [orTermParser add:[[TDLiteral literalWithString:@"or"] discard]];
        [orTermParser add:self.termParser];
    }
    return orTermParser;
}


// andPhrase        = 'and' phrase
- (TDCollectionParser *)andPhraseParser {
    if (!andPhraseParser) {
        self.andPhraseParser = [TDSequence sequence];
        [andPhraseParser add:[[TDLiteral literalWithString:@"and"] discard]];
        [andPhraseParser add:self.phraseParser];
    }
    return andPhraseParser;
}


// phrase           = atomicValue | '(' expression ')'
- (TDCollectionParser *)phraseParser {
    if (!phraseParser) {
        self.phraseParser = [TDAlternation alternation];
        [phraseParser add:self.atomicValueParser];
        
        TDSequence *s = [TDSequence sequence];
        [s add:[[TDSymbol symbolWithString:@"("] discard]];
        [s add:self.expressionParser];
        [s add:[[TDSymbol symbolWithString:@")"] discard]];
        
        [phraseParser add:s];
    }
    return phraseParser;
}


// atomicValue      = false | true
- (TDCollectionParser *)atomicValueParser {
    if (!atomicValueParser) {
        self.atomicValueParser = [TDAlternation alternation];
        [atomicValueParser add:self.trueParser];
        [atomicValueParser add:self.falseParser];
    }
    return atomicValueParser;
}


- (TDParser *)trueParser {
    if (!trueParser) {
        self.trueParser = [[TDLiteral literalWithString:@"true"] discard];
        [trueParser setAssembler:self selector:@selector(workOnTrueAssembly:)];
    }
    return trueParser;
}


- (TDParser *)falseParser {
    if (!falseParser) {
        self.falseParser = [[TDLiteral literalWithString:@"false"] discard];
        [falseParser setAssembler:self selector:@selector(workOnFalseAssembly:)];
    }
    return falseParser;
}


- (void)workOnTrueAssembly:(TDAssembly *)a {
    [a push:[NSPredicate predicateWithValue:YES]];
}


- (void)workOnFalseAssembly:(TDAssembly *)a {
    [a push:[NSPredicate predicateWithValue:NO]];
}

@synthesize expressionParser;
@synthesize termParser;
@synthesize orTermParser;
@synthesize andPhraseParser;
@synthesize phraseParser;
@synthesize atomicValueParser;
@synthesize trueParser;
@synthesize falseParser;
@end
