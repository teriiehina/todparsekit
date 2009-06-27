//
//  TDParserFactory.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/12/08.
//  Copyright 2008 Todd Ditchendorf All rights reserved.
//

#import "TDParserFactory.h"
#import <TDParseKit/TDParseKit.h>
#import "NSString+TDParseKitAdditions.h"
#import "NSArray+TDParseKitAdditions.h"

@interface TDParser (TDParserFactoryAdditionsFriend)
- (void)setTokenizer:(TDTokenizer *)t;
@end

@interface TDCollectionParser ()
@property (nonatomic, readwrite, retain) NSMutableArray *subparsers;
@end

@interface TDRepetition ()
@property (nonatomic, readwrite, retain) TDParser *subparser;
@end

@interface TDPattern ()
@property (nonatomic, assign) TDTokenType tokenType;
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
- (void)setFallbackStateOn:(TDTokenizerState *)state withTokenizer:(TDTokenizer *)t forTokensForKey:(NSString *)key;

- (id)expandParser:(TDParser *)p fromTokenArray:(NSArray *)toks;
- (TDParser *)expandedParserForName:(NSString *)parserName;
- (void)setAssemblerForParser:(TDParser *)p;
- (NSString *)defaultAssemblerSelectorNameForParserName:(NSString *)parserName;

// this is only for unit tests? can it go away?
- (TDSequence *)parserFromExpression:(NSString *)s;

- (TDAlternation *)zeroOrOne:(TDParser *)p;
- (TDSequence *)oneOrMore:(TDParser *)p;
    
- (void)workOnStatement:(TDAssembly *)a;
- (NSString *)defaultAssemblerSelectorNameForParserName:(NSString *)parserName;
- (void)workOnCallback:(TDAssembly *)a;
- (void)workOnExpression:(TDAssembly *)a;
- (void)workOnInclusion:(TDAssembly *)a;    
- (void)workOnExclusion:(TDAssembly *)a;
- (void)workOnLiteral:(TDAssembly *)a;
- (void)workOnVariable:(TDAssembly *)a;
- (void)workOnConstant:(TDAssembly *)a;
- (void)workOnNum:(TDAssembly *)a;
- (void)workOnStar:(TDAssembly *)a;
- (void)workOnPlus:(TDAssembly *)a;
- (void)workOnQuestion:(TDAssembly *)a;
- (void)workOnPhraseCardinality:(TDAssembly *)a;
- (void)workOnCardinality:(TDAssembly *)a;
- (void)workOnOr:(TDAssembly *)a;

@property (nonatomic, assign) id assembler;
@property (nonatomic, retain) NSMutableDictionary *parserTokensTable;
@property (nonatomic, retain) NSMutableDictionary *parserClassTable;
@property (nonatomic, retain) NSMutableDictionary *selectorTable;
@property (nonatomic, retain) TDToken *equals;
@property (nonatomic, retain) TDToken *curly;
@property (nonatomic, retain) TDToken *paren;
@property (nonatomic, retain) TDToken *bracket;
@property (nonatomic, retain) TDToken *caret;
@property (nonatomic, retain) TDCollectionParser *statementParser;
@property (nonatomic, retain) TDCollectionParser *declarationParser;
@property (nonatomic, retain) TDCollectionParser *callbackParser;
@property (nonatomic, retain) TDCollectionParser *selectorParser;
@property (nonatomic, retain) TDCollectionParser *exprParser;
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
@property (nonatomic, retain) TDCollectionParser *primaryExprParser;
@property (nonatomic, retain) TDCollectionParser *predicateParser;
@property (nonatomic, retain) TDCollectionParser *inclusionParser;
@property (nonatomic, retain) TDCollectionParser *exclusionParser;
@property (nonatomic, retain) TDCollectionParser *atomicValueParser;
@property (nonatomic, retain) TDCollectionParser *discardParser;
@property (nonatomic, retain) TDParser *patternParser;
@property (nonatomic, retain) TDParser *literalParser;
@property (nonatomic, retain) TDParser *variableParser;
@property (nonatomic, retain) TDParser *constantParser;
@property (nonatomic, retain) TDCollectionParser *delimitedStringParser;
@end

@implementation TDParserFactory

+ (id)factory {
    return [[[TDParserFactory alloc] init] autorelease];
}


