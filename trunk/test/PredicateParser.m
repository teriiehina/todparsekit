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

// attr                 = tag | 'uniqueid' | 'line' | 'type' | 'isgroupheader' | 'level' | 'index' | 'content' | 'parent' | 'project' | 'countofchildren'
// tag                  = '@' Any
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
    self.attrParser = nil;
    self.tagParser = nil;
    self.eqPredicateParser = nil;
    self.nePredicateParser = nil;
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
        [predicateParser add:self.eqPredicateParser];
        [predicateParser add:self.nePredicateParser];
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
//        [attrParser add:[TDLiteral literalWithString:@"uniqueid"]];
//        [attrParser add:[TDLiteral literalWithString:@"line"]];
//        [attrParser add:[TDLiteral literalWithString:@"type"]];
//        [attrParser add:[TDLiteral literalWithString:@"isgroupheader"]];
//        [attrParser add:[TDLiteral literalWithString:@"level"]];
//        [attrParser add:[TDLiteral literalWithString:@"index"]];
//        [attrParser add:[TDLiteral literalWithString:@"content"]];
//        [attrParser add:[TDLiteral literalWithString:@"parent"]];
//        [attrParser add:[TDLiteral literalWithString:@"project"]];
//        [attrParser add:[TDLiteral literalWithString:@"countofchildren"]];
    }
    return attrParser;
}


// tag                  = '@' Any
- (TDCollectionParser *)tagParser {
    if (!tagParser) {
        self.tagParser = [TDSequence sequence];
        [tagParser add:[TDSymbol symbolWithString:@"@"]];
    }
    return tagParser;
}


// eqPredicate          = attr '=' value
- (TDCollectionParser *)eqPredicateParser {
    if (!eqPredicateParser) {
        self.eqPredicateParser = [TDSequence sequence];
        [eqPredicateParser add:self.attrParser];
        [eqPredicateParser add:[[TDSymbol symbolWithString:@"="] discard]];
        [eqPredicateParser add:self.valueParser];
        [eqPredicateParser setAssembler:self selector:@selector(workOnEqPredicateAssembly:)];
    }
    return eqPredicateParser;
}


// nePredicate          = attr '!=' value
- (TDCollectionParser *)nePredicateParser {
    if (!nePredicateParser) {
        self.nePredicateParser = [TDSequence sequence];
        [nePredicateParser add:self.attrParser];
        [nePredicateParser add:[[TDSymbol symbolWithString:@"!="] discard]];
        [nePredicateParser add:self.valueParser];
        [nePredicateParser setAssembler:self selector:@selector(workOnNePredicateAssembly:)];
    }
    return nePredicateParser;
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
        [beginswithPredicateParser add:[[TDLiteral literalWithString:@"beginswith"] discard]];
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
        [containsPredicateParser add:[[TDLiteral literalWithString:@"contains"] discard]];
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
        [endswithPredicateParser add:[[TDLiteral literalWithString:@"endswith"] discard]];
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
        [matchesPredicateParser add:[[TDLiteral literalWithString:@"matches"] discard]];
        [matchesPredicateParser add:self.valueParser];
        [matchesPredicateParser setAssembler:self selector:@selector(workOnMatchesPredicateAssembly:)];
    }
    return matchesPredicateParser;
}


// value                = QuotedString | Num | bool
- (TDCollectionParser *)valueParser {
    if (!valueParser) {
        self.valueParser = [TDAlternation alternation];
        [valueParser add:[TDQuotedString quotedString]];
        [valueParser add:[TDNum num]];
        [valueParser add:self.boolParser];
    }
    return valueParser;
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
    NSLog(@"%s", __PRETTY_FUNCTION__);
    id p2 = [a pop];
    id p1 = [a pop];
    NSArray *subs = [NSArray arrayWithObjects:p1, p2, nil];
    [a push:[NSCompoundPredicate andPredicateWithSubpredicates:subs]];
}


- (void)workOnOrAssembly:(TDAssembly *)a {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    id p2 = [a pop];
    id p1 = [a pop];
    NSArray *subs = [NSArray arrayWithObjects:p1, p2, nil];
    [a push:[NSCompoundPredicate orPredicateWithSubpredicates:subs]];
}


