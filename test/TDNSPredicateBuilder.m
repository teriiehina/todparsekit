//
//  PredicateParser.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/27/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDNSPredicateBuilder.h"
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
// value                = string | Num | bool
// string               = QuotedString | unquotedString
// unquotedString       = Word[^and, or, not]+

// bool                 = 'true' | 'false'

@implementation TDNSPredicateBuilder

- (id)init {
    if (self = [super init]) {

    }
    return self;
}


- (void)dealloc {
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
    self.quotedStringParser = nil;
    self.unquotedStringParser = nil;
    self.numberParser = nil;
    [super dealloc];
}


- (NSPredicate *)buildFrom:(NSString *)s; {
    TDAssembly *a = [TDTokenAssembly assemblyWithString:s];
    return [[self.exprParser completeMatchFor:a] pop];
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
        [orTermParser add:[[TDCaseInsensitiveLiteral literalWithString:@"or"] discard]];
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
        [andPrimaryExprParser add:[[TDCaseInsensitiveLiteral literalWithString:@"and"] discard]];
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
        [negatedPredicateParser add:[[TDCaseInsensitiveLiteral literalWithString:@"not"] discard]];
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


// attr                 = tag | 'uniqueid' | 'line' | 'type' | 'isgroupheader' | 'level' | 'index' | 'content' | 'parent' | 'project' | 'countofchildren'
- (TDCollectionParser *)attrParser {
    if (!attrParser) {
        self.attrParser = [TDAlternation alternation];
        [attrParser add:self.tagParser];
        [attrParser add:[TDWord word]];
        [attrParser setAssembler:self selector:@selector(workOnAttrAssembly:)];
    }
    return attrParser;
}


// tag                  = '@' Word
- (TDCollectionParser *)tagParser {
    if (!tagParser) {
        self.tagParser = [TDSequence sequence];
        [tagParser add:[[TDSymbol symbolWithString:@"@"] discard]];
        [tagParser add:[TDWord word]];
    }
    return tagParser;
}


// eqPredicate          = attr '=' value
- (TDCollectionParser *)eqStringPredicateParser {
    if (!eqStringPredicateParser) {
        self.eqStringPredicateParser = [TDSequence sequence];
        [eqStringPredicateParser add:self.attrParser];
        [eqStringPredicateParser add:[[TDSymbol symbolWithString:@"="] discard]];
        [eqStringPredicateParser add:self.stringParser];
        [eqStringPredicateParser setAssembler:self selector:@selector(workOnEqStringPredicateAssembly:)];
    }
    return eqStringPredicateParser;
}


- (TDCollectionParser *)eqNumberPredicateParser {
    if (!eqNumberPredicateParser) {
        self.eqNumberPredicateParser = [TDSequence sequence];
        [eqNumberPredicateParser add:self.attrParser];
        [eqNumberPredicateParser add:[[TDSymbol symbolWithString:@"="] discard]];
        [eqNumberPredicateParser add:self.numberParser];
        [eqNumberPredicateParser setAssembler:self selector:@selector(workOnEqNumberPredicateAssembly:)];
    }
    return eqNumberPredicateParser;
}


- (TDCollectionParser *)eqBoolPredicateParser {
    if (!eqBoolPredicateParser) {
        self.eqBoolPredicateParser = [TDSequence sequence];
        [eqBoolPredicateParser add:self.attrParser];
        [eqBoolPredicateParser add:[[TDSymbol symbolWithString:@"="] discard]];
        [eqBoolPredicateParser add:self.boolParser];
        [eqBoolPredicateParser setAssembler:self selector:@selector(workOnEqBoolPredicateAssembly:)];
    }
    return eqBoolPredicateParser;
}


// nePredicate          = attr '!=' value
- (TDCollectionParser *)neStringPredicateParser {
    if (!neStringPredicateParser) {
        self.neStringPredicateParser = [TDSequence sequence];
        [neStringPredicateParser add:self.attrParser];
        [neStringPredicateParser add:[[TDSymbol symbolWithString:@"!="] discard]];
        [neStringPredicateParser add:self.stringParser];
        [neStringPredicateParser setAssembler:self selector:@selector(workOnNeStringPredicateAssembly:)];
    }
    return neStringPredicateParser;
}


- (TDCollectionParser *)neNumberPredicateParser {
    if (!neNumberPredicateParser) {
        self.neNumberPredicateParser = [TDSequence sequence];
        [neNumberPredicateParser add:self.attrParser];
        [neNumberPredicateParser add:[[TDSymbol symbolWithString:@"!="] discard]];
        [neNumberPredicateParser add:self.numberParser];
        [neNumberPredicateParser setAssembler:self selector:@selector(workOnNeNumberPredicateAssembly:)];
    }
    return neNumberPredicateParser;
}


- (TDCollectionParser *)neBoolPredicateParser {
    if (!neBoolPredicateParser) {
        self.neBoolPredicateParser = [TDSequence sequence];
        [neBoolPredicateParser add:self.attrParser];
        [neBoolPredicateParser add:[[TDSymbol symbolWithString:@"!="] discard]];
        [neBoolPredicateParser add:self.boolParser];
        [neBoolPredicateParser setAssembler:self selector:@selector(workOnNeBoolPredicateAssembly:)];
    }
    return neBoolPredicateParser;
}


// gtPredicate          = attr '>' value
- (TDCollectionParser *)gtPredicateParser {
    if (!gtPredicateParser) {
        self.gtPredicateParser = [TDSequence sequence];
        [gtPredicateParser add:self.attrParser];
        [gtPredicateParser add:[[TDSymbol symbolWithString:@">"] discard]];
        [gtPredicateParser add:self.valueParser];
        [gtPredicateParser setAssembler:self selector:@selector(workOnGtPredicateAssembly:)];
    }
    return gtPredicateParser;
}


// gteqPredicate        = attr '>=' value
- (TDCollectionParser *)gteqPredicateParser {
    if (!gteqPredicateParser) {
        self.gteqPredicateParser = [TDSequence sequence];
        [gteqPredicateParser add:self.attrParser];
        [gteqPredicateParser add:[[TDSymbol symbolWithString:@">="] discard]];
        [gteqPredicateParser add:self.valueParser];
        [gteqPredicateParser setAssembler:self selector:@selector(workOnGteqPredicateAssembly:)];
    }
    return gteqPredicateParser;
}


// ltPredicate          = attr '<' value
- (TDCollectionParser *)ltPredicateParser {
    if (!ltPredicateParser) {
        self.ltPredicateParser = [TDSequence sequence];
        [ltPredicateParser add:self.attrParser];
        [ltPredicateParser add:[[TDSymbol symbolWithString:@"<"] discard]];
        [ltPredicateParser add:self.valueParser];
        [ltPredicateParser setAssembler:self selector:@selector(workOnLtPredicateAssembly:)];
    }
    return ltPredicateParser;
}


// lteqPredicate        = attr '<=' value
- (TDCollectionParser *)lteqPredicateParser {
    if (!lteqPredicateParser) {
        self.lteqPredicateParser = [TDSequence sequence];
        [lteqPredicateParser add:self.attrParser];
        [lteqPredicateParser add:[[TDSymbol symbolWithString:@"<="] discard]];
        [lteqPredicateParser add:self.valueParser];
        [lteqPredicateParser setAssembler:self selector:@selector(workOnLteqPredicateAssembly:)];
    }
    return lteqPredicateParser;
}


// beginswithPredicate  = attr 'beginswith' value
- (TDCollectionParser *)beginswithPredicateParser {
    if (!beginswithPredicateParser) {
        self.beginswithPredicateParser = [TDSequence sequence];
        [beginswithPredicateParser add:self.attrParser];
        [beginswithPredicateParser add:[[TDCaseInsensitiveLiteral literalWithString:@"beginswith"] discard]];
        [beginswithPredicateParser add:self.valueParser];
        [beginswithPredicateParser setAssembler:self selector:@selector(workOnBeginswithPredicateAssembly:)];
    }
    return beginswithPredicateParser;
}


// containsPredicate    = attr 'contains' value
- (TDCollectionParser *)containsPredicateParser {
    if (!containsPredicateParser) {
        self.containsPredicateParser = [TDSequence sequence];
        [containsPredicateParser add:self.attrParser];
        [containsPredicateParser add:[[TDCaseInsensitiveLiteral literalWithString:@"contains"] discard]];
        [containsPredicateParser add:self.valueParser];
        [containsPredicateParser setAssembler:self selector:@selector(workOnContainsPredicateAssembly:)];
    }
    return containsPredicateParser;
}


// endswithPredicate    = attr 'endswith' value
- (TDCollectionParser *)endswithPredicateParser {
    if (!endswithPredicateParser) {
        self.endswithPredicateParser = [TDSequence sequence];
        [endswithPredicateParser add:self.attrParser];
        [endswithPredicateParser add:[[TDCaseInsensitiveLiteral literalWithString:@"endswith"] discard]];
        [endswithPredicateParser add:self.valueParser];
        [endswithPredicateParser setAssembler:self selector:@selector(workOnEndswithPredicateAssembly:)];
    }
    return endswithPredicateParser;
}


// matchesPredicate     = attr 'matches' value
- (TDCollectionParser *)matchesPredicateParser {
    if (!matchesPredicateParser) {
        self.matchesPredicateParser = [TDSequence sequence];
        [matchesPredicateParser add:self.attrParser];
        [matchesPredicateParser add:[[TDCaseInsensitiveLiteral literalWithString:@"matches"] discard]];
        [matchesPredicateParser add:self.valueParser];
        [matchesPredicateParser setAssembler:self selector:@selector(workOnMatchesPredicateAssembly:)];
    }
    return matchesPredicateParser;
}


// value                = QuotedString | Num | bool
- (TDCollectionParser *)valueParser {
    if (!valueParser) {
        self.valueParser = [TDAlternation alternation];
        [valueParser add:self.stringParser];
        [valueParser add:self.numberParser];
        [valueParser add:self.boolParser];
    }
    return valueParser;
}


- (TDCollectionParser *)boolParser {
    if (!boolParser) {
        self.boolParser = [TDAlternation alternation];
        [boolParser add:self.trueParser];
        [boolParser add:self.falseParser];
        [boolParser setAssembler:self selector:@selector(workOnBoolAssembly:)];
    }
    return boolParser;
}


- (TDParser *)trueParser {
    if (!trueParser) {
        self.trueParser = [[TDCaseInsensitiveLiteral literalWithString:@"true"] discard];
        [trueParser setAssembler:self selector:@selector(workOnTrueAssembly:)];
    }
    return trueParser;
}


- (TDParser *)falseParser {
    if (!falseParser) {
        self.falseParser = [[TDCaseInsensitiveLiteral literalWithString:@"false"] discard];
        [falseParser setAssembler:self selector:@selector(workOnFalseAssembly:)];
    }
    return falseParser;
}


// string               = quotedString | unquotedString
- (TDCollectionParser *)stringParser {
    if (!stringParser) {
        self.stringParser = [TDAlternation alternation];
        [stringParser add:self.quotedStringParser];
        [stringParser add:self.unquotedStringParser];
        [stringParser setAssembler:self selector:@selector(workOnStringAssembly:)];
    }
    return stringParser;
}


// quotedString         = QuotedString
- (TDParser *)quotedStringParser {
    if (!quotedStringParser) {
        self.quotedStringParser = [TDQuotedString quotedString];
        [quotedStringParser setAssembler:self selector:@selector(workOnQuotedStringAssembly:)];
    }
    return quotedStringParser;
}


// unquotedString       = Word[^and, or, not]+
- (TDCollectionParser *)unquotedStringParser {
    if (!unquotedStringParser) {
        
        TDWord *w = [TDWord word];
        w.exceptions = [NSArray arrayWithObjects:@"true", @"false", @"and", @"or", @"not", nil];
        [w setAssembler:self selector:@selector(workOnUnquotedStringWordAssembly:)];
        
        self.unquotedStringParser = [TDSequence sequence];
        [unquotedStringParser add:w];
        [unquotedStringParser add:[TDRepetition repetitionWithSubparser:w]];
        [unquotedStringParser setAssembler:self selector:@selector(workOnUnquotedStringAssembly:)];
    }
    return unquotedStringParser;
}


- (TDParser *)numberParser {
    if (!numberParser) {
        self.numberParser = [TDNum num];
        [numberParser setAssembler:self selector:@selector(workOnNumberAssembly:)];
    }
    return numberParser;
}


- (void)workOnAndAssembly:(TDAssembly *)a {
    NSPredicate *p2 = [a pop];
    NSPredicate *p1 = [a pop];
    NSArray *subs = [NSArray arrayWithObjects:p1, p2, nil];
    [a push:[NSCompoundPredicate andPredicateWithSubpredicates:subs]];
}


- (void)workOnOrAssembly:(TDAssembly *)a {
    NSPredicate *p2 = [a pop];
    NSPredicate *p1 = [a pop];
    NSArray *subs = [NSArray arrayWithObjects:p1, p2, nil];
    [a push:[NSCompoundPredicate orPredicateWithSubpredicates:subs]];
}


- (void)workOnEqStringPredicateAssembly:(TDAssembly *)a {
    NSString *value = [a pop];
    NSString *key = [a pop];
    [a push:[NSPredicate predicateWithFormat:@"%K = %@", key, value]];
}


- (void)workOnEqNumberPredicateAssembly:(TDAssembly *)a {
    NSNumber *value = [a pop];
    NSString *key = [a pop];
    [a push:[NSPredicate predicateWithFormat:@"%K = %@", key, value]];
}


- (void)workOnEqBoolPredicateAssembly:(TDAssembly *)a {
    NSPredicate *p = [a pop];
    NSString *key = [a pop];
    [a push:[NSPredicate predicateWithFormat:@"%K = %d", key, [p evaluateWithObject:nil]]];
}


- (void)workOnNeStringPredicateAssembly:(TDAssembly *)a {
    NSString *value = [a pop];
    NSString *key = [a pop];
    [a push:[NSPredicate predicateWithFormat:@"%K != %@", key, value]];
}

        
- (void)workOnNeNumberPredicateAssembly:(TDAssembly *)a {
    NSNumber *value = [a pop];
    NSString *key = [a pop];
    [a push:[NSPredicate predicateWithFormat:@"%K != %@", key, value]];
}


- (void)workOnNeBoolPredicateAssembly:(TDAssembly *)a {
    NSPredicate *p = [a pop];
    NSString *key = [a pop];
    [a push:[NSPredicate predicateWithFormat:@"%K != %d", key, [p evaluateWithObject:nil]]];
}


- (void)workOnGtPredicateAssembly:(TDAssembly *)a {
    id value = [a pop];
    NSString *key = [a pop];
    [a push:[NSPredicate predicateWithFormat:@"%K > %@", key, value]];
}


- (void)workOnGteqPredicateAssembly:(TDAssembly *)a {
    id value = [a pop];
    NSString *key = [a pop];
    [a push:[NSPredicate predicateWithFormat:@"%K >= %@", key, value]];
}


- (void)workOnLtPredicateAssembly:(TDAssembly *)a {
    id value = [a pop];
    NSString *key = [a pop];
    [a push:[NSPredicate predicateWithFormat:@"%K < %@", key, value]];
}


- (void)workOnLteqPredicateAssembly:(TDAssembly *)a {
    id value = [a pop];
    NSString *key = [a pop];
    [a push:[NSPredicate predicateWithFormat:@"%K <= %@", key, value]];
}


- (void)workOnBeginswithPredicateAssembly:(TDAssembly *)a {
    NSString *value = [a pop];
    NSString *key = [a pop];
    [a push:[NSPredicate predicateWithFormat:@"%K BEGINSWITH %@", key, value]];
}


- (void)workOnContainsPredicateAssembly:(TDAssembly *)a {
    NSString *value = [a pop];
    NSString *key = [a pop];
    [a push:[NSPredicate predicateWithFormat:@"%K CONTAINS %@", key, value]];
}


- (void)workOnEndswithPredicateAssembly:(TDAssembly *)a {
    NSString *value = [a pop];
    NSString *key = [a pop];
    [a push:[NSPredicate predicateWithFormat:@"%K ENDSWITH %@", key, value]];
}


- (void)workOnMatchesPredicateAssembly:(TDAssembly *)a {
    NSString *value = [a pop];
    NSString *key = [a pop];
    [a push:[NSPredicate predicateWithFormat:@"%K MATCHES %@", key, value]];
}


- (void)workOnAttrAssembly:(TDAssembly *)a {
    [a push:[[a pop] stringValue]];
}


- (void)workOnNegatedValueAssembly:(TDAssembly *)a {
    id p = [a pop];
    [a push:[NSCompoundPredicate notPredicateWithSubpredicate:p]];
}


- (void)workOnBoolAssembly:(TDAssembly *)a {
    NSNumber *b = [a pop];
    [a push:[NSPredicate predicateWithValue:[b boolValue]]];
}


- (void)workOnTrueAssembly:(TDAssembly *)a {
    [a push:[NSNumber numberWithBool:YES]];
}


- (void)workOnFalseAssembly:(TDAssembly *)a {
    [a push:[NSNumber numberWithBool:NO]];
}


- (void)workOnStringAssembly:(TDAssembly *)a {
    NSLog(@"%s", __PRETTY_FUNCTION__);

}


- (void)workOnQuotedStringAssembly:(TDAssembly *)a {
    NSString *s = [[[a pop] stringValue] stringByTrimmingQuotes];
    [a push:s];
}


- (void)workOnUnquotedStringWordAssembly:(TDAssembly *)a {
    TDToken *fence = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:@"." floatValue:0.0];
    TDToken *tok = [a pop];
    [a push:fence];
    [a push:tok.stringValue];
}