- (id)init {
    if (self = [super init]) {
        self.equals  = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:@"=" floatValue:0.0];
        self.curly   = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:@"{" floatValue:0.0];
        self.paren   = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:@"(" floatValue:0.0];
        self.bracket = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:@"[" floatValue:0.0];
        self.caret   = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:@"^" floatValue:0.0];
        self.assemblerSettingBehavior = TDParserFactoryAssemblerSettingBehaviorOnAll;
    }
    return self;
}


- (void)dealloc {
    assembler = nil; // appease clang static analyzer
    
    TDReleaseSubparserTree(statementParser);
    TDReleaseSubparserTree(exprParser);
    
    self.parserTokensTable = nil;
    self.parserClassTable = nil;
    self.selectorTable = nil;
    self.equals = nil;
    self.curly = nil;
    self.paren = nil;
    self.bracket = nil;
    self.caret = nil;
    self.statementParser = nil;
    self.declarationParser = nil;
    self.callbackParser = nil;
    self.selectorParser = nil;
    self.exprParser = nil;
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
    self.primaryExprParser = nil;
    self.predicateParser = nil;
    self.inclusionParser = nil;
    self.exclusionParser = nil;
    self.atomicValueParser = nil;
    self.patternParser = nil;
    self.discardParser = nil;
    self.literalParser = nil;
    self.variableParser = nil;
    self.constantParser = nil;
    self.delimitedStringParser = nil;
    [super dealloc];
}


- (TDParser *)parserFromGrammar:(NSString *)s assembler:(id)a {
    self.assembler = a;
    self.selectorTable = [NSMutableDictionary dictionary];
    self.parserClassTable = [NSMutableDictionary dictionary];
    self.parserTokensTable = [self parserTokensTableFromParsingStatementsInString:s];

    TDTokenizer *t = [self tokenizerFromGrammarSettings];

    [self gatherParserClassNamesFromTokens];
    
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

    // add support for tokenizer directives like @commentState.fallbackState
    [t.wordState setWordChars:YES from:'.' to:'.'];
    
    // setup comments
    [t setTokenizerState:t.commentState from:'/' to:'/'];
    [t.commentState addSingleLineStartMarker:@"//"];
    [t.commentState addMultiLineStartMarker:@"/*" endMarker:@"*/"];
    
    // comment state should fallback to delimit state to match regex delimited strings
    t.commentState.fallbackState = t.delimitState;
    
    // regex delimited strings
    [t.delimitState addStartMarker:@"/" endMarker:@"/" allowedCharacterSet:[[NSCharacterSet whitespaceCharacterSet] invertedSet]];    
    
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
        NSAssert(className.length, @"");
        [parserClassTable setObject:className forKey:parserName];
    }
    isGatheringClasses = NO;
}


