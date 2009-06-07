//
//  TDParserFactory.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/12/08.
//  Copyright 2008 Todd Ditchendorf All rights reserved.
//

#import "TDParserFactory.h"
#import "NSString+TDParseKitAdditions.h"
#import "NSArray+TDParseKitAdditions.h"
#import <TDParseKit/TDParseKit.h>

@interface TDParser (TDParserFactoryAdditionsFriend)
- (void)setTokenizer:(TDTokenizer *)t;
@end

@interface TDCollectionParser ()
@property (nonatomic, readwrite, retain) NSMutableArray *subparsers;
@end

@interface TDRepetition ()
@property (nonatomic, readwrite, retain) TDParser *subparser;
@end

void TDReleaseSubparserTree(TDParser *p) {
    if ([p isKindOfClass:[TDCollectionParser class]]) {
        TDCollectionParser *c = (TDCollectionParser *)p;
        NSArray *subs = c.subparsers;
        if (subs) {
            [subs retain];
            c.subparsers = nil;
            for (TDParser *s in subs) {
                TDReleaseSubparserTree(s);
            }
            [subs release];
        }
    } else if ([p isMemberOfClass:[TDRepetition class]]) {
        TDRepetition *r = (TDRepetition *)p;
		TDParser *sub = r.subparser;
        if (sub) {
            [sub retain];
            r.subparser = nil;
            TDReleaseSubparserTree(sub);
            [sub release];
        }
    }
}

@interface TDParserFactory ()
- (id)parserTokensTableFromParsingStatementsInString:(NSString *)s;
- (void)gatherParserClassNamesFromTokens;
- (NSString *)parserClassNameFromTokenArray:(NSArray *)toks;

- (TDTokenizer *)tokenizerFromGrammarSettings;
- (BOOL)boolForTokenForKey:(NSString *)key;
- (void)setTokenizerState:(TDTokenizerState *)state onTokenizer:(TDTokenizer *)t forTokensForKey:(NSString *)key;

- (id)expandParser:(TDCollectionParser *)p fromTokenArray:(NSArray *)toks;
- (TDParser *)expandedParserForName:(NSString *)parserName;
- (void)setAssemblerForParser:(TDParser *)p;
- (NSString *)defaultAssemblerSelectorNameForParserName:(NSString *)parserName;

// this is only for unit tests? can it go away?
- (TDSequence *)parserFromExpression:(NSString *)s;

- (TDAlternation *)zeroOrOne:(TDParser *)p;
- (TDAlternation *)oneOrMore:(TDParser *)p;
    
- (void)workOnStatementAssembly:(TDAssembly *)a;
- (NSString *)defaultAssemblerSelectorNameForParserName:(NSString *)parserName;
- (void)workOnCallbackAssembly:(TDAssembly *)a;
- (void)workOnExpressionAssembly:(TDAssembly *)a;
- (void)workOnDiscardAssembly:(TDAssembly *)a;
- (void)workOnLiteralAssembly:(TDAssembly *)a;
- (void)workOnVariableAssembly:(TDAssembly *)a;
- (void)workOnConstantAssembly:(TDAssembly *)a;
- (void)workOnNumAssembly:(TDAssembly *)a;
- (void)workOnStarAssembly:(TDAssembly *)a;
- (void)workOnPlusAssembly:(TDAssembly *)a;
- (void)workOnQuestionAssembly:(TDAssembly *)a;
- (void)workOnPhraseCardinalityAssembly:(TDAssembly *)a;
- (void)workOnCardinalityAssembly:(TDAssembly *)a;
- (void)workOnOrAssembly:(TDAssembly *)a;

@property (nonatomic, assign) id assembler;
@property (nonatomic, retain) NSMutableDictionary *parserTokensTable;
@property (nonatomic, retain) NSMutableDictionary *parserClassTable;
@property (nonatomic, retain) NSMutableDictionary *selectorTable;
@property (nonatomic, retain) TDToken *equals;
@property (nonatomic, retain) TDToken *curly;
@property (nonatomic, retain) TDToken *paren;
@property (nonatomic, retain) TDToken *fwdSlash;
@property (nonatomic, retain) TDCollectionParser *statementParser;
@property (nonatomic, retain) TDCollectionParser *declarationParser;
@property (nonatomic, retain) TDCollectionParser *callbackParser;
@property (nonatomic, retain) TDCollectionParser *selectorParser;
@property (nonatomic, retain) TDCollectionParser *expressionParser;
@property (nonatomic, retain) TDCollectionParser *termParser;
@property (nonatomic, retain) TDCollectionParser *orTermParser;
@property (nonatomic, retain) TDCollectionParser *factorParser;
@property (nonatomic, retain) TDCollectionParser *nextFactorParser;
@property (nonatomic, retain) TDCollectionParser *phraseParser;
@property (nonatomic, retain) TDCollectionParser *phraseStarParser;
@property (nonatomic, retain) TDCollectionParser *phrasePlusParser;
@property (nonatomic, retain) TDCollectionParser *phraseQuestionParser;
@property (nonatomic, retain) TDCollectionParser *phraseCardinalityParser;
@property (nonatomic, retain) TDCollectionParser *cardinalityParser;
@property (nonatomic, retain) TDCollectionParser *atomicValueParser;
@property (nonatomic, retain) TDCollectionParser *discardParser;
@property (nonatomic, retain) TDCollectionParser *patternParser;
@property (nonatomic, retain) TDParser *literalParser;
@property (nonatomic, retain) TDParser *variableParser;
@property (nonatomic, retain) TDParser *constantParser;
@property (nonatomic, retain) TDParser *numParser;
@end