- (void)workOnUnquotedStringAssembly:(TDAssembly *)a {
    TDToken *fence = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:@"." floatValue:0.0];
    NSMutableArray *wordStrings = [NSMutableArray array];

    while (1) {
        NSArray *objs = [a objectsAbove:fence];
        id next = [a pop]; // is the next obj a fence?
        if (![fence isEqualTo:next]) {
            if (next) {
                [a push:next];
            }
            for (id obj in [objs reverseObjectEnumerator]) {
                [a push:obj];
            }
            break;
        }
        NSAssert(1 == objs.count, @"");
        [wordStrings addObject:[objs objectAtIndex:0]];
    }
    
    NSInteger last = wordStrings.count - 1;
    NSInteger i = 0;
    NSMutableString *ms = [NSMutableString string];
    for (NSString *wordString in [wordStrings reverseObjectEnumerator]) {
        if (i++ == last) {
            [ms appendString:wordString];
        } else {
            [ms appendFormat:@"%@ ", wordString];
        }
    }
    [a push:[[ms copy] autorelease]];
}


- (void)workOnNumberAssembly:(TDAssembly *)a {
    NSNumber *n = [NSNumber numberWithFloat:[[a pop] floatValue]];
    [a push:n];
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
@synthesize quotedStringParser;
@synthesize unquotedStringParser;
@synthesize numberParser;
@end