- (void)workOnEqPredicateAssembly:(TDAssembly *)a {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    id value = [a pop];
    id attrKey = [[a pop] stringValue];
    
    BOOL yn = NO;
    id actualValue = [delegate valueForAttributeKey:attrKey];

    NSLog(@"value: %@", value);
    NSLog(@"actualValue: %@", actualValue);

    if ([actualValue isKindOfClass:[NSNumber class]]) {
        yn = [actualValue isEqualToNumber:[NSNumber numberWithFloat:[value floatValue]]];
    } else {
        yn = [actualValue isEqual:value];
    }
    NSLog(@"isEqual: %d", yn);
    [a push:[NSPredicate predicateWithValue:yn]];
}

        
- (void)workOnNePredicateAssembly:(TDAssembly *)a {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    id value = [a pop];
    id attrKey = [[a pop] stringValue];
    BOOL yn = ![[delegate valueForAttributeKey:attrKey] isEqual:value];
    [a push:[NSPredicate predicateWithValue:yn]];
}


- (void)workOnGtPredicateAssembly:(TDAssembly *)a {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    CGFloat value = [[a pop] floatValue];
    id attrKey = [[a pop] stringValue];
    BOOL yn = ([delegate floatForAttributeKey:attrKey] > value);
    NSLog(@"isEqual: %d", yn);
    [a push:[NSPredicate predicateWithValue:yn]];
}


- (void)workOnGteqPredicateAssembly:(TDAssembly *)a {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    CGFloat value = [[a pop] floatValue];
    id attrKey = [[a pop] stringValue];
    BOOL yn = ([delegate floatForAttributeKey:attrKey] >= value);
    [a push:[NSPredicate predicateWithValue:yn]];
}


- (void)workOnLtPredicateAssembly:(TDAssembly *)a {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    CGFloat value = [[a pop] floatValue];
    id attrKey = [[a pop] stringValue];
    BOOL yn = ([delegate floatForAttributeKey:attrKey] < value);
    [a push:[NSPredicate predicateWithValue:yn]];
}


- (void)workOnLteqPredicateAssembly:(TDAssembly *)a {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    CGFloat value = [[a pop] floatValue];
    id attrKey = [[a pop] stringValue];
    BOOL yn = ([delegate floatForAttributeKey:attrKey] <= value);
    [a push:[NSPredicate predicateWithValue:yn]];
}


- (void)workOnBeginswithPredicateAssembly:(TDAssembly *)a {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSString *value = [[a pop] stringValue];
    id attrKey = [[a pop] stringValue];
    BOOL yn = [[delegate valueForAttributeKey:attrKey] hasPrefix:value];
    [a push:[NSPredicate predicateWithValue:yn]];
}


- (void)workOnContainsPredicateAssembly:(TDAssembly *)a {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSString *value = [[a pop] stringValue];
    id attrKey = [[a pop] stringValue];
    NSRange r = [[delegate valueForAttributeKey:attrKey] rangeOfString:value];
    BOOL yn = (NSNotFound != r.location);
    [a push:[NSPredicate predicateWithValue:yn]];
}


- (void)workOnEndswithPredicateAssembly:(TDAssembly *)a {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSString *value = [[a pop] stringValue];
    id attrKey = [[a pop] stringValue];
    BOOL yn = [[delegate valueForAttributeKey:attrKey] hasSuffix:value];
    [a push:[NSPredicate predicateWithValue:yn]];
}


- (void)workOnMatchesPredicateAssembly:(TDAssembly *)a {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSString *value = [[a pop] stringValue];
    id attrKey = [[a pop] stringValue];
    BOOL yn = [[delegate valueForAttributeKey:attrKey] isEqual:value]; // TODO should this be a regex match?
    [a push:[NSPredicate predicateWithValue:yn]];
}


- (void)workOnNegatedValueAssembly:(TDAssembly *)a {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    id p = [a pop];
    [a push:[NSCompoundPredicate notPredicateWithSubpredicate:p]];
}


- (void)workOnTrueAssembly:(TDAssembly *)a {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [a push:[NSPredicate predicateWithValue:YES]];
}


- (void)workOnFalseAssembly:(TDAssembly *)a {
    NSLog(@"%s", __PRETTY_FUNCTION__);
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
@synthesize attrParser;
@synthesize tagParser;
@synthesize eqPredicateParser;
@synthesize nePredicateParser;
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
@end
