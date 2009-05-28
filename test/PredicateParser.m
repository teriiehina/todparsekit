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
    [super dealloc];
}



- (TDCollectionParser *)expressionParser {
    if (!expressionParser) {
        self.expressionParser = [TDSequence sequence];
    }
    return expressionParser;
}


- (TDCollectionParser *)termParser {
    if (!termParser) {
        self.termParser = [TDSequence sequence];
    }
    return termParser;
}


- (TDCollectionParser *)orTermParser {
    if (!orTermParser) {
        self.orTermParser = [TDSequence sequence];
    }
    return orTermParser;
}


- (TDCollectionParser *)andPhraseParser {
    if (!andPhraseParser) {
        self.andPhraseParser = [TDSequence sequence];
    }
    return andPhraseParser;
}


- (TDCollectionParser *)phraseParser {
    if (!phraseParser) {
        self.phraseParser = [TDSequence sequence];
    }
    return phraseParser;
}


- (TDCollectionParser *)atomicValueParser {
    if (!atomicValueParser) {
        self.atomicValueParser = [TDSequence sequence];
    }
    return atomicValueParser;
}

@synthesize expressionParser;
@synthesize termParser;
@synthesize orTermParser;
@synthesize andPhraseParser;
@synthesize phraseParser;
@synthesize atomicValueParser;
@end