@implementation TDParserFactory

+ (id)factory {
    return [[[TDParserFactory alloc] init] autorelease];
}


- (id)init {
    if (self = [super init]) {
        self.equals = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:@"=" floatValue:0.0];
        self.curly = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:@"{" floatValue:0.0];
        self.paren = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:@"(" floatValue:0.0];
        self.assemblerSettingBehavior = TDParserFactoryAssemblerSettingBehaviorOnAll;
    }
    return self;
}


- (void)dealloc {
    assembler = nil; // appease clang static analyzer
    
    TDReleaseSubparserTree(statementParser);
    TDReleaseSubparserTree(expressionParser);
    
    self.parserTokensTable = nil;
    self.parserClassTable = nil;
    self.selectorTable = nil;
    self.equals = nil;
    self.curly = nil;
    self.paren = nil;
    self.fwdSlash = nil;
    self.statementParser = nil;
    self.declarationParser = nil;
    self.callbackParser = nil;
    self.selectorParser = nil;
    self.expressionParser = nil;
    self.termParser = nil;
    self.orTermParser = nil;
    self.factorParser = nil;
    self.nextFactorParser = nil;
    self.phraseParser = nil;
    self.phraseStarParser = nil;
    self.phrasePlusParser = nil;
    self.phraseQuestionParser = nil;
    self.phraseCardinalityParser = nil;
    self.cardinalityParser = nil;
    self.atomicValueParser = nil;
    self.patternParser = nil;
    self.discardParser = nil;
    self.literalParser = nil;
    self.variableParser = nil;
    self.constantParser = nil;
    self.numParser = nil;
    [super dealloc];
}


- (TDParser *)parserFromGrammar:(NSString *)s assembler:(id)a {
    self.assembler = a;
    self.selectorTable = [NSMutableDictionary dictionary];
    self.parserClassTable = [NSMutableDictionary dictionary];
    self.parserTokensTable = [self parserTokensTableFromParsingStatementsInString:s];

    [self gatherParserClassNamesFromTokens];

    TDTokenizer *t = [self tokenizerFromGrammarSettings];
        
    TDParser *start = [self expandedParserForName:@"@start"];
    
    assembler = nil;
    self.selectorTable = nil;
    self.parserClassTable = nil;
    self.parserTokensTable = nil;
    
    if (start && [start isKindOfClass:[TDParser class]]) {
        start.tokenizer = t;
        return start;
    } else {
        [NSException raise:@"GrammarException" format:@"The provided language grammar was invalid"];
        return nil;
    }
}


- (id)parserTokensTableFromParsingStatementsInString:(NSString *)s {
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    
    // customize tokenizer to find tokenizer customization directives
    [t setTokenizerState:t.wordState from:'@' to:'@'];    
    
    TDTokenArraySource *src = [[TDTokenArraySource alloc] initWithTokenizer:t delimiter:@";"];
    id target = [NSMutableDictionary dictionary]; // setup the variable lookup table
    
    while ([src hasMore]) {
        NSArray *toks = [src nextTokenArray];
        TDAssembly *a = [TDTokenAssembly assemblyWithTokenArray:toks];
        a.target = target;
        a = [self.statementParser completeMatchFor:a];
        target = a.target;
    }

    [src release];
    
    return target;
}


- (void)gatherParserClassNamesFromTokens {
    isGatheringClasses = YES;
    // discover the actual parser class types
    for (NSString *parserName in parserTokensTable) {
        NSString *className = [self parserClassNameFromTokenArray:[parserTokensTable objectForKey:parserName]];
        [parserClassTable setObject:className forKey:parserName];
    }
    isGatheringClasses = NO;
}


