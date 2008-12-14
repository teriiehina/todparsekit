//
//  TDGrammarParser.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/12/08.
//  Copyright 2008 Todd Ditchendorf All rights reserved.
//

#import "TDGrammarParser.h"
#import "NSString+TDParseKitAdditions.h"

@implementation TDGrammarParser

- (id)init {
    self = [super initWithSubparser:self.statementParser];
    if (self) {

    }
    return self;
}


- (void)dealloc {
    self.tokenizer = nil;
    self.statementParser = nil;
    self.declarationParser = nil;
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


+ (TDCollectionParser *)parserForLanguage:(NSString *)s {
    TDGrammarParser *p = [TDGrammarParser parser];
    p.tokenizer.string = s;
    TDAssembly *a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    a.target = [NSMutableDictionary dictionary]; // setup the variable lookup table
    a = [p completeMatchFor:a];
    return [a pop];
}


+ (TDSequence *)parserForExpression:(NSString *)s {
    TDGrammarParser *p = [TDGrammarParser parser];
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
// satement             = declaration '=' expression
// declaration          = 'var' LowercaseWord
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


// satement             = declaration '=' expression
- (TDCollectionParser *)statementParser {
    if (!statementParser) {
        self.statementParser = [TDSequence sequence];
        statementParser.name = @"statement";
        [statementParser add:self.declarationParser];
        [statementParser add:[[TDSymbol symbolWithString:@"="] discard]];
        [statementParser add:self.expressionParser];
//        [statementParser setAssembler:self selector:@selector(workOnStatementAssembly:)];
    }
    return statementParser;
}


// declaration          = 'var' LowercaseWord
- (TDCollectionParser *)declarationParser {
    if (!declarationParser) {
        self.declarationParser = [TDSequence sequence];
        declarationParser.name = @"declaration";
        [declarationParser add:[[TDLiteral literalWithString:@"var"] discard]];
        [declarationParser add:[TDLowercaseWord word]];
//        [declarationParser setAssembler:self selector:@selector(workOnDeclarationAssembly:)];
    }
    return declarationParser;
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
        self.orTermParser = [TDSequence sequence];
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
        //        [nextFactorParser setAssembler:self selector:@selector(workOnAndAssembly:)];
    }
    return nextFactorParser;
}


// phrase            = letterOrDigit | '(' expression ')'
- (TDCollectionParser *)phraseParser {
    if (!phraseParser) {
        TDSequence *s = [TDSequence sequence];
        [s add:[[TDSymbol symbolWithString:@"("] discard]];
        [s add:self.expressionParser];
        [s add:[[TDSymbol symbolWithString:@")"] discard]];
        
        self.phraseParser = [TDAlternation alternation];
        phraseParser.name = @"phrase";
        [phraseParser add:self.atomicValueParser];
        [phraseParser add:s];
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


// atomicValue    = QuotedString | Num
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


- (void)workOnLiteralAssembly:(TDAssembly *)a {
    //    NSLog(@"%s", _cmd);
    //    NSLog(@"a: %@", a);
    TDToken *tok = [a pop];
    NSAssert(tok.isQuotedString, @"");
    NSString *s = [tok.stringValue stringByRemovingFirstAndLastCharacters];
    [a push:[TDLiteral literalWithString:s]];
}


- (void)workOnVariableAssembly:(TDAssembly *)a {
    //    NSLog(@"%s", _cmd);
    //    NSLog(@"a: %@", a);
    TDToken *tok = [a pop];
    NSAssert(tok.isWord, @"");
    TDParser *p = [a.target objectForKey:tok.stringValue];
    [a push:p];
}


- (void)workOnConstantAssembly:(TDAssembly *)a {
    //    NSLog(@"%s", _cmd);
    //    NSLog(@"a: %@", a);
    TDToken *tok = [a pop];
    NSAssert(tok.isWord, @"");
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
        NSAssert1(0, @"User Grammar referenced a constant parser name (uppercase word) which is not supported: %@. Must be one of: Word, QuotedString, Num, Symbol.", s);
    }
    [a push:p];
}


- (void)workOnNumAssembly:(TDAssembly *)a {
    //    NSLog(@"%s", _cmd);
    //    NSLog(@"a: %@", a);
    TDToken *tok = [a pop];
    NSAssert(tok.isNumber, @"");
    [a push:[TDLiteral literalWithString:tok.stringValue]];
}


- (void)workOnStarAssembly:(TDAssembly *)a {
    //    NSLog(@"%s", _cmd);
    //    NSLog(@"a: %@", a);
    id top = [a pop];
    NSAssert([top isKindOfClass:[TDParser class]], @"");
    TDRepetition *rep = [TDRepetition repetitionWithSubparser:top];
    [a push:rep];
}


- (void)workOnPlusAssembly:(TDAssembly *)a {
    //    NSLog(@"%s", _cmd);
    //    NSLog(@"a: %@", a);
    id top = [a pop];
    NSAssert([top isKindOfClass:[TDParser class]], @"");
    TDSequence *seq = [TDSequence sequence];
    [seq add:top];
    [seq add:[TDRepetition repetitionWithSubparser:top]];
    [a push:seq];
}


- (void)workOnQuestionAssembly:(TDAssembly *)a {
    //    NSLog(@"%s", _cmd);
    //    NSLog(@"a: %@", a);
    id top = [a pop];
    NSAssert([top isKindOfClass:[TDParser class]], @"");
    TDAlternation *alt = [TDAlternation alternation];
    [alt add:[TDEmpty empty]];
    [alt add:top];
    [a push:alt];
}


//- (void)workOnAndAssembly:(TDAssembly *)a {
////    NSLog(@"%s", _cmd);
////    NSLog(@"a: %@", a);
//    id second = [a pop];
//    id first = [a pop];
//    NSAssert([first isKindOfClass:[TDParser class]], @"");
//    NSAssert([second isKindOfClass:[TDParser class]], @"");
//    TDSequence *p = [TDSequence sequence];
//    [p add:first];
//    [p add:second];
//    [a push:p];
//}


- (void)workOnExpressionAssembly:(TDAssembly *)a {
    //    NSLog(@"%s", _cmd);
    //    NSLog(@"a: %@", a);
    
    NSAssert(![a isStackEmpty], @"");
    
    id obj = nil;
    NSMutableArray *objs = [NSMutableArray array];
    while (![a isStackEmpty]) {
        obj = [a pop];
        [objs addObject:obj];
        NSAssert([obj isKindOfClass:[TDParser class]], @"");
    }
    
    if (objs.count > 1) {
        TDSequence *seq = [TDSequence sequence];
        NSEnumerator *e = [objs reverseObjectEnumerator];
        while (obj = [e nextObject]) {
            [seq add:obj];
        }
        [a push:seq];
    } else {
        NSAssert((NSUInteger)1 == objs.count, @"");
        TDParser *p = [objs objectAtIndex:0];
        [a push:p];
    }
}


- (void)workOnOrAssembly:(TDAssembly *)a {
    //    NSLog(@"%s", _cmd);
    //    NSLog(@"a: %@", a);
    id second = [a pop];
    id first = [a pop];
    //    NSLog(@"first: %@", first);
    //    NSLog(@"second: %@", second);
    NSAssert(first, @"");
    NSAssert(second, @"");
    NSAssert([first isKindOfClass:[TDParser class]], @"");
    NSAssert([second isKindOfClass:[TDParser class]], @"");
    TDAlternation *p = [TDAlternation alternation];
    [p add:first];
    [p add:second];
    [a push:p];
}

@synthesize tokenizer;
@synthesize statementParser;
@synthesize declarationParser;
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
