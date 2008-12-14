//
//  TDGrammarParserFactory.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/12/08.
//  Copyright 2008 Todd Ditchendorf All rights reserved.
//

#import "TDGrammarParserFactory.h"
#import "NSString+TDParseKitAdditions.h"

@interface TDGrammarParserFactory ()
- (TDSequence *)parserForExpression:(NSString *)s;

@property (retain) TDTokenizer *tokenizer;
@property (retain) TDToken *eqTok;
@property (retain) TDCollectionParser *statementParser;
@property (retain) TDCollectionParser *expressionParser;
@property (retain) TDCollectionParser *termParser;
@property (retain) TDCollectionParser *orTermParser;
@property (retain) TDCollectionParser *factorParser;
@property (retain) TDCollectionParser *nextFactorParser;
@property (retain) TDCollectionParser *phraseParser;
@property (retain) TDCollectionParser *phraseStarParser;
@property (retain) TDCollectionParser *phrasePlusParser;
@property (retain) TDCollectionParser *phraseQuestionParser;
@property (retain) TDCollectionParser *atomicValueParser;
@property (retain) TDParser *literalParser;
@property (retain) TDParser *variableParser;
@property (retain) TDParser *constantParser;
@property (retain) TDParser *numParser;
@end

@implementation TDGrammarParserFactory

+ (id)factory {
    return [[[TDGrammarParserFactory alloc] init] autorelease];
}


- (id)init {
    self = [super init];
    if (self) {
        self.eqTok = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:@"=" floatValue:0.0f];
    }
    return self;
}


- (void)dealloc {
    self.tokenizer = nil;
    self.eqTok = nil;
    self.statementParser = nil;
    self.expressionParser = nil;
    self.termParser = nil;
    self.orTermParser = nil;
    self.factorParser = nil;
    self.nextFactorParser = nil;
    self.phraseParser = nil;
    self.phraseStarParser = nil;
    self.phrasePlusParser = nil;
    self.phraseQuestionParser = nil;
    self.atomicValueParser = nil;
    self.literalParser = nil;
    self.variableParser = nil;
    self.constantParser = nil;
    self.numParser = nil;
    [super dealloc];
}


- (TDParser *)parserForGrammar:(NSString *)s {
    self.tokenizer.string = s;
    
    TDTokenArraySource *src = [[TDTokenArraySource alloc] initWithTokenizer:self.tokenizer delimiter:@";"];
    id target = [NSMutableDictionary dictionary]; // setup the variable lookup table

    while ([src hasMore]) {
        NSArray *toks = [src nextTokenArray];
        TDAssembly *a = [TDTokenAssembly assemblyWithTokenArray:toks];
        a.target = target;
        a = [self.statementParser completeMatchFor:a];
        target = a.target;
    }

    [src release];

    TDCollectionParser *start = [target objectForKey:@"start"];

    if (start && [start isKindOfClass:[TDParser class]]) {
        return start;
    } else {
        [NSException raise:@"GrammarException" format:@"The provided language grammar was invalid"];
        return nil;
    }
}


- (TDSequence *)parserForExpression:(NSString *)s {
    TDGrammarParserFactory *p = [[[TDGrammarParserFactory alloc] init] autorelease];
    p.tokenizer.string = s;
    TDSequence *seq = [TDSequence sequence];
    [seq add:p.expressionParser];
    TDAssembly *a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    a.target = [NSMutableDictionary dictionary]; // setup the variable lookup table
    a = [seq completeMatchFor:a];
    return [a pop];
}


- (TDTokenizer *)tokenizer {
    if (!tokenizer) {
        self.tokenizer = [TDTokenizer tokenizer];
        // customize here
    }
    return tokenizer;
}

// phraseCardinality    = phrase cardinality
// cardinality          = '{' cardinalityContent '}'
// cardinalityContent   = num ',' | num ',' num | ',' num
// num                  = Num