- (NSString *)parserClassNameFromTokenArray:(NSArray *)toks {
    TDAssembly *a = [TDTokenAssembly assemblyWithTokenArray:toks];
    a.target = parserTokensTable;
    a = [self.expressionParser completeMatchFor:a];
    TDParser *res = [a pop];
    a.target = nil;
    return [res className];
}


- (TDTokenizer *)tokenizerFromGrammarSettings {
    TDTokenizer *t = [TDTokenizer tokenizer];
    [t.commentState removeSingleLineStartMarker:@"//"];
    [t.commentState removeMultiLineStartMarker:@"/*"];

    t.whitespaceState.reportsWhitespaceTokens = [self boolForTokenForKey:@"@reportsWhitespaceTokens"];
    t.commentState.reportsCommentTokens = [self boolForTokenForKey:@"@reportsCommentTokens"];
	t.commentState.balancesEOFTerminatedComments = [self boolForTokenForKey:@"balancesEOFTerminatedComments"];
	t.quoteState.balancesEOFTerminatedQuotes = [self boolForTokenForKey:@"@balancesEOFTerminatedQuotes"];
	t.numberState.allowsTrailingDot = [self boolForTokenForKey:@"@allowsTrailingDot"];
    
    [self setTokenizerState:t.wordState onTokenizer:t forTokensForKey:@"@wordState"];
    [self setTokenizerState:t.numberState onTokenizer:t forTokensForKey:@"@numberState"];
    [self setTokenizerState:t.quoteState onTokenizer:t forTokensForKey:@"@quoteState"];
    [self setTokenizerState:t.symbolState onTokenizer:t forTokensForKey:@"@symbolState"];
    [self setTokenizerState:t.commentState onTokenizer:t forTokensForKey:@"@commentState"];
    [self setTokenizerState:t.whitespaceState onTokenizer:t forTokensForKey:@"@whitespaceState"];
    
    NSArray *toks = nil;
    
    // muli-char symbols
    toks = [parserTokensTable objectForKey:@"@symbols"];
    for (TDToken *tok in toks) {
        if (tok.isQuotedString) {
            [t.symbolState add:[tok.stringValue stringByTrimmingQuotes]];
        }
    }
    
    // wordChars
    toks = [parserTokensTable objectForKey:@"@wordChars"];
    for (TDToken *tok in toks) {
        if (tok.isQuotedString) {
			NSString *s = [tok.stringValue stringByTrimmingQuotes];
			if (s.length) {
				NSInteger c = [s characterAtIndex:0];
				[t.wordState setWordChars:YES from:c to:c];
			}
        }
    }
    
    // whitespaceChars
    toks = [parserTokensTable objectForKey:@"@whitespaceChars"];
    for (TDToken *tok in toks) {
        if (tok.isQuotedString) {
			NSString *s = [tok.stringValue stringByTrimmingQuotes];
			if (s.length) {
				NSInteger c = [s characterAtIndex:0];
				[t.whitespaceState setWhitespaceChars:YES from:c to:c];
			}
        }
    }
    
    // single-line comments
    toks = [parserTokensTable objectForKey:@"@singleLineComments"];
    for (TDToken *tok in toks) {
        if (tok.isQuotedString) {
            NSString *s = [tok.stringValue stringByTrimmingQuotes];
            [t.commentState addSingleLineStartMarker:s];
            [t.symbolState add:s];
        }
    }
    
    // multi-line comments
    toks = [parserTokensTable objectForKey:@"@multiLineComments"];
    if (toks.count > 1) {
        NSInteger i = 0;
        for ( ; i < toks.count - 1; i++) {
            TDToken *startTok = [toks objectAtIndex:i];
            TDToken *endTok = [toks objectAtIndex:++i];
            if (startTok.isQuotedString && endTok.isQuotedString) {
                NSString *start = [startTok.stringValue stringByTrimmingQuotes];
                NSString *end = [endTok.stringValue stringByTrimmingQuotes];
                [t.commentState addMultiLineStartMarker:start endMarker:end];
                [t.symbolState add:start];
                [t.symbolState add:end];
            }
        }
    }
    
    return t;
}


- (BOOL)boolForTokenForKey:(NSString *)key {
    BOOL result = NO;
    NSArray *toks = [parserTokensTable objectForKey:key];
    if (toks.count) {
        TDToken *tok = [toks objectAtIndex:0];
        if (tok.isWord && [tok.stringValue isEqualToString:@"YES"]) {
            result = YES;
        }
    }
    return result;
}


