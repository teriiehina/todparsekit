//
//  TDNSPredicateBuilder.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/27/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDNSPredicateBuilder.h"
#import "NSString+TDParseKitAdditions.h"

// expr                 = term orTerm*;
// orTerm               = 'or' term;
// term                 = primaryExpr andPrimaryExpr*;
// andPrimaryExpr       = 'and' primaryExpr;
// primaryExpr          = phrase | '(' expr ')';
// phrase               = predicate | negatedPredicate;
// negatedPredicate     = 'not' predicate;
// predicate            = completePredicate | attrValuePredicate | attrPredicate | valuePredicate;
// completePredicate    = attr relation value;
// attrValuePredicate   = attr value;
// attrPredicate        = attr;
// valuePredicate       = value;
// attr                 = tag | Word;
// tag                  = '@' Word;
// value                = string | Num | bool;
// string               = QuotedString | unquotedString;
// unquotedString       = nonReservedWord+;
// bool                 = 'true' | 'false';

@interface TDNSPredicateBuilder ()
@property (nonatomic, retain) TDToken *nonReservedWordFence;
@end

@implementation TDNSPredicateBuilder

- (id)init {
    if (self = [super init]) {
        self.defaultAttr = @"content";
        self.defaultRelation = @"=";
        self.defaultValue = @"";
        self.nonReservedWordFence = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:@"." floatValue:0.0];
    }
    return self;
}


- (void)dealloc {
    self.defaultAttr = nil;
    self.defaultRelation = nil;
    self.defaultValue = nil;
    self.nonReservedWordFence = nil;
    self.exprParser = nil;
    self.orTermParser = nil;
    self.termParser = nil;
    self.andPrimaryExprParser = nil;
    self.primaryExprParser = nil;
    self.phraseParser = nil;
    self.negatedPredicateParser = nil;
    self.predicateParser = nil;
    self.completePredicateParser = nil;
    self.attrValuePredicateParser = nil;
    self.attrPredicateParser = nil;
    self.valuePredicateParser = nil;
    self.attrParser = nil;
    self.tagParser = nil;
    self.relationParser = nil;
    self.valueParser = nil;
    self.boolParser = nil;
    self.trueParser = nil;
    self.falseParser = nil;
    self.stringParser = nil;
    self.quotedStringParser = nil;
    self.unquotedStringParser = nil;
    self.reservedWordParser = nil;
    self.nonReservedWordParser = nil;
    self.reservedWordPattern = nil;
    self.numberParser = nil;
    [super dealloc];
}


- (NSPredicate *)buildFrom:(NSString *)s; {
    PKAssembly *a = [TDTokenAssembly assemblyWithString:s];
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
        orTermParser.name = @"orTerm";
        [orTermParser add:[[TDCaseInsensitiveLiteral literalWithString:@"or"] discard]];
        [orTermParser add:self.termParser];
        [orTermParser setAssembler:self selector:@selector(workOnOr:)];
    }
    return orTermParser;
}


// term             = primaryExpr andPrimaryExpr*
- (TDCollectionParser *)termParser {
    if (!termParser) {
        self.termParser = [TDSequence sequence];
        termParser.name = @"term";
        [termParser add:self.primaryExprParser];
        [termParser add:[TDRepetition repetitionWithSubparser:self.andPrimaryExprParser]];
    }
    return termParser;
}


// andPrimaryExpr        = 'and' primaryExpr
- (TDCollectionParser *)andPrimaryExprParser {
    if (!andPrimaryExprParser) {
        self.andPrimaryExprParser = [TDSequence sequence];
        andPrimaryExprParser.name = @"andPrimaryExpr";
        [andPrimaryExprParser add:[[TDCaseInsensitiveLiteral literalWithString:@"and"] discard]];
        [andPrimaryExprParser add:self.primaryExprParser];
        [andPrimaryExprParser setAssembler:self selector:@selector(workOnAnd:)];
    }
    return andPrimaryExprParser;
}


// primaryExpr           = phrase | '(' expression ')'
- (TDCollectionParser *)primaryExprParser {
    if (!primaryExprParser) {
        self.primaryExprParser = [TDAlternation alternation];
        primaryExprParser.name = @"primaryExpr";
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
        phraseParser.name = @"phrase";
        [phraseParser add:self.predicateParser];
        [phraseParser add:self.negatedPredicateParser];
    }
    return phraseParser;
}