// start                = statement*
// satement             = LowercaseWord '=' expression
// expression           = term orTerm*
// term                 = factor nextFactor*
// orTerm               = '|' term
// factor               = phrase | phraseStar | phrasePlus | phraseQuestion
// nextFactor           = factor
// phrase               = atomicValue | '(' expression ')'
// phraseStar           = phrase '*'
// phrasePlus           = phrase '+'
// phraseQuestion       = phrase '?'
// atomicValue          = literal | variable | constant
// literal              = QuotedString
// variable             = LowercaseWord
// constant             = UppercaseWord


// satement             = LowercaseWord '=' expression
- (TDCollectionParser *)statementParser {
    if (!statementParser) {
        self.statementParser = [TDTrack track];
        statementParser.name = @"statement";
        [statementParser add:[TDLowercaseWord word]];
        [statementParser add:[TDSymbol symbolWithString:@"="]];
        [statementParser add:self.expressionParser];
        [statementParser setAssembler:self selector:@selector(workOnStatementAssembly:)];
    }
    return statementParser;
}


// expression        = term orTerm*
- (TDCollectionParser *)expressionParser {
    if (!expressionParser) {
        self.expressionParser = [TDSequence sequence];
        expressionParser.name = @"expression";
        [expressionParser add:self.termParser];
        [expressionParser add:[TDRepetition repetitionWithSubparser:self.orTermParser]];
        [expressionParser setAssembler:self selector:@selector(workOnExpressionAssembly:)];
    }
    return expressionParser;
}


// term                = factor nextFactor*
- (TDCollectionParser *)termParser {
    if (!termParser) {
        self.termParser = [TDSequence sequence];
        termParser.name = @"term";
        [termParser add:self.factorParser];
        [termParser add:[TDRepetition repetitionWithSubparser:self.nextFactorParser]];
    }
    return termParser;
}


// orTerm            = '|' term
- (TDCollectionParser *)orTermParser {
    if (!orTermParser) {
        self.orTermParser = [TDTrack track];
        orTermParser.name = @"orTerm";
        [orTermParser add:[[TDSymbol symbolWithString:@"|"] discard]];
        [orTermParser add:self.termParser];
        [orTermParser setAssembler:self selector:@selector(workOnOrAssembly:)];
    }
    return orTermParser;
}


// factor            = phrase | phraseStar | phrasePlus | phraseQuestion
- (TDCollectionParser *)factorParser {
    if (!factorParser) {
        self.factorParser = [TDAlternation alternation];
        factorParser.name = @"factor";
        [factorParser add:self.phraseParser];
        [factorParser add:self.phraseStarParser];
        [factorParser add:self.phrasePlusParser];
        [factorParser add:self.phraseQuestionParser];
    }
    return factorParser;
}


// nextFactor        = factor
- (TDCollectionParser *)nextFactorParser {
    if (!nextFactorParser) {
        self.nextFactorParser = [TDAlternation alternation];
        nextFactorParser.name = @"nextFactor";
        [nextFactorParser add:self.phraseParser];
        [nextFactorParser add:self.phraseStarParser];
        [nextFactorParser add:self.phrasePlusParser];
        [nextFactorParser add:self.phraseQuestionParser];
    }
    return nextFactorParser;
}


// phrase            = atomicValue | '(' expression ')'
- (TDCollectionParser *)phraseParser {
    if (!phraseParser) {
        self.phraseParser = [TDAlternation alternation];
        phraseParser.name = @"phrase";
        [phraseParser add:self.atomicValueParser];

        TDTrack *t = [TDTrack track];
        [t add:[[TDSymbol symbolWithString:@"("] discard]];
        [t add:self.expressionParser];
        [t add:[[TDSymbol symbolWithString:@")"] discard]];
        [phraseParser add:t];
    }
    return phraseParser;
}