- (void)setTokenizerState:(TDTokenizerState *)state onTokenizer:(TDTokenizer *)t forTokensForKey:(NSString *)key {
    NSArray *toks = [parserTokensTable objectForKey:key];
    for (TDToken *tok in toks) {
        if (tok.isQuotedString) {
            NSString *s = [tok.stringValue stringByTrimmingQuotes];
            if (1 == s.length) {
                NSInteger c = [s characterAtIndex:0];
                [t setTokenizerState:state from:c to:c];
            }
        }
    }
}


- (TDParser *)expandedParserForName:(NSString *)parserName {
    id obj = [parserTokensTable objectForKey:parserName];
    if ([obj isKindOfClass:[TDParser class]]) {
        return obj;
    } else {
        // prevent infinite loops by creating a parser of the correct type first, and putting it in the table
        NSString *className = [parserClassTable objectForKey:parserName];
        TDCollectionParser *p = [[NSClassFromString(className) alloc] init];
        [parserTokensTable setObject:p forKey:parserName];
        [p release];
        
        p = [self expandParser:p fromTokenArray:obj];
        p.name = parserName;

        [self setAssemblerForParser:p];

        [parserTokensTable setObject:p forKey:parserName];
        return p;
    }
}


- (void)setAssemblerForParser:(TDParser *)p {
    NSString *parserName = p.name;
    NSString *selName = [selectorTable objectForKey:parserName];

    BOOL setOnAll = (assemblerSettingBehavior & TDParserFactoryAssemblerSettingBehaviorOnAll);

    if (setOnAll) {
        // continue
    } else {
        BOOL setOnExplicit = (assemblerSettingBehavior & TDParserFactoryAssemblerSettingBehaviorOnExplicit);
        if (setOnExplicit && selName) {
            // continue
        } else {
            BOOL isTerminal = [p isKindOfClass:[TDTerminal class]];
            if (!isTerminal && !setOnExplicit) return;
            
            BOOL setOnTerminals = (assemblerSettingBehavior & TDParserFactoryAssemblerSettingBehaviorOnTerminals);
            if (setOnTerminals && isTerminal) {
                // continue
            } else {
                return;
            }
        }
    }
    
    if (!selName) {
        selName = [self defaultAssemblerSelectorNameForParserName:parserName];
    }
                
    SEL sel = NSSelectorFromString(selName);
    if (assembler && [assembler respondsToSelector:sel]) {
        [p setAssembler:assembler selector:sel];
    }
}


- (id)expandParser:(TDCollectionParser *)p fromTokenArray:(NSArray *)toks {	
    TDAssembly *a = [TDTokenAssembly assemblyWithTokenArray:toks];
    a.target = parserTokensTable;
    a = [self.expressionParser completeMatchFor:a];
    TDParser *res = [a pop];
    if ([res isKindOfClass:[TDCollectionParser class]]) {
        [p add:res];
        return p;
    } else {
        return res;
    }
}


// this is just a utility for unit-testing
- (TDSequence *)parserFromExpression:(NSString *)s {
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    TDAssembly *a = [TDTokenAssembly assemblyWithTokenizer:t];
    a.target = [NSMutableDictionary dictionary]; // setup the variable lookup table
    a = [self.expressionParser completeMatchFor:a];
    return [a pop];
}


- (TDAlternation *)zeroOrOne:(TDParser *)p {
    TDAlternation *a = [TDAlternation alternation];
    [a add:[TDEmpty empty]];
    [a add:p];
    return a;
}


- (TDAlternation *)oneOrMore:(TDParser *)p {
    TDAlternation *s = [TDSequence sequence];
    [s add:p];
    [s add:[TDRepetition repetitionWithSubparser:p]];
    return s;
}


// @start               = statement*
// satement             = declaration '=' expression
// declaration          = Word callback?
// callback             = '(' selector ')'
// selector             = Word ':'
// expression           = term orTerm*
// term                 = factor nextFactor*
// orTerm               = '|' term
// factor               = phrase | phraseStar | phrasePlus | phraseQuestion | phraseCardinality
// nextFactor           = factor
// phrase               = atomicValue | '(' expression ')'
// phraseStar           = phrase '*'
// phrasePlus           = phrase '+'
// phraseQuestion       = phrase '?'
// phraseCardinality    = phrase cardinality
// cardinality          = '{' Num '}'
// atomicValue          = (literal | variable | constant | pattern) discard?
// discard              = '.' 'discard'
// literal              = QuotedString
// variable             = LowercaseWord
// constant             = UppercaseWord
// pattern              = /[^/]+/i/QuotedString Word? '/'? Word?


