//
//  PredicateParser.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/27/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "PredicateParser.h"

// expr                 = term orTerm*
// orTerm               = 'or' term
// term                 = primaryExpr andPrimaryExpr*
// andPrimaryExpr       = 'and' primaryExpr
// primaryExpr          = phrase | '(' expression ')'
// phrase               = predicate | negatedPredicate
// negatedPredicate     = 'not' predicate
// predicate            = bool | eqPredicate | nePredicate | gtPredicate | gteqPredicate | ltPredicate | lteqPredicate | beginswithPredicate | containsPredicate | endswithPredicate | matchesPredicate
// attr                 = tag | 'uniqueid' | 'line' | 'type' | 'isgroupheader' | 'level' | 'index' | 'content' | 'parent' | 'project' | 'countofchildren'
// tag                  = '@' Any
// eqPredicate          = attr '=' value
// nePredicate          = attr '!=' value
// gtPredicate          = attr '>' value
// gteqPredicate        = attr '>=' value
// ltPredicate          = attr '<' value
// lteqPredicate        = attr '<=' value
// beginswithPredicate  = attr 'beginswith' value
// containsPredicate    = attr 'contains' value
// endswithPredicate    = attr 'endswith' value
// matchesPredicate     = attr 'matches' value

// value                = QuotedString | Num | bool
// bool                 = 'true' | 'false'


@implementation PredicateParser

- (id)initWithDelegate:(id <PredicateParserDelegate>)d {
    if (self = [super init]) {
        delegate = d;
        [self add:self.exprParser];
    }
    return self;
}


- (void)dealloc {
    delegate = nil;
    self.exprParser = nil;
    self.orTermParser = nil;
    self.termParser = nil;
    self.andPrimaryExprParser = nil;
    self.primaryExprParser = nil;
    self.negatedPredicateParser = nil;
    self.predicateParser = nil;
    self.phraseParser = nil;
    self.boolParser = nil;
    self.trueParser = nil;
    self.falseParser = nil;
    [super dealloc];
}


// expression       = term orTerm*
- (TDCollectionParser *)exprParser {
    if (!exprParser) {
        self.exprParser = [TDSequence sequence];
        [exprParser add:self.termParser];
        [exprParser add:[TDRepetition repetitionWithSubparser:self.orTermParser]];
    }
    return exprParser;
}


// orTerm           = 'or' term
- (TDCollectionParser *)orTermParser {
    if (!orTermParser) {
        self.orTermParser = [TDSequence sequence];
        [orTermParser add:[[TDLiteral literalWithString:@"or"] discard]];
        [orTermParser add:self.termParser];
        [orTermParser setAssembler:self selector:@selector(workOnOrAssembly:)];
    }
    return orTermParser;
}


// term             = primaryExpr andPrimaryExpr*
- (TDCollectionParser *)termParser {
    if (!termParser) {
        self.termParser = [TDSequence sequence];
        [termParser add:self.primaryExprParser];
        [termParser add:[TDRepetition repetitionWithSubparser:self.andPrimaryExprParser]];
    }
    return termParser;
}


// andPrimaryExpr        = 'and' primaryExpr
- (TDCollectionParser *)andPrimaryExprParser {
    if (!andPrimaryExprParser) {
        self.andPrimaryExprParser = [TDSequence sequence];
        [andPrimaryExprParser add:[[TDLiteral literalWithString:@"and"] discard]];
        [andPrimaryExprParser add:self.primaryExprParser];
        [andPrimaryExprParser setAssembler:self selector:@selector(workOnAndAssembly:)];
    }
    return andPrimaryExprParser;
}


// primaryExpr           = phrase | '(' expression ')'
- (TDCollectionParser *)primaryExprParser {
    if (!primaryExprParser) {
        self.primaryExprParser = [TDAlternation alternation];
        [primaryExprParser add:self.phraseParser];
        
        TDSequence *s = [TDSequence sequence];
        [s add:[[TDSymbol symbolWithString:@"("] discard]];
        [s add:self.exprParser];
        [s add:[[TDSymbol symbolWithString:@")"] discard]];
        
        [primaryExprParser add:s];
    }
    return primaryExprParser;
}


// phrase      = predicate | negatedPredicate
- (TDCollectionParser *)phraseParser {
    if (!phraseParser) {
        self.phraseParser = [TDAlternation alternation];
        [phraseParser add:self.predicateParser];
        [phraseParser add:self.negatedPredicateParser];
    }
    return phraseParser;
}


// negatedPredicate      = 'not' predicate
- (TDCollectionParser *)negatedPredicateParser {
    if (!negatedPredicateParser) {
        self.negatedPredicateParser = [TDSequence sequence];
        [negatedPredicateParser add:[[TDLiteral literalWithString:@"not"] discard]];
        [negatedPredicateParser add:self.predicateParser];
        [negatedPredicateParser setAssembler:self selector:@selector(workOnNegatedValueAssembly:)];
    }
    return negatedPredicateParser;
}


// predicate         = bool | eqPredicate | nePredicate | gtPredicate | gteqPredicate | ltPredicate | lteqPredicate | beginswithPredicate | containsPredicate | endswithPredicate | matchesPredicate
- (TDCollectionParser *)predicateParser {
    if (!predicateParser) {
        self.predicateParser = [TDAlternation alternation];
        [predicateParser add:self.boolParser];
    }
    return predicateParser;
}


- (TDCollectionParser *)boolParser {
    if (!boolParser) {
        self.boolParser = [TDAlternation alternation];
        [boolParser add:self.trueParser];
        [boolParser add:self.falseParser];
    }
    return boolParser;
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


- (void)workOnAndAssembly:(TDAssembly *)a {
    id p2 = [a pop];
    id p1 = [a pop];
    NSArray *subs = [NSArray arrayWithObjects:p1, p2, nil];
    [a push:[NSCompoundPredicate andPredicateWithSubpredicates:subs]];
}


- (void)workOnOrAssembly:(TDAssembly *)a {
    id p2 = [a pop];
    id p1 = [a pop];
    NSArray *subs = [NSArray arrayWithObjects:p1, p2, nil];
    [a push:[NSCompoundPredicate orPredicateWithSubpredicates:subs]];
}


- (void)workOnNegatedValueAssembly:(TDAssembly *)a {
    id p = [a pop];
    [a push:[NSCompoundPredicate notPredicateWithSubpredicate:p]];
}

- (void)workOnTrueAssembly:(TDAssembly *)a {
    [a push:[NSPredicate predicateWithValue:YES]];
}


- (void)workOnFalseAssembly:(TDAssembly *)a {
    [a push:[NSPredicate predicateWithValue:NO]];
}

@synthesize exprParser;
@synthesize orTermParser;
@synthesize termParser;
@synthesize andPrimaryExprParser;
@synthesize primaryExprParser;
@synthesize phraseParser;
@synthesize negatedPredicateParser;
@synthesize predicateParser;
@synthesize boolParser;
@synthesize trueParser;
@synthesize falseParser;
@end
