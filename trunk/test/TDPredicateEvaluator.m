//
//  TDPredicateEvaluator.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/28/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDPredicateEvaluator.h"
#import "NSString+TDParseKitAdditions.h"

// expr                 = term orTerm*
// orTerm               = 'or' term
// term                 = primaryExpr andPrimaryExpr*
// andPrimaryExpr       = 'and' primaryExpr
// primaryExpr          = phrase | '(' expression ')'
// phrase               = predicate | negatedPredicate
// negatedPredicate     = 'not' predicate
// predicate            = bool | eqPredicate | nePredicate | gtPredicate | gteqPredicate | ltPredicate | lteqPredicate | beginswithPredicate | containsPredicate | endswithPredicate | matchesPredicate
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

// attr                 = tag | Word
// tag                  = '@' Word
// value                = QuotedString | Num | bool
// bool                 = 'true' | 'false'

@implementation TDPredicateEvaluator

- (id)initWithDelegate:(id <TDPredicateEvaluatorDelegate>)d {
    if (self = [super init]) {
        delegate = d;
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
    self.attrParser = nil;
    self.tagParser = nil;
    self.eqStringPredicateParser = nil;
    self.eqNumberPredicateParser = nil;
    self.eqBoolPredicateParser = nil;
    self.neStringPredicateParser = nil;
    self.neNumberPredicateParser = nil;
    self.neBoolPredicateParser = nil;
    self.gtPredicateParser = nil;
    self.gteqPredicateParser = nil;
    self.ltPredicateParser = nil;
    self.lteqPredicateParser = nil;
    self.beginswithPredicateParser = nil;
    self.containsPredicateParser = nil;
    self.endswithPredicateParser = nil;
    self.matchesPredicateParser = nil;
    self.valueParser = nil;
    self.boolParser = nil;
    self.trueParser = nil;
    self.falseParser = nil;
    self.stringParser = nil;
    self.numberParser = nil;
    [super dealloc];
}


- (BOOL)evaluate:(NSString *)s {
    PKAssembly *a = [TDTokenAssembly assemblyWithString:s];
    return [[[self.exprParser completeMatchFor:a] pop] boolValue];
}


// expression       = term orTerm*
- (PKCollectionParser *)exprParser {
    if (!exprParser) {
        self.exprParser = [TDSequence sequence];
        [exprParser add:self.termParser];
        [exprParser add:[TDRepetition repetitionWithSubparser:self.orTermParser]];
    }
    return exprParser;
}


// orTerm           = 'or' term
- (PKCollectionParser *)orTermParser {
    if (!orTermParser) {
        self.orTermParser = [TDSequence sequence];
        [orTermParser add:[[TDCaseInsensitiveLiteral literalWithString:@"or"] discard]];
        [orTermParser add:self.termParser];
        [orTermParser setAssembler:self selector:@selector(workOnOr:)];
    }
    return orTermParser;
}


// term             = primaryExpr andPrimaryExpr*
- (PKCollectionParser *)termParser {
    if (!termParser) {
        self.termParser = [TDSequence sequence];
        [termParser add:self.primaryExprParser];
        [termParser add:[TDRepetition repetitionWithSubparser:self.andPrimaryExprParser]];
    }
    return termParser;
}


// andPrimaryExpr        = 'and' primaryExpr
- (PKCollectionParser *)andPrimaryExprParser {
    if (!andPrimaryExprParser) {
        self.andPrimaryExprParser = [TDSequence sequence];
        [andPrimaryExprParser add:[[TDCaseInsensitiveLiteral literalWithString:@"and"] discard]];
        [andPrimaryExprParser add:self.primaryExprParser];
        [andPrimaryExprParser setAssembler:self selector:@selector(workOnAnd:)];
    }
    return andPrimaryExprParser;
}


// primaryExpr           = phrase | '(' expression ')'
- (PKCollectionParser *)primaryExprParser {
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
- (PKCollectionParser *)phraseParser {
    if (!phraseParser) {
        self.phraseParser = [TDAlternation alternation];
        [phraseParser add:self.predicateParser];
        [phraseParser add:self.negatedPredicateParser];
    }
    return phraseParser;
}


// negatedPredicate      = 'not' predicate
- (PKCollectionParser *)negatedPredicateParser {
    if (!negatedPredicateParser) {
        self.negatedPredicateParser = [TDSequence sequence];
        [negatedPredicateParser add:[[TDCaseInsensitiveLiteral literalWithString:@"not"] discard]];
        [negatedPredicateParser add:self.predicateParser];
        [negatedPredicateParser setAssembler:self selector:@selector(workOnNegatedValue:)];
    }
    return negatedPredicateParser;
}


// predicate         = bool | eqPredicate | nePredicate | gtPredicate | gteqPredicate | ltPredicate | lteqPredicate | beginswithPredicate | containsPredicate | endswithPredicate | matchesPredicate
- (PKCollectionParser *)predicateParser {
    if (!predicateParser) {
        self.predicateParser = [TDAlternation alternation];
        [predicateParser add:self.boolParser];
        [predicateParser add:self.eqStringPredicateParser];
        [predicateParser add:self.eqNumberPredicateParser];
        [predicateParser add:self.eqBoolPredicateParser];
        [predicateParser add:self.neStringPredicateParser];
        [predicateParser add:self.neNumberPredicateParser];
        [predicateParser add:self.neBoolPredicateParser];
        [predicateParser add:self.gtPredicateParser];
        [predicateParser add:self.gteqPredicateParser];
        [predicateParser add:self.ltPredicateParser];
        [predicateParser add:self.lteqPredicateParser];
        [predicateParser add:self.beginswithPredicateParser];
        [predicateParser add:self.containsPredicateParser];
        [predicateParser add:self.endswithPredicateParser];
        [predicateParser add:self.matchesPredicateParser];
    }
    return predicateParser;
}


// attr                 = tag | Word
- (PKCollectionParser *)attrParser {
    if (!attrParser) {
        self.attrParser = [TDAlternation alternation];
        [attrParser add:self.tagParser];
        [attrParser add:[TDWord word]];
        [attrParser setAssembler:self selector:@selector(workOnAttr:)];
    }
    return attrParser;
}


// tag                  = '@' Word
- (PKCollectionParser *)tagParser {
    if (!tagParser) {
        self.tagParser = [TDSequence sequence];
        [tagParser add:[[TDSymbol symbolWithString:@"@"] discard]];
        [tagParser add:[TDWord word]];
    }
    return tagParser;
}


// eqPredicate          = attr '=' value
- (PKCollectionParser *)eqStringPredicateParser {
    if (!eqStringPredicateParser) {
        self.eqStringPredicateParser = [TDSequence sequence];
        [eqStringPredicateParser add:self.attrParser];
        [eqStringPredicateParser add:[[TDSymbol symbolWithString:@"="] discard]];
        [eqStringPredicateParser add:self.stringParser];
        [eqStringPredicateParser setAssembler:self selector:@selector(workOnEqStringPredicate:)];
    }
    return eqStringPredicateParser;
}


- (PKCollectionParser *)eqNumberPredicateParser {
    if (!eqNumberPredicateParser) {
        self.eqNumberPredicateParser = [TDSequence sequence];
        [eqNumberPredicateParser add:self.attrParser];
        [eqNumberPredicateParser add:[[TDSymbol symbolWithString:@"="] discard]];
        [eqNumberPredicateParser add:self.numberParser];
        [eqNumberPredicateParser setAssembler:self selector:@selector(workOnEqNumberPredicate:)];
    }
    return eqNumberPredicateParser;
}


- (PKCollectionParser *)eqBoolPredicateParser {
    if (!eqBoolPredicateParser) {
        self.eqBoolPredicateParser = [TDSequence sequence];
        [eqBoolPredicateParser add:self.attrParser];
        [eqBoolPredicateParser add:[[TDSymbol symbolWithString:@"="] discard]];
        [eqBoolPredicateParser add:self.boolParser];
        [eqBoolPredicateParser setAssembler:self selector:@selector(workOnEqBoolPredicate:)];
    }
    return eqBoolPredicateParser;
}


// nePredicate          = attr '!=' value
- (PKCollectionParser *)neStringPredicateParser {
    if (!neStringPredicateParser) {
        self.neStringPredicateParser = [TDSequence sequence];
        [neStringPredicateParser add:self.attrParser];
        [neStringPredicateParser add:[[TDSymbol symbolWithString:@"!="] discard]];
        [neStringPredicateParser add:self.stringParser];
        [neStringPredicateParser setAssembler:self selector:@selector(workOnNeStringPredicate:)];
    }
    return neStringPredicateParser;
}


- (PKCollectionParser *)neNumberPredicateParser {
    if (!neNumberPredicateParser) {
        self.neNumberPredicateParser = [TDSequence sequence];
        [neNumberPredicateParser add:self.attrParser];
        [neNumberPredicateParser add:[[TDSymbol symbolWithString:@"!="] discard]];
        [neNumberPredicateParser add:self.numberParser];
        [neNumberPredicateParser setAssembler:self selector:@selector(workOnNeNumberPredicate:)];
    }
    return neNumberPredicateParser;
}


- (PKCollectionParser *)neBoolPredicateParser {
    if (!neBoolPredicateParser) {
        self.neBoolPredicateParser = [TDSequence sequence];
        [neBoolPredicateParser add:self.attrParser];
        [neBoolPredicateParser add:[[TDSymbol symbolWithString:@"!="] discard]];
        [neBoolPredicateParser add:self.boolParser];
        [neBoolPredicateParser setAssembler:self selector:@selector(workOnNeBoolPredicate:)];
    }
    return neBoolPredicateParser;
}


// gtPredicate          = attr '>' value
- (PKCollectionParser *)gtPredicateParser {
    if (!gtPredicateParser) {
        self.gtPredicateParser = [TDSequence sequence];
        [gtPredicateParser add:self.attrParser];
        [gtPredicateParser add:[[TDSymbol symbolWithString:@">"] discard]];
        [gtPredicateParser add:self.valueParser];
        [gtPredicateParser setAssembler:self selector:@selector(workOnGtPredicate:)];
    }
    return gtPredicateParser;
}


// gteqPredicate        = attr '>=' value
- (PKCollectionParser *)gteqPredicateParser {
    if (!gteqPredicateParser) {
        self.gteqPredicateParser = [TDSequence sequence];
        [gteqPredicateParser add:self.attrParser];
        [gteqPredicateParser add:[[TDSymbol symbolWithString:@">="] discard]];
        [gteqPredicateParser add:self.valueParser];
        [gteqPredicateParser setAssembler:self selector:@selector(workOnGteqPredicate:)];
    }
    return gteqPredicateParser;
}


// ltPredicate          = attr '<' value
- (PKCollectionParser *)ltPredicateParser {
    if (!ltPredicateParser) {
        self.ltPredicateParser = [TDSequence sequence];
        [ltPredicateParser add:self.attrParser];
        [ltPredicateParser add:[[TDSymbol symbolWithString:@"<"] discard]];
        [ltPredicateParser add:self.valueParser];
        [ltPredicateParser setAssembler:self selector:@selector(workOnLtPredicate:)];
    }
    return ltPredicateParser;
}


// lteqPredicate        = attr '<=' value
- (PKCollectionParser *)lteqPredicateParser {
    if (!lteqPredicateParser) {
        self.lteqPredicateParser = [TDSequence sequence];
        [lteqPredicateParser add:self.attrParser];
        [lteqPredicateParser add:[[TDSymbol symbolWithString:@"<="] discard]];
        [lteqPredicateParser add:self.valueParser];
        [lteqPredicateParser setAssembler:self selector:@selector(workOnLteqPredicate:)];
    }
    return lteqPredicateParser;
}


// beginswithPredicate  = attr 'beginswith' value
- (PKCollectionParser *)beginswithPredicateParser {
    if (!beginswithPredicateParser) {
        self.beginswithPredicateParser = [TDSequence sequence];
        [beginswithPredicateParser add:self.attrParser];
        [beginswithPredicateParser add:[[TDCaseInsensitiveLiteral literalWithString:@"beginswith"] discard]];
        [beginswithPredicateParser add:self.valueParser];
        [beginswithPredicateParser setAssembler:self selector:@selector(workOnBeginswithPredicate:)];
    }
    return beginswithPredicateParser;
}


// containsPredicate    = attr 'contains' value
- (PKCollectionParser *)containsPredicateParser {
    if (!containsPredicateParser) {
        self.containsPredicateParser = [TDSequence sequence];
        [containsPredicateParser add:self.attrParser];
        [containsPredicateParser add:[[TDCaseInsensitiveLiteral literalWithString:@"contains"] discard]];
        [containsPredicateParser add:self.valueParser];
        [containsPredicateParser setAssembler:self selector:@selector(workOnContainsPredicate:)];
    }
    return containsPredicateParser;
}


// endswithPredicate    = attr 'endswith' value
- (PKCollectionParser *)endswithPredicateParser {
    if (!endswithPredicateParser) {
        self.endswithPredicateParser = [TDSequence sequence];
        [endswithPredicateParser add:self.attrParser];
        [endswithPredicateParser add:[[TDCaseInsensitiveLiteral literalWithString:@"endswith"] discard]];
        [endswithPredicateParser add:self.valueParser];
        [endswithPredicateParser setAssembler:self selector:@selector(workOnEndswithPredicate:)];
    }
    return endswithPredicateParser;
}


// matchesPredicate     = attr 'matches' value
- (PKCollectionParser *)matchesPredicateParser {
    if (!matchesPredicateParser) {
        self.matchesPredicateParser = [TDSequence sequence];
        [matchesPredicateParser add:self.attrParser];
        [matchesPredicateParser add:[[TDCaseInsensitiveLiteral literalWithString:@"matches"] discard]];
        [matchesPredicateParser add:self.valueParser];
        [matchesPredicateParser setAssembler:self selector:@selector(workOnMatchesPredicate:)];
    }
    return matchesPredicateParser;
}


// value                = QuotedString | Num | bool
- (PKCollectionParser *)valueParser {
    if (!valueParser) {
        self.valueParser = [TDAlternation alternation];
        [valueParser add:self.stringParser];
        [valueParser add:self.numberParser];
        [valueParser add:self.boolParser];
    }
    return valueParser;
}


- (PKCollectionParser *)boolParser {
    if (!boolParser) {
        self.boolParser = [TDAlternation alternation];
        [boolParser add:self.trueParser];
        [boolParser add:self.falseParser];
        [boolParser setAssembler:self selector:@selector(workOnBool:)];
    }
    return boolParser;
}


- (PKParser *)trueParser {
    if (!trueParser) {
        self.trueParser = [[TDCaseInsensitiveLiteral literalWithString:@"true"] discard];
        [trueParser setAssembler:self selector:@selector(workOnTrue:)];
    }
    return trueParser;
}


- (PKParser *)falseParser {
    if (!falseParser) {
        self.falseParser = [[TDCaseInsensitiveLiteral literalWithString:@"false"] discard];
        [falseParser setAssembler:self selector:@selector(workOnFalse:)];
    }
    return falseParser;
}


- (PKParser *)stringParser {
    if (!stringParser) {
        self.stringParser = [TDQuotedString quotedString];
        [stringParser setAssembler:self selector:@selector(workOnString:)];
    }
    return stringParser;
}


- (PKParser *)numberParser {
    if (!numberParser) {
        self.numberParser = [TDNum num];
        [numberParser setAssembler:self selector:@selector(workOnNumber:)];
    }
    return numberParser;
}


- (void)workOnAnd:(PKAssembly *)a {
    NSNumber *b2 = [a pop];
    NSNumber *b1 = [a pop];
    BOOL yn = ([b1 boolValue] && [b2 boolValue]);
    [a push:[NSNumber numberWithBool:yn]];
}


- (void)workOnOr:(PKAssembly *)a {
    NSNumber *b2 = [a pop];
    NSNumber *b1 = [a pop];
    BOOL yn = ([b1 boolValue] || [b2 boolValue]);
    [a push:[NSNumber numberWithBool:yn]];
}


- (void)workOnEqStringPredicate:(PKAssembly *)a {
    NSString *value = [a pop];
    NSString *attrKey = [a pop];
    BOOL yn = [[delegate valueForAttributeKey:attrKey] isEqual:value];
    [a push:[NSNumber numberWithBool:yn]];
}


- (void)workOnEqNumberPredicate:(PKAssembly *)a {
    NSNumber *value = [a pop];
    NSString *attrKey = [a pop];
    BOOL yn = [value isEqualToNumber:[delegate valueForAttributeKey:attrKey]];
    [a push:[NSNumber numberWithBool:yn]];
}


- (void)workOnEqBoolPredicate:(PKAssembly *)a {
    NSNumber *b = [a pop];
    NSString *attrKey = [a pop];
    BOOL yn = ([delegate boolForAttributeKey:attrKey] == [b boolValue]);
    [a push:[NSNumber numberWithBool:yn]];
}


- (void)workOnNeStringPredicate:(PKAssembly *)a {
    NSString *value = [a pop];
    NSString *attrKey = [a pop];
    
    BOOL yn = ![[delegate valueForAttributeKey:attrKey] isEqual:value];
    [a push:[NSNumber numberWithBool:yn]];
}


- (void)workOnNeNumberPredicate:(PKAssembly *)a {
    NSNumber *value = [a pop];
    NSString *attrKey = [a pop];
    BOOL yn = ![value isEqualToNumber:[delegate valueForAttributeKey:attrKey]];
    [a push:[NSNumber numberWithBool:yn]];
}


- (void)workOnNeBoolPredicate:(PKAssembly *)a {
    NSNumber *b = [a pop];
    NSString *attrKey = [a pop];
    BOOL yn = ([delegate boolForAttributeKey:attrKey] != [b boolValue]);
    [a push:[NSNumber numberWithBool:yn]];
}


- (void)workOnGtPredicate:(PKAssembly *)a {
    NSNumber *value = [a pop];
    NSString *attrKey = [a pop];
    BOOL yn = (NSOrderedDescending == [[delegate valueForAttributeKey:attrKey] compare:value]);
    [a push:[NSNumber numberWithBool:yn]];
}


- (void)workOnGteqPredicate:(PKAssembly *)a {
    NSNumber *value = [a pop];
    NSString *attrKey = [a pop];
    BOOL yn = (NSOrderedAscending != [[delegate valueForAttributeKey:attrKey] compare:value]);
    [a push:[NSNumber numberWithBool:yn]];
}


- (void)workOnLtPredicate:(PKAssembly *)a {
    NSNumber *value = [a pop];
    NSString *attrKey = [a pop];
    BOOL yn = (NSOrderedAscending == [[delegate valueForAttributeKey:attrKey] compare:value]);
    [a push:[NSNumber numberWithBool:yn]];
}


- (void)workOnLteqPredicate:(PKAssembly *)a {
    NSNumber *value = [a pop];
    NSString *attrKey = [a pop];
    BOOL yn = (NSOrderedDescending != [[delegate valueForAttributeKey:attrKey] compare:value]);
    [a push:[NSNumber numberWithBool:yn]];
}


- (void)workOnBeginswithPredicate:(PKAssembly *)a {
    NSString *value = [a pop];
    NSString *attrKey = [a pop];
    BOOL yn = [[delegate valueForAttributeKey:attrKey] hasPrefix:value];
    [a push:[NSNumber numberWithBool:yn]];
}


- (void)workOnContainsPredicate:(PKAssembly *)a {
    NSString *value = [a pop];
    NSString *attrKey = [a pop];
    NSRange r = [[delegate valueForAttributeKey:attrKey] rangeOfString:value];
    BOOL yn = (NSNotFound != r.location);
    [a push:[NSNumber numberWithBool:yn]];
}


- (void)workOnEndswithPredicate:(PKAssembly *)a {
    NSString *value = [a pop];
    NSString *attrKey = [a pop];
    BOOL yn = [[delegate valueForAttributeKey:attrKey] hasSuffix:value];
    [a push:[NSNumber numberWithBool:yn]];
}


- (void)workOnMatchesPredicate:(PKAssembly *)a {
    NSString *value = [a pop];
    NSString *attrKey = [a pop];
    BOOL yn = [[delegate valueForAttributeKey:attrKey] isEqual:value]; // TODO should this be a regex match?
    [a push:[NSNumber numberWithBool:yn]];
}


- (void)workOnAttr:(PKAssembly *)a {
    [a push:[[a pop] stringValue]];
}


- (void)workOnNegatedValue:(PKAssembly *)a {
    NSNumber *b = [a pop];
    [a push:[NSNumber numberWithBool:![b boolValue]]];
}


- (void)workOnBool:(PKAssembly *)a {
    NSNumber *b = [a pop];
    [a push:[NSNumber numberWithBool:[b boolValue]]];
}


- (void)workOnTrue:(PKAssembly *)a {
    [a push:[NSNumber numberWithBool:YES]];
}


- (void)workOnFalse:(PKAssembly *)a {
    [a push:[NSNumber numberWithBool:NO]];
}


- (void)workOnString:(PKAssembly *)a {
    NSString *s = [[[a pop] stringValue] stringByTrimmingQuotes];
    [a push:s];
}


- (void)workOnNumber:(PKAssembly *)a {
    NSNumber *b = [NSNumber numberWithFloat:[[a pop] floatValue]];
    [a push:b];
}

@synthesize exprParser;
@synthesize orTermParser;
@synthesize termParser;
@synthesize andPrimaryExprParser;
@synthesize primaryExprParser;
@synthesize phraseParser;
@synthesize negatedPredicateParser;
@synthesize predicateParser;
@synthesize attrParser;
@synthesize tagParser;
@synthesize eqStringPredicateParser;
@synthesize eqNumberPredicateParser;
@synthesize eqBoolPredicateParser;
@synthesize neStringPredicateParser;
@synthesize neNumberPredicateParser;
@synthesize neBoolPredicateParser;
@synthesize gtPredicateParser;
@synthesize gteqPredicateParser;
@synthesize ltPredicateParser;
@synthesize lteqPredicateParser;
@synthesize beginswithPredicateParser;
@synthesize containsPredicateParser;
@synthesize endswithPredicateParser;
@synthesize matchesPredicateParser;
@synthesize valueParser;
@synthesize boolParser;
@synthesize trueParser;
@synthesize falseParser;
@synthesize stringParser;
@synthesize numberParser;
@end