// satement             = declaration '=' expression
- (TDCollectionParser *)statementParser {
    if (!statementParser) {
        self.statementParser = [TDTrack track];
        statementParser.name = @"statement";
        [statementParser add:self.declarationParser];
        [statementParser add:[TDSymbol symbolWithString:@"="]];

        // accept any tokens in the parser expr the first time around. just gather tokens for later
        [statementParser add:[self oneOrMore:[TDAny any]]];
        [statementParser setAssembler:self selector:@selector(workOnStatementAssembly:)];
    }
    return statementParser;
}


// declaration          = productionName callback?
- (TDCollectionParser *)declarationParser {
    if (!declarationParser) {
        self.declarationParser = [TDSequence sequence];
        declarationParser.name = @"declaration";
        [declarationParser add:[TDWord word]];
        [declarationParser add:[self zeroOrOne:self.callbackParser]];
    }
    return declarationParser;
}


// callback             = '(' selector ')'
- (TDCollectionParser *)callbackParser {
    if (!callbackParser) {
        self.callbackParser = [TDTrack track];
        callbackParser.name = @"callback";
        [callbackParser add:[[TDSymbol symbolWithString:@"("] discard]];
        [callbackParser add:self.selectorParser];
        [callbackParser add:[[TDSymbol symbolWithString:@")"] discard]];
        [callbackParser setAssembler:self selector:@selector(workOnCallbackAssembly:)];
    }
    return callbackParser;
}