// negatedPredicate      = 'not' predicate
- (TDCollectionParser *)negatedPredicateParser {
    if (!negatedPredicateParser) {
        self.negatedPredicateParser = [TDSequence sequence];
        negatedPredicateParser.name = @"negatedPredicate";
        [negatedPredicateParser add:[[TDCaseInsensitiveLiteral literalWithString:@"not"] discard]];
        [negatedPredicateParser add:self.predicateParser];
        [negatedPredicateParser setAssembler:self selector:@selector(workOnNegatedValue:)];
    }
    return negatedPredicateParser;
}


// predicate         = bool | eqPredicate | nePredicate | gtPredicate | gteqPredicate | ltPredicate | lteqPredicate | beginswithPredicate | containsPredicate | endswithPredicate | matchesPredicate
- (TDCollectionParser *)predicateParser {
    if (!predicateParser) {
        self.predicateParser = [TDAlternation alternation];
        predicateParser.name = @"predicate";
        [predicateParser add:self.completePredicateParser];
        [predicateParser add:self.attrValuePredicateParser];
        [predicateParser add:self.attrPredicateParser];
        [predicateParser add:self.valuePredicateParser];
        [predicateParser setAssembler:self selector:@selector(workOnPredicate:)];
    }
    return predicateParser;
}


// completePredicate    = attribute relation value
- (TDCollectionParser *)completePredicateParser {
    if (!completePredicateParser) {
        self.completePredicateParser = [TDSequence sequence];
        completePredicateParser.name = @"completePredicate";
        [completePredicateParser add:self.attrParser];
        [completePredicateParser add:self.relationParser];
        [completePredicateParser add:self.valueParser];
    }
    return completePredicateParser;
}


// attrValuePredicate    = attribute value
- (TDCollectionParser *)attrValuePredicateParser {
    if (!attrValuePredicateParser) {
        self.attrValuePredicateParser = [TDSequence sequence];
        attrValuePredicateParser.name = @"attrValuePredicate";
        [attrValuePredicateParser add:self.attrParser];
        [attrValuePredicateParser add:self.valueParser];
        [attrValuePredicateParser setAssembler:self selector:@selector(workOnAttrValuePredicate:)];
    }
    return attrValuePredicateParser;
}


// attrPredicate        = attribute
- (TDCollectionParser *)attrPredicateParser {
    if (!attrPredicateParser) {
        self.attrPredicateParser = [TDSequence sequence];
        attrPredicateParser.name = @"attrPredicate";
        [attrPredicateParser add:self.attrParser];
        [attrPredicateParser setAssembler:self selector:@selector(workOnAttrPredicate:)];
    }
    return attrPredicateParser;
}


// valuePredicate        = value
- (TDCollectionParser *)valuePredicateParser {
    if (!valuePredicateParser) {
        self.valuePredicateParser = [TDSequence sequence];
        valuePredicateParser.name = @"valuePredicate";
        [valuePredicateParser add:self.valueParser];
        [valuePredicateParser setAssembler:self selector:@selector(workOnValuePredicate:)];
    }
    return valuePredicateParser;
}

    
// attr                 = tag | 'uniqueid' | 'line' | 'type' | 'isgroupheader' | 'level' | 'index' | 'content' | 'parent' | 'project' | 'countofchildren'
- (TDCollectionParser *)attrParser {
    if (!attrParser) {
        self.attrParser = [TDAlternation alternation];
        attrParser.name = @"attr";
        [attrParser add:self.tagParser];
        [attrParser add:self.nonReservedWordParser];
        [attrParser setAssembler:self selector:@selector(workOnAttr:)];
    }
    return attrParser;
}


// relation                = '=' | '!=' | '>' | '>=' | '<' | '<=' | 'beginswith' | 'contains' | 'endswith' | 'matches'
- (TDCollectionParser *)relationParser {
    if (!relationParser) {
        self.relationParser = [TDAlternation alternation];
        relationParser.name = @"relation";
        [relationParser add:[TDSymbol symbolWithString:@"="]];
        [relationParser add:[TDSymbol symbolWithString:@"!="]];
        [relationParser add:[TDSymbol symbolWithString:@">"]];
        [relationParser add:[TDSymbol symbolWithString:@">="]];
        [relationParser add:[TDSymbol symbolWithString:@"<"]];
        [relationParser add:[TDSymbol symbolWithString:@"<="]];
        [relationParser add:[TDCaseInsensitiveLiteral literalWithString:@"beginswith"]];
        [relationParser add:[TDCaseInsensitiveLiteral literalWithString:@"contains"]];
        [relationParser add:[TDCaseInsensitiveLiteral literalWithString:@"endswith"]];
        [relationParser add:[TDCaseInsensitiveLiteral literalWithString:@"matches"]];
        [relationParser setAssembler:self selector:@selector(workOnRelation:)];
    }
    return relationParser;
}