- (NSString *)parserClassNameFromTokenArray:(NSArray *)toks {
    TDAssembly *a = [TDTokenAssembly assemblyWithTokenArray:toks];
    a.target = parserTokensTable;
    a = [self.exprParser completeMatchFor:a];
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
	t.delimitState.balancesEOFTerminatedStrings = [self boolForTokenForKey:@"@balancesEOFTerminatedStrings"];
	t.numberState.allowsTrailingDot = [self boolForTokenForKey:@"@allowsTrailingDot"];
    
    [self setTokenizerState:t.wordState onTokenizer:t forTokensForKey:@"@wordState"];
    [self setTokenizerState:t.numberState onTokenizer:t forTokensForKey:@"@numberState"];
    [self setTokenizerState:t.quoteState onTokenizer:t forTokensForKey:@"@quoteState"];
    [self setTokenizerState:t.delimitState onTokenizer:t forTokensForKey:@"@delimitState"];
    [self setTokenizerState:t.symbolState onTokenizer:t forTokensForKey:@"@symbolState"];
    [self setTokenizerState:t.commentState onTokenizer:t forTokensForKey:@"@commentState"];
    [self setTokenizerState:t.whitespaceState onTokenizer:t forTokensForKey:@"@whitespaceState"];
    
    [self setFallbackStateOn:t.commentState withTokenizer:t forTokensForKey:@"@commentState.fallbackState"];
    [self setFallbackStateOn:t.delimitState withTokenizer:t forTokensForKey:@"@delimitState.fallbackState"];
    
    NSArray *toks = nil;
    
    // muli-char symbols
    toks = [NSArray arrayWithArray:[parserTokensTable objectForKey:@"@symbol"]];
    toks = [toks arrayByAddingObjectsFromArray:[parserTokensTable objectForKey:@"@symbols"]];
    for (TDToken *tok in toks) {
        if (tok.isQuotedString) {
            [t.symbolState add:[tok.stringValue stringByTrimmingQuotes]];
        }
    }
    
    // wordChars
    toks = [NSArray arrayWithArray:[parserTokensTable objectForKey:@"@wordChar"]];
    toks = [toks arrayByAddingObjectsFromArray:[parserTokensTable objectForKey:@"@wordChars"]];
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
    toks = [NSArray arrayWithArray:[parserTokensTable objectForKey:@"@whitespaceChar"]];
    toks = [toks arrayByAddingObjectsFromArray:[parserTokensTable objectForKey:@"@whitespaceChars"]];
    for (TDToken *tok in toks) {
        if (tok.isQuotedString) {
			NSString *s = [tok.stringValue stringByTrimmingQuotes];
			if (s.length) {
                NSInteger c = 0;
                if ([s hasPrefix:@"#x"]) {
                    c = [s integerValue];
                } else {
                    c = [s characterAtIndex:0];
                }
                [t.whitespaceState setWhitespaceChars:YES from:c to:c];
			}
        }
    }
    
    // single-line comments
    toks = [NSArray arrayWithArray:[parserTokensTable objectForKey:@"@singleLineComment"]];
    toks = [toks arrayByAddingObjectsFromArray:[parserTokensTable objectForKey:@"@singleLineComments"]];
    for (TDToken *tok in toks) {
        if (tok.isQuotedString) {
            NSString *s = [tok.stringValue stringByTrimmingQuotes];
            [t.commentState addSingleLineStartMarker:s];
        }
    }
    
    // multi-line comments
    toks = [NSArray arrayWithArray:[parserTokensTable objectForKey:@"@multiLineComment"]];
    toks = [toks arrayByAddingObjectsFromArray:[parserTokensTable objectForKey:@"@multiLineComments"]];
    NSAssert(0 == toks.count % 2, @"@multiLineComments must be specified as quoted strings in multiples of 2");
    if (toks.count > 1) {
        NSInteger i = 0;
        for ( ; i < toks.count - 1; i++) {
            TDToken *startTok = [toks objectAtIndex:i];
            TDToken *endTok = [toks objectAtIndex:++i];
            if (startTok.isQuotedString && endTok.isQuotedString) {
                NSString *start = [startTok.stringValue stringByTrimmingQuotes];
                NSString *end = [endTok.stringValue stringByTrimmingQuotes];
                [t.commentState addMultiLineStartMarker:start endMarker:end];
            }
        }
    }

    // delimited strings
    toks = [NSArray arrayWithArray:[parserTokensTable objectForKey:@"@delimitedString"]];
    toks = [toks arrayByAddingObjectsFromArray:[parserTokensTable objectForKey:@"@delimitedStrings"]];
    NSAssert(0 == toks.count % 3, @"@delimitedString must be specified as quoted strings in multiples of 3");
    if (toks.count > 1) {
        NSInteger i = 0;
        for ( ; i < toks.count - 2; i++) {
            TDToken *startTok = [toks objectAtIndex:i];
            TDToken *endTok = [toks objectAtIndex:++i];
            TDToken *charSetTok = [toks objectAtIndex:++i];
            if (startTok.isQuotedString && endTok.isQuotedString) {
                NSString *start = [startTok.stringValue stringByTrimmingQuotes];
                NSString *end = [endTok.stringValue stringByTrimmingQuotes];
                NSCharacterSet *charSet = nil;
                if (charSetTok.isQuotedString) {
                    charSet = [NSCharacterSet characterSetWithCharactersInString:[charSetTok.stringValue stringByTrimmingQuotes]];
                }
                [t.delimitState addStartMarker:start endMarker:end allowedCharacterSet:charSet];
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


- (void)setFallbackStateOn:(TDTokenizerState *)state withTokenizer:(TDTokenizer *)t forTokensForKey:(NSString *)key {
    NSArray *toks = [parserTokensTable objectForKey:key];
    if (toks.count) {
        TDToken *tok = [toks objectAtIndex:0];
        if (tok.isWord) {
            TDTokenizerState *fallbackState = [t valueForKey:tok.stringValue];
            if (state != fallbackState) {
                state.fallbackState = fallbackState;
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

        TDParser *p = [[NSClassFromString(className) alloc] init];
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


- (id)expandParser:(TDParser *)p fromTokenArray:(NSArray *)toks {	
    TDAssembly *a = [TDTokenAssembly assemblyWithTokenArray:toks];
    a.target = parserTokensTable;
    a = [self.exprParser completeMatchFor:a];
    TDParser *res = [a pop];
    if ([p isKindOfClass:[TDCollectionParser class]]) {
        TDCollectionParser *cp = (TDCollectionParser *)p;
        [cp add:res];
        return cp;
    } else {
        return res;
    }
}


// this is just a utility for unit-testing
- (TDSequence *)parserFromExpression:(NSString *)s {
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    TDAssembly *a = [TDTokenAssembly assemblyWithTokenizer:t];
    a.target = [NSMutableDictionary dictionary]; // setup the variable lookup table
    a = [self.exprParser completeMatchFor:a];
    return [a pop];
}


- (TDAlternation *)zeroOrOne:(TDParser *)p {
    TDAlternation *a = [TDAlternation alternation];
    [a add:[TDEmpty empty]];
    [a add:p];
    return a;
}


- (TDSequence *)oneOrMore:(TDParser *)p {
    TDSequence *s = [TDSequence sequence];
    [s add:p];
    [s add:[TDRepetition repetitionWithSubparser:p]];
    return s;
}


// @start               = statement*
// satement             = declaration '=' expr
// declaration          = Word callback?
// callback             = '(' selector ')'
// selector             = Word ':'
// expr                 = term orTerm*
// term                 = factor nextFactor*
// orTerm               = '|' term
// factor               = phrase | phraseStar | phrasePlus | phraseQuestion | phraseCardinality
// nextFactor           = factor
// phrase               = primaryExpr predicate*
// predicate            = inclusion | exclusion;
// primaryExpr          = atomicValue | '(' expr ')'
// inclusion            = '[' primaryExpr ']'
// exclusion            = '-' primaryExpr
// phraseStar           = phrase '*'
// phrasePlus           = phrase '+'
// phraseQuestion       = phrase '?'
// phraseCardinality    = phrase cardinality
// cardinality          = '{' Num (',' Num)? '}'
// atomicValue          = discard? (literal | variable | constant | pattern | delimitedString)
// discard              = '^'
// literal              = QuotedString
// variable             = LowercaseWord
// constant             = UppercaseWord 
// pattern              = DelimitedString('/', '/')


// satement             = declaration '=' expr
- (TDCollectionParser *)statementParser {
    if (!statementParser) {
        self.statementParser = [TDTrack track];
        statementParser.name = @"statement";
        [statementParser add:self.declarationParser];
        [statementParser add:[TDSymbol symbolWithString:@"="]];

        // accept any tokens in the parser expr the first time around. just gather tokens for later
        [statementParser add:[self oneOrMore:[TDAny any]]];
        [statementParser setAssembler:self selector:@selector(workOnStatement:)];
    }
    return statementParser;
}


// declaration          = productionName callback?
- (TDCollectionParser *)declarationParser {
    if (!declarationParser) {
        self.declarationParser = [TDTrack track];
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
        [callbackParser setAssembler:self selector:@selector(workOnCallback:)];
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


// expr        = term orTerm*
- (TDCollectionParser *)exprParser {
    if (!exprParser) {
        self.exprParser = [TDSequence sequence];
        exprParser.name = @"expr";
        [exprParser add:self.termParser];
        [exprParser add:[TDRepetition repetitionWithSubparser:self.orTermParser]];
        [exprParser setAssembler:self selector:@selector(workOnExpression:)];
    }
    return exprParser;
}


// term                = factor nextFactor*
- (TDCollectionParser *)termParser {
    if (!termParser) {
        self.termParser = [TDSequence sequence];
        termParser.name = @"term";
        [termParser add:self.factorParser];
        [termParser add:[TDRepetition repetitionWithSubparser:self.nextFactorParser]];
        [termParser setAssembler:self selector:@selector(workOnAnd:)];
    }
    return termParser;
}


// orTerm            = '|' term
- (TDCollectionParser *)orTermParser {
    if (!orTermParser) {
        self.orTermParser = [TDTrack track];
        orTermParser.name = @"orTerm";
        [orTermParser add:[TDSymbol symbolWithString:@"|"]]; // preserve as fence
        [orTermParser add:self.termParser];
        [orTermParser setAssembler:self selector:@selector(workOnOr:)];
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


// phrase               = primaryExpr predicate*
- (TDCollectionParser *)phraseParser {
    if (!phraseParser) {
        self.phraseParser = [TDSequence sequence];
        phraseParser.name = @"phrase";
        [phraseParser add:self.primaryExprParser];
        [phraseParser add:[TDRepetition repetitionWithSubparser:self.predicateParser]];
    }
    return phraseParser;
}


// primaryExpr          = atomicValue | '(' expr ')'
- (TDCollectionParser *)primaryExprParser {
    if (!primaryExprParser) {
        self.primaryExprParser = [TDAlternation alternation];
        primaryExprParser.name = @"primaryExpr";
        [primaryExprParser add:self.atomicValueParser];

        TDSequence *s = [TDSequence sequence];
        [s add:[TDSymbol symbolWithString:@"("]];
        [s add:self.exprParser];
        [s add:[[TDSymbol symbolWithString:@")"] discard]];
        
        [primaryExprParser add:s];
    }
    return primaryExprParser;
}


// predicate            = inclusion | exclusion
- (TDCollectionParser *)predicateParser {
    if (!predicateParser) {
        self.predicateParser = [TDAlternation alternation];
        predicateParser.name = @"predicate";
        [predicateParser add:self.inclusionParser];
        [predicateParser add:self.exclusionParser];
    }
    return predicateParser;
}


// inclusion            = '[' primaryExpr ']'
- (TDCollectionParser *)inclusionParser {
    if (!inclusionParser) {
        self.inclusionParser = [TDTrack track];
        inclusionParser.name = @"inclusion";
        [inclusionParser add:[TDSymbol symbolWithString:@"["]]; // fence
        [inclusionParser add:self.primaryExprParser];
        [inclusionParser add:[[TDSymbol symbolWithString:@"]"] discard]];
        [inclusionParser setAssembler:self selector:@selector(workOnInclusion:)];
    }
    return inclusionParser;
}


// exclusion            = '-' primaryExpr
- (TDCollectionParser *)exclusionParser {
    if (!exclusionParser) {
        self.exclusionParser = [TDTrack track];
        inclusionParser.name = @"exclusion";
        [exclusionParser add:[[TDSymbol symbolWithString:@"-"] discard]];
        [exclusionParser add:self.primaryExprParser];
        [exclusionParser setAssembler:self selector:@selector(workOnExclusion:)];
    }
    return exclusionParser;
}


// phraseStar        = phrase '*'
- (TDCollectionParser *)phraseStarParser {
    if (!phraseStarParser) {
        self.phraseStarParser = [TDSequence sequence];
        phraseStarParser.name = @"phraseStar";
        [phraseStarParser add:self.phraseParser];
        [phraseStarParser add:[[TDSymbol symbolWithString:@"*"] discard]];
        [phraseStarParser setAssembler:self selector:@selector(workOnStar:)];
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
        [phrasePlusParser setAssembler:self selector:@selector(workOnPlus:)];
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
        [phraseQuestionParser setAssembler:self selector:@selector(workOnQuestion:)];
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
        [phraseCardinalityParser setAssembler:self selector:@selector(workOnPhraseCardinality:)];
    }
    return phraseCardinalityParser;
}


// cardinality          = '{' Num (',' Num)? '}'
- (TDCollectionParser *)cardinalityParser {
    if (!cardinalityParser) {
        self.cardinalityParser = [TDTrack track];
        cardinalityParser.name = @"cardinality";
        
        TDTrack *commaNum = [TDTrack track];
        [commaNum add:[[TDSymbol symbolWithString:@","] discard]];
        [commaNum add:[TDNum num]];
        
        [cardinalityParser add:[TDSymbol symbolWithString:@"{"]]; // serves as fence. dont discard
        [cardinalityParser add:[TDNum num]];
        [cardinalityParser add:[self zeroOrOne:commaNum]];
        [cardinalityParser add:[[TDSymbol symbolWithString:@"}"] discard]];
        [cardinalityParser setAssembler:self selector:@selector(workOnCardinality:)];
    }
    return cardinalityParser;
}


// atomicValue          =  discard? (pattern | literal | variable | constant | delimitedString)
- (TDCollectionParser *)atomicValueParser {
    if (!atomicValueParser) {
        self.atomicValueParser = [TDSequence sequence];
        atomicValueParser.name = @"atomicValue";

        [atomicValueParser add:[self zeroOrOne:self.discardParser]];
        
        TDAlternation *a = [TDAlternation alternation];
        [a add:self.patternParser];
        [a add:self.literalParser];
        [a add:self.variableParser];
        [a add:self.constantParser];
        [a add:self.delimitedStringParser];
        [atomicValueParser add:a];
    }
    return atomicValueParser;
}


// discard              = '^'
- (TDCollectionParser *)discardParser {
    if (!discardParser) {
        self.discardParser = [TDTrack track];
        discardParser.name = @"discardParser";
        [discardParser add:[TDSymbol symbolWithString:@"^"]]; // preserve
    }
    return discardParser;
}


// pattern              = DelimitedString('/', '/');
- (TDParser *)patternParser {
    if (!patternParser) {
        patternParser.name = @"pattern";
        self.patternParser = [TDDelimitedString delimitedStringWithStartMarker:@"/" endMarker:@"/"];
        [patternParser setAssembler:self selector:@selector(workOnPattern:)];
    }
    return patternParser;
}


// literal = QuotedString
- (TDParser *)literalParser {
    if (!literalParser) {
        self.literalParser = [TDQuotedString quotedString];
        [literalParser setAssembler:self selector:@selector(workOnLiteral:)];
    }
    return literalParser;
}


// variable = LowercaseWord
- (TDParser *)variableParser {
    if (!variableParser) {
        self.variableParser = [TDLowercaseWord word];
        variableParser.name = @"variable";
        [variableParser setAssembler:self selector:@selector(workOnVariable:)];
    }
    return variableParser;
}


// constant = UppercaseWord
- (TDParser *)constantParser {
    if (!constantParser) {
        self.constantParser = [TDUppercaseWord word];
        constantParser.name = @"constant";
        [constantParser setAssembler:self selector:@selector(workOnConstant:)];
    }
    return constantParser;
}


// delimitedString = 'DelimitedString' '(' QuotedString (',' QuotedString)? ')'
- (TDCollectionParser *)delimitedStringParser {
    if (!delimitedStringParser) {
        self.delimitedStringParser = [TDTrack track];
        delimitedStringParser.name = @"delimitedString";
        
        TDSequence *secondArg = [TDTrack track];
        [secondArg add:[[TDSymbol symbolWithString:@","] discard]];
        [secondArg add:[TDQuotedString quotedString]]; // endMarker
        
        [delimitedStringParser add:[[TDLiteral literalWithString:@"DelimitedString"] discard]];
        [delimitedStringParser add:[TDSymbol symbolWithString:@"("]]; // preserve as fence
        [delimitedStringParser add:[TDQuotedString quotedString]]; // startMarker
        [delimitedStringParser add:[self zeroOrOne:secondArg]];
        [delimitedStringParser add:[[TDSymbol symbolWithString:@")"] discard]];

        [delimitedStringParser setAssembler:self selector:@selector(workOnDelimitedString:)];
    }
    return delimitedStringParser;
}


- (BOOL)shouldDiscard:(TDAssembly *)a {
    if (![a isStackEmpty]) {
        id obj = [a pop];
        if ([obj isEqual:caret]) {
            return YES;
        } else {
            [a push:obj];
        }
    }
    return NO;
}


- (void)workOnStatement:(TDAssembly *)a {
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
        NSAssert(selName.length, @"");
        [selectorTable setObject:selName forKey:parserName];
    }
	NSMutableDictionary *d = a.target;
    NSAssert(toks.count, @"");
    
    // support for multiple @delimitedString = ... tokenizer directives
    if ([parserName hasPrefix:@"@"]) {
        NSArray *existingToks = [d objectForKey:parserName];
        if (existingToks.count) {
            toks = [toks arrayByAddingObjectsFromArray:existingToks];
        }
    }
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
    return [NSString stringWithFormat:@"%@%@:", prefix, s];
}


- (void)workOnCallback:(TDAssembly *)a {
    TDToken *selNameTok = [a pop];
    NSString *selName = [NSString stringWithFormat:@"%@:", selNameTok.stringValue];
    [a push:selName];
}


- (void)workOnExpression:(TDAssembly *)a {
    NSArray *objs = [a objectsAbove:paren];
    NSAssert(objs.count, @"");
    
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


- (void)workOnExclusion:(TDAssembly *)a {
    TDParser *predicate = [a pop];
    TDParser *sub = [a pop];
    NSAssert([predicate isKindOfClass:[TDParser class]], @"");
    NSAssert([sub isKindOfClass:[TDParser class]], @"");
    
    [a push:[TDExclusion exclusionWithSubparser:sub predicate:predicate]];
}


- (void)workOnInclusion:(TDAssembly *)a {
    NSArray *objs = [a objectsAbove:bracket];
    [a pop]; // discard '['
    
    if (objs.count) {
        TDParser *predicate = [objs objectAtIndex:0];
        TDParser *sub = [a pop];
        
        NSAssert([predicate isKindOfClass:[TDParser class]], @"");
        NSAssert([sub isKindOfClass:[TDParser class]], @"");
        
        [a push:[TDInclusion inclusionWithSubparser:sub predicate:predicate]];
    }
}


- (void)workOnPattern:(TDAssembly *)a {
    TDToken *tok = [a pop];
    NSAssert(tok.isDelimitedString, @"");

    NSString *s = tok.stringValue;
    NSAssert(s.length > 2, @"");
    
    NSAssert([s hasPrefix:@"/"], @"");
    NSAssert([s hasSuffix:@"/"], @"");

    NSString *re = [s stringByTrimmingQuotes];

    TDPatternOptions opts = TDPatternOptionsNone;
//    if (NSNotFound != [optsString rangeOfString:@"i"].location) {
//        opts |= TDPatternOptionsIgnoreCase;
//    }
//    if (NSNotFound != [optsString rangeOfString:@"m"].location) {
//        opts |= TDPatternOptionsMultiline;
//    }
//    if (NSNotFound != [optsString rangeOfString:@"x"].location) {
//        opts |= TDPatternOptionsComments;
//    }
//    if (NSNotFound != [optsString rangeOfString:@"s"].location) {
//        opts |= TDPatternOptionsDotAll;
//    }
//    if (NSNotFound != [optsString rangeOfString:@"w"].location) {
//        opts |= TDPatternOptionsUnicodeWordBoundaries;
//    }
    
    TDTerminal *t = [TDPattern patternWithString:re options:opts tokenType:TDTokenTypeAny];
    
    if ([self shouldDiscard:a]) {
        [t discard];
    }
    
    [a push:t];
}


- (void)workOnLiteral:(TDAssembly *)a {
    TDToken *tok = [a pop];

    NSString *s = [tok.stringValue stringByTrimmingQuotes];
    TDTerminal *t = [TDCaseInsensitiveLiteral literalWithString:s];

    if ([self shouldDiscard:a]) {
        [t discard];
    }
    
    [a push:t];
}


- (void)workOnVariable:(TDAssembly *)a {
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
        if ([parserTokensTable objectForKey:parserName]) {
            p = [self expandedParserForName:parserName];
        }
    }
    [a push:p];
}


- (void)workOnConstant:(TDAssembly *)a {
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
    } else if ([s isEqualToString:@"S"]) {
        p = [TDWhitespace whitespace];
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
    } else if ([s isEqualToString:@"DelimitedString"]) {
        p = tok;
    } else if ([s isEqualToString:@"YES"] || [s isEqualToString:@"NO"]) {
        p = tok;
    } else {
        [NSException raise:@"Grammar Exception" format:
         @"User Grammar referenced a constant parser name (uppercase word) which is not supported: %@. Must be one of: Word, LowercaseWord, UppercaseWord, QuotedString, Num, Symbol, Empty.", s];
    }
    
    if ([p isKindOfClass:[TDTerminal class]] && [self shouldDiscard:a]) {
        TDTerminal *t = (TDTerminal *)p;
        [t discard];
    }
    
    [a push:p];
}


- (void)workOnDelimitedString:(TDAssembly *)a {
    NSArray *toks = [a objectsAbove:paren];
    [a pop]; // discard '(' fence
    
    NSAssert(toks.count > 0 && toks.count < 3, @"");
    NSString *start = [[[toks lastObject] stringValue] stringByTrimmingQuotes];
    NSString *end = nil;
    if (toks.count > 1) {
        end = [[[toks objectAtIndex:0] stringValue] stringByTrimmingQuotes];
    }

    TDTerminal *t = [TDDelimitedString delimitedStringWithStartMarker:start endMarker:end];
    
    if ([self shouldDiscard:a]) {
        [t discard];
    }
    
    [a push:t];
}


- (void)workOnNum:(TDAssembly *)a {
    TDToken *tok = [a pop];
    [a push:[NSNumber numberWithFloat:tok.floatValue]];
}


- (void)workOnStar:(TDAssembly *)a {
    id top = [a pop];
    TDRepetition *rep = [TDRepetition repetitionWithSubparser:top];
    [a push:rep];
}


- (void)workOnPlus:(TDAssembly *)a {
    id top = [a pop];
    [a push:[self oneOrMore:top]];
}


- (void)workOnQuestion:(TDAssembly *)a {
    id top = [a pop];
    [a push:[self zeroOrOne:top]];
}


- (void)workOnPhraseCardinality:(TDAssembly *)a {
    NSRange r = [[a pop] rangeValue];
    TDParser *p = [a pop];
    TDSequence *s = [TDSequence sequence];
    
    NSInteger start = r.location;
    NSInteger end = r.length;
    
    NSInteger i = 0;
    for ( ; i < start; i++) {
        [s add:p];
    }
    
    for ( ; i < end; i++) {
        [s add:[self zeroOrOne:p]];
    }
    
    [a push:s];
}


- (void)workOnCardinality:(TDAssembly *)a {
    NSArray *toks = [a objectsAbove:self.curly];
    [a pop]; // discard '{' tok

    NSAssert(toks.count > 0, @"");
    
    CGFloat start = [[toks lastObject] floatValue];
    CGFloat end = start;
    if (toks.count > 1) {
        end = [[toks objectAtIndex:0] floatValue];
    }
    
    NSAssert(start <= end, @"");
    
    NSRange r = NSMakeRange(start, end);
    [a push:[NSValue valueWithRange:r]];
}


- (void)workOnOr:(TDAssembly *)a {
    id second = [a pop];
    [a pop]; // pop '|'
    id first = [a pop];
    TDAlternation *p = [TDAlternation alternation];
    [p add:first];
    [p add:second];
    [a push:p];
}


- (void)workOnAnd:(TDAssembly *)a {
    NSMutableArray *parsers = [NSMutableArray array];
    while (![a isStackEmpty]) {
        id obj = [a pop];
        if ([obj isKindOfClass:[TDParser class]]) {
            [parsers addObject:obj];
        } else {
            [a push:obj];
            break;
        }
    }
    
    if (parsers.count > 1) {
        TDSequence *seq = [TDSequence sequence];
        for (TDParser *p in [parsers reverseObjectEnumerator]) {
            [seq add:p];
        }
        
        [a push:seq];
    } else if (1 == parsers.count) {
        [a push:[parsers objectAtIndex:0]];
    }
}

@synthesize assembler;
@synthesize parserTokensTable;
@synthesize parserClassTable;
@synthesize selectorTable;
@synthesize equals;
@synthesize curly;
@synthesize paren;
@synthesize bracket;
@synthesize caret;
@synthesize statementParser;
@synthesize declarationParser;
@synthesize callbackParser;
@synthesize selectorParser;
@synthesize exprParser;
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
@synthesize primaryExprParser;
@synthesize predicateParser;
@synthesize inclusionParser;
@synthesize exclusionParser;
@synthesize atomicValueParser;
@synthesize discardParser;
@synthesize patternParser;
@synthesize literalParser;
@synthesize variableParser;
@synthesize constantParser;
@synthesize delimitedStringParser;
@synthesize assemblerSettingBehavior;
@end