// selector             = Word ':'
- (TDCollectionParser *)selectorParser {
    if (!selectorParser) {
        self.selectorParser = [TDTrack track];
        selectorParser.name = @"selector";
        [selectorParser add:[TDLowercaseWord word]];
        [selectorParser add:[[TDSymbol symbolWithString:@":"] discard]];
    }
    return selectorParser;
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


// factor            = phrase | phraseStar | phrasePlus | phraseQuestion | phraseCardinality
- (TDCollectionParser *)factorParser {
    if (!factorParser) {
        self.factorParser = [TDAlternation alternation];
        factorParser.name = @"factor";
        [factorParser add:self.phraseParser];
        [factorParser add:self.phraseStarParser];
        [factorParser add:self.phrasePlusParser];
        [factorParser add:self.phraseQuestionParser];
        [factorParser add:self.phraseCardinalityParser];
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
        [nextFactorParser add:self.phraseCardinalityParser];
    }
    return nextFactorParser;
}


// phrase            = atomicValue | '(' expression ')'
- (TDCollectionParser *)phraseParser {
    if (!phraseParser) {
        self.phraseParser = [TDAlternation alternation];
        phraseParser.name = @"phrase";
        [phraseParser add:self.atomicValueParser];

        TDSequence *s = [TDSequence sequence];
        [s add:[TDSymbol symbolWithString:@"("]];
        [s add:self.expressionParser];
        [s add:[[TDSymbol symbolWithString:@")"] discard]];
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


// phraseQuestion       = phrase '?'
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


// phraseCardinality    = phrase cardinality
- (TDCollectionParser *)phraseCardinalityParser {
    if (!phraseCardinalityParser) {
        self.phraseCardinalityParser = [TDSequence sequence];
        phraseCardinalityParser.name = @"phraseCardinality";
        [phraseCardinalityParser add:self.phraseParser];
        [phraseCardinalityParser add:self.cardinalityParser];
        [phraseCardinalityParser setAssembler:self selector:@selector(workOnPhraseCardinalityAssembly:)];
    }
    return phraseCardinalityParser;
}


// cardinality          = '{' Num '}'
- (TDCollectionParser *)cardinalityParser {
    if (!cardinalityParser) {
        self.cardinalityParser = [TDSequence sequence];
        cardinalityParser.name = @"cardinality";
        [cardinalityParser add:[TDSymbol symbolWithString:@"{"]]; // serves as fence. dont discard
        [cardinalityParser add:[TDNum num]];
        [cardinalityParser add:[[TDSymbol symbolWithString:@"}"] discard]];
        [cardinalityParser setAssembler:self selector:@selector(workOnCardinalityAssembly:)];
    }
    return cardinalityParser;
}


// atomicValue          = (pattern | literal | variable | constant) discard?
- (TDCollectionParser *)atomicValueParser {
    if (!atomicValueParser) {
        self.atomicValueParser = [TDSequence sequence];
        atomicValueParser.name = @"atomicValue";
        
        TDAlternation *a = [TDAlternation alternation];
        [a add:self.patternParser];
        [a add:self.literalParser];
        [a add:self.variableParser];
        [a add:self.constantParser];
        [atomicValueParser add:a];

        [atomicValueParser add:[self zeroOrOne:self.discardParser]];
    }
    return atomicValueParser;
}


// discard              = '.' 'discard'
- (TDCollectionParser *)discardParser {
    if (!discardParser) {
        self.discardParser = [TDSequence sequence];
        discardParser.name = @"discardParser";
        [discardParser add:[[TDSymbol symbolWithString:@"."] discard]];
        [discardParser add:[[TDLiteral literalWithString:@"discard"] discard]];
        [discardParser setAssembler:self selector:@selector(workOnDiscardAssembly:)];
    }
    return discardParser;
}


// pattern              = /[^/]+/i/QuotedString Word? '/'? Word?
// pattern              = 'Pattern' '(' QuotedString ',' QuotedString ',' Word ')';
- (TDParser *)patternParser {
    if (!patternParser) {
        self.patternParser = [TDTrack track];
        patternParser.name = @"pattern";

        TDParser *re = [TDQuotedString quotedString];
        [re setAssembler:self selector:@selector(workOnPatternRegexAssembly:)];
        
        TDParser *opts = [TDQuotedString quotedString];
        [opts setAssembler:self selector:@selector(workOnPatternOptionsAssembly:)];
        
        // tokenType
        TDAlternation *tt = [TDAlternation alternation];
        [tt add:[TDLiteral literalWithString:@"Any"]];
        [tt add:[TDLiteral literalWithString:@"Word"]];
        [tt add:[TDLiteral literalWithString:@"Num"]];
        [tt add:[TDLiteral literalWithString:@"Number"]];
        [tt add:[TDLiteral literalWithString:@"Symbol"]];
        [tt add:[TDLiteral literalWithString:@"QuotedString"]];
        [tt add:[TDLiteral literalWithString:@"DelimitedString"]];
        [tt setAssembler:self selector:@selector(workOnPatternTokenTypeAssembly:)];
        
        [patternParser add:[[TDLiteral literalWithString:@"Pattern"] discard]];
        [patternParser add:[TDSymbol symbolWithString:@"("]]; // preserve as fence
        [patternParser add:re];
        [patternParser add:[[TDSymbol symbolWithString:@","] discard]];
        [patternParser add:opts];
        [patternParser add:[[TDSymbol symbolWithString:@","] discard]];
        [patternParser add:tt];
        [patternParser add:[[TDSymbol symbolWithString:@")"] discard]];
        [patternParser setAssembler:self selector:@selector(workOnPatternAssembly:)];
    }
    return patternParser;
}


- (void)workOnPatternAssembly:(TDAssembly *)a {
    NSArray *objs = [a objectsAbove:paren];
    NSAssert(objs.count, @"");
    //NSAssert(1 == objs.count, @"");

    [a pop]; //discard '(' fence
    
    NSString *re = nil;
    NSUInteger opts = TDPatternOptionsNone;
    TDTokenType tt = TDTokenTypeAny;

    NSLog(@"objs: %@", objs);
    
    NSInteger i = 0;
    for (id obj in [objs reverseObjectEnumerator]) {
        if (0 == i) {
            NSAssert([obj isKindOfClass:[NSString class]], @"");
            re = obj;
        } else if (1 == i) {
            NSLog(@"opts: %@", obj);
            NSAssert([obj isKindOfClass:[NSNumber class]], @"");
            opts = [obj unsignedIntegerValue];
        } else if (2 == i) {
            NSAssert([obj isKindOfClass:[NSNumber class]], @"");
            tt = [obj integerValue];
        }
        i++;
    }
    
    [a push:[TDPattern patternWithString:re options:opts tokenType:tt]];
}


- (void)workOnPatternRegexAssembly:(TDAssembly *)a {
    TDToken *tok = [a pop];
    NSAssert([tok isKindOfClass:[TDToken class]], @"");
    NSAssert(tok.isQuotedString, @"");
    
    [a push:fwdSlash]; // put a fence in dere
    [a push:[tok.stringValue stringByTrimmingQuotes]];
}


- (void)workOnPatternOptionsAssembly:(TDAssembly *)a {
    TDToken *tok = [a pop];
    NSAssert([tok isKindOfClass:[TDToken class]], @"");
    NSAssert(tok.isQuotedString, @"");
    
    NSLog(@"\n\n opts token: %@\n", tok.stringValue);
    
    TDPatternOptions opts = TDPatternOptionsNone;
    NSString *s = [tok.stringValue stringByTrimmingQuotes];
    if (NSNotFound != [s rangeOfString:@"i"].location) {
        opts |= TDPatternOptionsIgnoreCase;
    }
    if (NSNotFound != [s rangeOfString:@"m"].location) {
        opts |= TDPatternOptionsMultiline;
    }
    if (NSNotFound != [s rangeOfString:@"x"].location) {
        opts |= TDPatternOptionsComments;
    }
    if (NSNotFound != [s rangeOfString:@"s"].location) {
        opts |= TDPatternOptionsDotAll;
    }
    if (NSNotFound != [s rangeOfString:@"w"].location) {
        opts |= TDPatternOptionsUnicodeWordBoundaries;
    }
    
    NSLog(@"opts here: %@", [NSNumber numberWithUnsignedInteger:opts]);
    [a push:[NSNumber numberWithUnsignedInteger:opts]];
}


- (void)workOnPatternTokenTypeAssembly:(TDAssembly *)a {
    TDToken *tok = [a pop];
    NSAssert([tok isKindOfClass:[TDToken class]], @"");
    NSAssert(tok.isWord, @"");

    TDTokenType tt = TDTokenTypeAny;
    if ([tok.stringValue isEqualToString:@"Word"]) {
        tt = TDTokenTypeWord;
    } else if ([tok.stringValue isEqualToString:@"Num"] || [tok.stringValue isEqualToString:@"Number"]) {
        tt = TDTokenTypeNumber;
    } else if ([tok.stringValue isEqualToString:@"Symbol"]) {
        tt = TDTokenTypeSymbol;
    } else if ([tok.stringValue isEqualToString:@"QuotedString"]) {
        tt = TDTokenTypeQuotedString;
    } else if ([tok.stringValue isEqualToString:@"DelimitedString"]) {
        tt = TDTokenTypeDelimitedString;
    }
    
    [a push:[NSNumber numberWithInteger:tt]];
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
        variableParser.name = @"variable";
        [variableParser setAssembler:self selector:@selector(workOnVariableAssembly:)];
    }
    return variableParser;
}


// constant = UppercaseWord
- (TDParser *)constantParser {
    if (!constantParser) {
        self.constantParser = [TDUppercaseWord word];
        constantParser.name = @"constant";
        [constantParser setAssembler:self selector:@selector(workOnConstantAssembly:)];
    }
    return constantParser;
}


// num = Num
- (TDParser *)numParser {
    if (!numParser) {
        self.numParser = [TDNum num];
        numParser.name = @"num";
        [numParser setAssembler:self selector:@selector(workOnNumAssembly:)];
    }
    return numParser;
}


- (void)workOnStatementAssembly:(TDAssembly *)a {
    NSArray *toks = [[a objectsAbove:equals] reversedArray];
    [a pop]; // discard '=' tok

    NSString *parserName = nil;
    NSString *selName = nil;
    id obj = [a pop];
    if ([obj isKindOfClass:[NSString class]]) { // a callback was provided
        selName = obj;
        parserName = [[a pop] stringValue];
    } else {
        parserName = [obj stringValue];
    }
    
    if (selName) {
        [selectorTable setObject:selName forKey:parserName];
    }
	NSMutableDictionary *d = a.target;
    [d setObject:toks forKey:parserName];
}


- (NSString *)defaultAssemblerSelectorNameForParserName:(NSString *)parserName {
    NSString *prefix = nil;
    if ([parserName hasPrefix:@"@"]) {
        parserName = [parserName substringFromIndex:1];
        prefix = @"workOn_";
    } else {
        prefix = @"workOn";
    }
    NSString *s = [NSString stringWithFormat:@"%@%@", [[parserName substringToIndex:1] uppercaseString], [parserName substringFromIndex:1]]; 
    return [NSString stringWithFormat:@"%@%@Assembly:", prefix, s];
}


- (void)workOnCallbackAssembly:(TDAssembly *)a {
    TDToken *selNameTok = [a pop];
    NSString *selName = [NSString stringWithFormat:@"%@:", selNameTok.stringValue];
    [a push:selName];
}


- (void)workOnExpressionAssembly:(TDAssembly *)a {
    NSArray *objs = [a objectsAbove:paren];
    [a pop]; // pop '('
    if (objs.count > 1) {
        TDSequence *seq = [TDSequence sequence];
        for (id obj in [objs reverseObjectEnumerator]) {
            [seq add:obj];
        }
        [a push:seq];
    } else if (objs.count) {
        [a push:[objs objectAtIndex:0]];
    }
}


- (void)workOnDiscardAssembly:(TDAssembly *)a {
    TDTerminal *t = [a pop]; // tell terminal to discard itself when matched
    [t discard];
    [a push:t];
}


- (void)workOnLiteralAssembly:(TDAssembly *)a {
    TDToken *tok = [a pop];
    NSString *s = [tok.stringValue stringByTrimmingQuotes];
    [a push:[TDCaseInsensitiveLiteral literalWithString:s]];
}


- (void)workOnVariableAssembly:(TDAssembly *)a {
    TDToken *tok = [a pop];
    NSString *parserName = tok.stringValue;
    TDParser *p = nil;
    if (isGatheringClasses) {
        // lookup the actual possible parser. 
        // if its not there, or still a token array, just spoof it with a sequence
		NSMutableDictionary *d = a.target;
        p = [d objectForKey:parserName];
        if (![p isKindOfClass:[TDParser parser]]) {
            p = [TDSequence sequence];
        }
    } else {
        p = [self expandedParserForName:parserName];
    }
    [a push:p];
}


- (void)workOnConstantAssembly:(TDAssembly *)a {
    TDToken *tok = [a pop];
    NSString *s = tok.stringValue;
    id p = nil;
    if ([s isEqualToString:@"Word"]) {
        p = [TDWord word];
    } else if ([s isEqualToString:@"LowercaseWord"]) {
        p = [TDLowercaseWord word];
    } else if ([s isEqualToString:@"UppercaseWord"]) {
        p = [TDUppercaseWord word];
    } else if ([s isEqualToString:@"Num"]) {
        p = [TDNum num];
    } else if ([s isEqualToString:@"QuotedString"]) {
        p = [TDQuotedString quotedString];
    } else if ([s isEqualToString:@"Symbol"]) {
        p = [TDSymbol symbol];
    } else if ([s isEqualToString:@"Comment"]) {
        p = [TDComment comment];
    } else if ([s isEqualToString:@"Any"]) {
        p = [TDAny any];
    } else if ([s isEqualToString:@"Empty"]) {
        p = [TDEmpty empty];
    } else if ([s isEqualToString:@"Pattern"]) {
        p = tok;
    } else if ([s isEqualToString:@"YES"] || [s isEqualToString:@"NO"]) {
        p = tok;
    } else {
        [NSException raise:@"Grammar Exception" format:
         @"User Grammar referenced a constant parser name (uppercase word) which is not supported: %@. Must be one of: Word, LowercaseWord, UppercaseWord, QuotedString, Num, Symbol, Empty.", s];
    }
    [a push:p];
}


- (void)workOnNumAssembly:(TDAssembly *)a {
    TDToken *tok = [a pop];
    [a push:[TDLiteral literalWithString:tok.stringValue]];
}


- (void)workOnStarAssembly:(TDAssembly *)a {
    id top = [a pop];
    TDRepetition *rep = [TDRepetition repetitionWithSubparser:top];
    [a push:rep];
}


- (void)workOnPlusAssembly:(TDAssembly *)a {
    id top = [a pop];
    [a push:[self oneOrMore:top]];
}


- (void)workOnQuestionAssembly:(TDAssembly *)a {
    id top = [a pop];
    [a push:[self zeroOrOne:top]];
}


- (void)workOnPhraseCardinalityAssembly:(TDAssembly *)a {
    NSRange r = [[a pop] rangeValue];
    TDParser *p = [a pop];
    TDSequence *s = [TDSequence sequence];
    
    NSInteger i = 0;
    for ( ; i < r.length; i++) {
        [s add:p];
    }

    [a push:s];
}


- (void)workOnCardinalityAssembly:(TDAssembly *)a {
    NSArray *toks = [a objectsAbove:self.curly];
    [a pop]; // discard '{' tok

    TDToken *start = [toks objectAtIndex:0];
    NSRange r = NSMakeRange(start.floatValue, start.floatValue);
    [a push:[NSValue valueWithRange:r]];
}


- (void)workOnOrAssembly:(TDAssembly *)a {
    id second = [a pop];
    id first = [a pop];
    TDAlternation *p = [TDAlternation alternation];
    [p add:first];
    [p add:second];
    [a push:p];
}

@synthesize assembler;
@synthesize parserTokensTable;
@synthesize parserClassTable;
@synthesize selectorTable;
@synthesize equals;
@synthesize curly;
@synthesize paren;
@synthesize fwdSlash;
@synthesize statementParser;
@synthesize declarationParser;
@synthesize callbackParser;
@synthesize selectorParser;
@synthesize expressionParser;
@synthesize termParser;
@synthesize orTermParser;
@synthesize factorParser;
@synthesize nextFactorParser;
@synthesize phraseParser;
@synthesize phraseStarParser;
@synthesize phrasePlusParser;
@synthesize phraseQuestionParser;
@synthesize phraseCardinalityParser;
@synthesize cardinalityParser;
@synthesize atomicValueParser;
@synthesize discardParser;
@synthesize patternParser;
@synthesize literalParser;
@synthesize variableParser;
@synthesize constantParser;
@synthesize numParser;
@synthesize assemblerSettingBehavior;
@end