// tag                  = '@' Word
- (TDCollectionParser *)tagParser {
    if (!tagParser) {
        self.tagParser = [TDSequence sequence];
        tagParser.name = @"tag";
        [tagParser add:[[TDSymbol symbolWithString:@"@"] discard]];
        [tagParser add:[TDWord word]];
    }
    return tagParser;
}


// value                = QuotedString | Num | bool
- (TDCollectionParser *)valueParser {
    if (!valueParser) {
        self.valueParser = [TDAlternation alternation];
        valueParser.name = @"value";
        [valueParser add:self.stringParser];
        [valueParser add:self.numberParser];
        [valueParser add:self.boolParser];
    }
    return valueParser;
}


- (TDCollectionParser *)boolParser {
    if (!boolParser) {
        self.boolParser = [TDAlternation alternation];
        boolParser.name = @"bool";
        [boolParser add:self.trueParser];
        [boolParser add:self.falseParser];
        [boolParser setAssembler:self selector:@selector(workOnBool:)];
    }
    return boolParser;
}


- (TDParser *)trueParser {
    if (!trueParser) {
        self.trueParser = [[TDCaseInsensitiveLiteral literalWithString:@"true"] discard];
        trueParser.name = @"true";
        [trueParser setAssembler:self selector:@selector(workOnTrue:)];
    }
    return trueParser;
}


- (TDParser *)falseParser {
    if (!falseParser) {
        self.falseParser = [[TDCaseInsensitiveLiteral literalWithString:@"false"] discard];
        falseParser.name = @"false";
        [falseParser setAssembler:self selector:@selector(workOnFalse:)];
    }
    return falseParser;
}


// string               = quotedString | unquotedString
- (TDCollectionParser *)stringParser {
    if (!stringParser) {
        self.stringParser = [TDAlternation alternation];
        stringParser.name = @"string";
        [stringParser add:self.quotedStringParser];
        [stringParser add:self.unquotedStringParser];
    }
    return stringParser;
}


// quotedString         = QuotedString
- (TDParser *)quotedStringParser {
    if (!quotedStringParser) {
        self.quotedStringParser = [TDQuotedString quotedString];
        quotedStringParser.name = @"quotedString";
        [quotedStringParser setAssembler:self selector:@selector(workOnQuotedString:)];
    }
    return quotedStringParser;
}


// unquotedString       = nonReservedWord+
- (TDCollectionParser *)unquotedStringParser {
    if (!unquotedStringParser) {
        self.unquotedStringParser = [TDSequence sequence];
        unquotedStringParser.name = @"unquotedString";
        [unquotedStringParser add:self.nonReservedWordParser];
        [unquotedStringParser add:[TDRepetition repetitionWithSubparser:self.nonReservedWordParser]];
        [unquotedStringParser setAssembler:self selector:@selector(workOnUnquotedString:)];
    }
    return unquotedStringParser;
}


- (TDCollectionParser *)reservedWordParser {
    if (!reservedWordParser) {
        self.reservedWordParser = [TDIntersection intersection];
        [reservedWordParser add:[TDWord word]];
        [reservedWordParser add:self.reservedWordPattern];
        reservedWordParser.name = @"reservedWord";
        [reservedWordParser setAssembler:self selector:@selector(workOnReservedWord:)];
    }
    return reservedWordParser;
}


// nonReservedWord      = Word
- (TDCollectionParser *)nonReservedWordParser {
    if (!nonReservedWordParser) {
        self.nonReservedWordParser = [TDExclusion exclusion];
        [nonReservedWordParser add:[TDWord word]];
        [nonReservedWordParser add:self.reservedWordPattern];
        nonReservedWordParser.name = @"nonReservedWord";
        [nonReservedWordParser setAssembler:self selector:@selector(workOnNonReservedWord:)];
    }
    return nonReservedWordParser;
}


- (TDPattern *)reservedWordPattern {
    if (!reservedWordPattern) {
        NSString *s = @"true|false|and|or|not|contains|beginswith|endswith|matches";
        self.reservedWordPattern = [TDPattern patternWithString:s options:TDPatternOptionsIgnoreCase];
        reservedWordPattern.name = @"reservedWordPattern";
    }
    return reservedWordPattern;
}


- (TDParser *)numberParser {
    if (!numberParser) {
        self.numberParser = [TDNum num];
        numberParser.name = @"number";
        [numberParser setAssembler:self selector:@selector(workOnNumber:)];
    }
    return numberParser;
}