// phraseStar        = phrase '*'
- (TDCollectionParser *)phraseStarParser {
    if (!phraseStarParser) {
        self.phraseStarParser = [TDSequence sequence];
        phraseStarParser.name = @"phraseStar";
        [phraseStarParser add:self.phraseParser];
        [phraseStarParser add:[[TDSymbol symbolWithString:@"*"] discard]];
        [phraseStarParser setAssembler:self selector:@selector(workOnStarAssembly:)];
    }
    return phraseStarParser;
}


// phrasePlus        = phrase '+'
- (TDCollectionParser *)phrasePlusParser {
    if (!phrasePlusParser) {
        self.phrasePlusParser = [TDSequence sequence];
        phrasePlusParser.name = @"phrasePlus";
        [phrasePlusParser add:self.phraseParser];
        [phrasePlusParser add:[[TDSymbol symbolWithString:@"+"] discard]];
        [phrasePlusParser setAssembler:self selector:@selector(workOnPlusAssembly:)];
    }
    return phrasePlusParser;
}


// phrasePlus        = phrase '?'
- (TDCollectionParser *)phraseQuestionParser {
    if (!phraseQuestionParser) {
        self.phraseQuestionParser = [TDSequence sequence];
        phraseQuestionParser.name = @"phraseQuestion";
        [phraseQuestionParser add:self.phraseParser];
        [phraseQuestionParser add:[[TDSymbol symbolWithString:@"?"] discard]];
        [phraseQuestionParser setAssembler:self selector:@selector(workOnQuestionAssembly:)];
    }
    return phraseQuestionParser;
}


// atomicValue    = QuotedString | variable | constant
- (TDCollectionParser *)atomicValueParser {
    if (!atomicValueParser) {
        self.atomicValueParser = [TDAlternation alternation];
        atomicValueParser.name = @"atomicValue";
        [atomicValueParser add:self.literalParser];
        [atomicValueParser add:self.variableParser];
        [atomicValueParser add:self.constantParser];
    }
    return atomicValueParser;
}


// literal = QuotedString
- (TDParser *)literalParser {
    if (!literalParser) {
        self.literalParser = [TDQuotedString quotedString];
        [literalParser setAssembler:self selector:@selector(workOnLiteralAssembly:)];
    }
    return literalParser;
}


// variable = LowercaseWord
- (TDParser *)variableParser {
    if (!variableParser) {
        self.variableParser = [TDLowercaseWord word];
        [variableParser setAssembler:self selector:@selector(workOnVariableAssembly:)];
    }
    return variableParser;
}


// constant = UppercaseWord
- (TDParser *)constantParser {
    if (!constantParser) {
        self.constantParser = [TDUppercaseWord word];
        [constantParser setAssembler:self selector:@selector(workOnConstantAssembly:)];
    }
    return constantParser;
}


// num = Num
- (TDParser *)numParser {
    if (!numParser) {
        self.numParser = [TDNum num];
        [numParser setAssembler:self selector:@selector(workOnNumAssembly:)];
    }
    return numParser;
}


- (void)workOnStatementAssembly:(TDAssembly *)a {
    TDParser *p = [a pop];
    //NSAssert([p isKindOfClass:[TDParser class]], @"");

    TDToken *tok = [a pop]; // discard
    //NSAssert(tok.isSymbol, @"");
    //NSAssert([tok.stringValue isEqualToString:@"="], @"");
    
    tok = [a pop];
    //NSAssert(tok.isWord, @"");

    //NSAssert(a.target, @"");
    //NSAssert([a.target isKindOfClass:[NSMutableDictionary class]], @"");
    [a.target setObject:p forKey:tok.stringValue];
}


- (void)workOnExpressionAssembly:(TDAssembly *)a {
    //NSAssert(![a isStackEmpty], @"");
    NSArray *objs = [a objectsAbove:eqTok];
    //NSAssert(objs.count, @"");
    if (objs.count > 1) {
        TDSequence *seq = [TDSequence sequence];
        NSEnumerator *e = [objs reverseObjectEnumerator];
        id obj = nil;
        while (obj = [e nextObject]) {
            //NSAssert([obj isKindOfClass:[TDParser class]], @"");
            [seq add:obj];
        }
        [a push:seq];
    } else if (objs.count) {
        TDParser *p = [objs objectAtIndex:0];
        //NSAssert([p isKindOfClass:[TDParser class]], @"");
        [a push:p];
    }
}


- (void)workOnLiteralAssembly:(TDAssembly *)a {
    TDToken *tok = [a pop];
    //NSAssert(tok.isQuotedString, @"");
    NSString *s = [tok.stringValue stringByRemovingFirstAndLastCharacters];
    [a push:[TDLiteral literalWithString:s]];
}


- (void)workOnVariableAssembly:(TDAssembly *)a {
    NSLog(@"%s", _cmd);
    NSLog(@"a: %@", a);
    TDToken *tok = [a pop];
    //NSAssert(tok.isWord, @"");
    //NSAssert(a.target, @"");
    TDParser *p = [a.target objectForKey:tok.stringValue];
    ////NSAssert([p isKindOfClass:[TDParser class]], @"");
    [a push:p];
}


- (void)workOnConstantAssembly:(TDAssembly *)a {
    TDToken *tok = [a pop];
    //NSAssert(tok.isWord, @"");
    NSString *s = tok.stringValue;
    TDParser *p = nil;
    if ([s isEqualToString:@"Word"]) {
        p = [TDWord word];
    } else if ([s isEqualToString:@"Num"]) {
        p = [TDNum num];
    } else if ([s isEqualToString:@"QuotedString"]) {
        p = [TDQuotedString quotedString];
    } else if ([s isEqualToString:@"Symbol"]) {
        p = [TDSymbol symbol];
    } else {
        [NSException raise:@"Grammar Exception" format:
         @"User Grammar referenced a constant parser name (uppercase word) which is not supported: %@. Must be one of: Word, QuotedString, Num, Symbol.", s];
    }
    [a push:p];
}


- (void)workOnNumAssembly:(TDAssembly *)a {
    TDToken *tok = [a pop];
    //NSAssert(tok.isNumber, @"");
    [a push:[TDLiteral literalWithString:tok.stringValue]];
}


- (void)workOnStarAssembly:(TDAssembly *)a {
    id top = [a pop];
    //NSAssert([top isKindOfClass:[TDParser class]], @"");
    TDRepetition *rep = [TDRepetition repetitionWithSubparser:top];
    [a push:rep];
}


- (void)workOnPlusAssembly:(TDAssembly *)a {
    id top = [a pop];
    //NSAssert([top isKindOfClass:[TDParser class]], @"");
    TDSequence *seq = [TDSequence sequence];
    [seq add:top];
    [seq add:[TDRepetition repetitionWithSubparser:top]];
    [a push:seq];
}


- (void)workOnQuestionAssembly:(TDAssembly *)a {
    id top = [a pop];
    //NSAssert([top isKindOfClass:[TDParser class]], @"");
    TDAlternation *alt = [TDAlternation alternation];
    [alt add:[TDEmpty empty]];
    [alt add:top];
    [a push:alt];
}


- (void)workOnOrAssembly:(TDAssembly *)a {
    id second = [a pop];
    id first = [a pop];
    //NSAssert([first isKindOfClass:[TDParser class]], @"");
    //NSAssert([second isKindOfClass:[TDParser class]], @"");
    TDAlternation *p = [TDAlternation alternation];
    [p add:first];
    [p add:second];
    [a push:p];
}

@synthesize tokenizer;
@synthesize eqTok;
@synthesize statementParser;
@synthesize expressionParser;
@synthesize termParser;
@synthesize orTermParser;
@synthesize factorParser;
@synthesize nextFactorParser;
@synthesize phraseParser;
@synthesize phraseStarParser;
@synthesize phrasePlusParser;
@synthesize phraseQuestionParser;
@synthesize atomicValueParser;
@synthesize literalParser;
@synthesize variableParser;
@synthesize constantParser;
@synthesize numParser;
@end