- (void)workOnAnd:(PKAssembly *)a {
    NSPredicate *p2 = [a pop];
    NSPredicate *p1 = [a pop];
    NSArray *subs = [NSArray arrayWithObjects:p1, p2, nil];
    [a push:[NSCompoundPredicate andPredicateWithSubpredicates:subs]];
}


- (void)workOnOr:(PKAssembly *)a {
    NSPredicate *p2 = [a pop];
    NSPredicate *p1 = [a pop];
    NSArray *subs = [NSArray arrayWithObjects:p1, p2, nil];
    [a push:[NSCompoundPredicate orPredicateWithSubpredicates:subs]];
}


- (void)workOnPredicate:(PKAssembly *)a {
    id value = [a pop];
    id relation = [a pop];
    id attr = [a pop];
    NSString *predicateFormat = [NSString stringWithFormat:@"%@ %@ %%@", attr, relation, nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, value, nil];
    [a push:predicate];
}


- (void)workOnAttrValuePredicate:(PKAssembly *)a {
    id value = [a pop];
    id attr = [a pop];
    [a push:attr];
    [a push:defaultRelation];
    [a push:value];
}


- (void)workOnAttrPredicate:(PKAssembly *)a {
    id attr = [a pop];
    [a push:attr];
    [a push:defaultRelation];
    [a push:defaultValue];
}


- (void)workOnValuePredicate:(PKAssembly *)a {
    id value = [a pop];
    [a push:defaultAttr];
    [a push:defaultRelation];
    [a push:value];
}


- (void)workOnAttr:(PKAssembly *)a {
    [a push:[[a pop] stringValue]];
}


- (void)workOnRelation:(PKAssembly *)a {
    [a push:[[a pop] stringValue]];
}


- (void)workOnNegatedValue:(PKAssembly *)a {
    id p = [a pop];
    [a push:[NSCompoundPredicate notPredicateWithSubpredicate:p]];
}


- (void)workOnBool:(PKAssembly *)a {
    NSNumber *b = [a pop];
    [a push:[NSPredicate predicateWithValue:[b boolValue]]];
}


- (void)workOnTrue:(PKAssembly *)a {
    [a push:[NSNumber numberWithBool:YES]];
}


- (void)workOnFalse:(PKAssembly *)a {
    [a push:[NSNumber numberWithBool:NO]];
}


- (void)workOnQuotedString:(PKAssembly *)a {
    [a push:[[[a pop] stringValue] stringByTrimmingQuotes]];
}


- (void)workOnReservedWord:(PKAssembly *)a {
//    TDToken *tok = [a pop];
//    [a push:tok.stringValue];
}


- (void)workOnNonReservedWord:(PKAssembly *)a {
//    id obj = [a pop];
//    [a push:nonReservedWordFence];
//    [a push:obj];
}


- (void)workOnUnquotedString:(PKAssembly *)a {
    NSMutableArray *wordStrings = [NSMutableArray array];

    while (1) {
        NSArray *objs = [a objectsAbove:nonReservedWordFence];
        id next = [a pop]; // is the next obj a fence?
        if (![nonReservedWordFence isEqualTo:next]) {
            // if not, put the next token back
            if (next) {
                [a push:next];
            }
            // also put back any toks we didnt mean to pop
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


- (void)workOnNumber:(PKAssembly *)a {
    NSNumber *n = [NSNumber numberWithFloat:[[a pop] floatValue]];
    [a push:n];
}

@synthesize defaultAttr;
@synthesize defaultRelation;
@synthesize defaultValue;
@synthesize nonReservedWordFence;
@synthesize exprParser;
@synthesize orTermParser;
@synthesize termParser;
@synthesize andPrimaryExprParser;
@synthesize primaryExprParser;
@synthesize phraseParser;
@synthesize negatedPredicateParser;
@synthesize predicateParser;
@synthesize completePredicateParser;
@synthesize attrValuePredicateParser;
@synthesize attrPredicateParser;
@synthesize valuePredicateParser;
@synthesize attrParser;
@synthesize tagParser;
@synthesize relationParser;
@synthesize valueParser;
@synthesize boolParser;
@synthesize trueParser;
@synthesize falseParser;
@synthesize stringParser;
@synthesize quotedStringParser;
@synthesize unquotedStringParser;
@synthesize reservedWordParser;
@synthesize nonReservedWordParser;
@synthesize reservedWordPattern;
@synthesize numberParser;
@end
