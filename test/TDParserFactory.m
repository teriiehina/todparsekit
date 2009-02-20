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
        r.subparser = nil;
    }
}

@interface TDParserFactory ()
- (id)parserTokensTableFromParsingStatementsInString:(NSString *)s;
- (void)gatherParserClassNamesFromTokens;
- (NSString *)parserClassNameFromTokenArray:(NSArray *)toks;

- (TDParser *)parserFromGrammar:(NSString *)s assembler:(id)a getTokenizer:(TDTokenizer **)t wantsTokenizer:(BOOL)wantsTokenizer;
- (TDTokenizer *)tokenizerFromGrammarSettings;
- (void)setTokenizerState:(TDTokenizerState *)state onTokenizer:(TDTokenizer *)t forTokensForKey:(NSString *)key;

- (id)expandParser:(TDCollectionParser *)p fromTokenArray:(NSArray *)toks;
- (TDParser *)expandedParserForName:(NSString *)parserName;
- (void)setAssemblerForParser:(TDParser *)p;
- (NSString *)defaultAssemblerSelectorNameForParserName:(NSString *)parserName;

// this is only for unit tests? can it go away?
- (TDSequence *)parserFromExpression:(NSString *)s;

@property (nonatomic, assign) id assembler;
@property (nonatomic, retain) NSMutableDictionary *parserTokensTable;
@property (nonatomic, retain) NSMutableDictionary *parserClassTable;
@property (nonatomic, retain) NSMutableDictionary *selectorTable;
@property (nonatomic, retain) TDToken *equals;
@property (nonatomic, retain) TDToken *curly;
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
    self = [super init];
    if (self) {
        self.equals = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:@"=" floatValue:0.0];
        self.curly = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:@"{" floatValue:0.0];
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
    self.discardParser = nil;
    self.literalParser = nil;
    self.variableParser = nil;
    self.constantParser = nil;
    self.numParser = nil;
    [super dealloc];
}


- (TDParser *)parserFromGrammar:(NSString *)s assembler:(id)a {
    return [self parserFromGrammar:s assembler:a getTokenizer:nil wantsTokenizer:NO];
}    


- (TDParser *)parserFromGrammar:(NSString *)s assembler:(id)a getTokenizer:(TDTokenizer **)t {
    return [self parserFromGrammar:s assembler:a getTokenizer:t wantsTokenizer:YES];
}


- (TDParser *)parserFromGrammar:(NSString *)s assembler:(id)a getTokenizer:(TDTokenizer **)t wantsTokenizer:(BOOL)wantsTokenizer {
    self.assembler = a;
    self.selectorTable = [NSMutableDictionary dictionary];
    self.parserClassTable = [NSMutableDictionary dictionary];
    self.parserTokensTable = [self parserTokensTableFromParsingStatementsInString:s];

    [self gatherParserClassNamesFromTokens];
    if (wantsTokenizer) {
        (*t) = [self tokenizerFromGrammarSettings];
    }
        
    TDParser *start = [self expandedParserForName:@"@start"]; // retain to survive pool release
    
    assembler = nil;
    self.selectorTable = nil;
    self.parserClassTable = nil;
    self.parserTokensTable = nil;
    
    if (start && [start isKindOfClass:[TDParser class]]) {
        return start;
    } else {
        [NSException raise:@"GrammarException" format:@"The provided language grammar was invalid"];
        return nil;
    }
}


- (id)parserTokensTableFromParsingStatementsInString:(NSString *)s {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
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
    
    [target retain]; // retain to survive the pool releaase
    [pool drain];
    
    return [target autorelease]; // autorelease it to balance
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
    [t.commentState removeSingleLineStartSymbol:@"//"];
    [t.commentState removeMultiLineStartSymbol:@"/*"];
    
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
    
    // comments stuff
    toks = [parserTokensTable objectForKey:@"@reportsWhitespaceTokens"];
    for (TDToken *tok in toks) {
        if (tok.isWord) {
			BOOL report = NO;
			if ([tok.stringValue isEqualToString:@"YES"]) {
				report = YES;
			}
			t.whitespaceState.reportsWhitespaceTokens = report;
        }
    }

    // comments stuff
    toks = [parserTokensTable objectForKey:@"@reportsCommentTokens"];
    for (TDToken *tok in toks) {
        if (tok.isWord) {
			BOOL report = NO;
			if ([tok.stringValue isEqualToString:@"YES"]) {
				report = YES;
			}
			t.commentState.reportsCommentTokens = report;
        }
    }

    // single line comments
    toks = [parserTokensTable objectForKey:@"@singleLineComments"];
    for (TDToken *tok in toks) {
        if (tok.isQuotedString) {
            NSString *s = [tok.stringValue stringByTrimmingQuotes];
            [t.commentState addSingleLineStartSymbol:s];
            [t.symbolState add:s];
        }
    }
    
    // multi line comments
    toks = [parserTokensTable objectForKey:@"@multiLineComments"];
    if (toks.count > 1) {
        NSInteger i = 0;
        for ( ; i < toks.count - 1; i++) {
            TDToken *startTok = [toks objectAtIndex:i];
            TDToken *endTok = [toks objectAtIndex:++i];
            if (startTok.isQuotedString && endTok.isQuotedString) {
                NSString *start = [startTok.stringValue stringByTrimmingQuotes];
                NSString *end = [endTok.stringValue stringByTrimmingQuotes];
                [t.commentState addMultiLineStartSymbol:start endSymbol:end];
                [t.symbolState add:start];
                [t.symbolState add:end];
            }
        }
    }
    
    return t;
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
// atomicValue          = (literal | variable | constant) discard?
// discard              = '.' 'discard'
// literal              = QuotedString
// variable             = LowercaseWord
// constant             = UppercaseWord


// satement             = declaration '=' expression
- (TDCollectionParser *)statementParser {
    if (!statementParser) {
        self.statementParser = [TDTrack track];
        statementParser.name = @"statement";
        [statementParser add:self.declarationParser];
        [statementParser add:[TDSymbol symbolWithString:@"="]];

        // accept any tokens in the parser expr the first time around. just gather tokens for later
        TDSequence *seq = [TDSequence sequence];
        [seq add:[TDAny any]];
        [seq add:[TDRepetition repetitionWithSubparser:[TDAny any]]];
        [statementParser add:seq];
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
        
        TDAlternation *a = [TDAlternation alternation];
        [a add:[TDEmpty empty]];
        [a add:self.callbackParser];
        [declarationParser add:a];
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


// atomicValue          = (literal | variable | constant) discard?
- (TDCollectionParser *)atomicValueParser {
    if (!atomicValueParser) {
        self.atomicValueParser = [TDSequence sequence];
        atomicValueParser.name = @"atomicValue";
        
        TDAlternation *a = [TDAlternation alternation];
        [a add:self.literalParser];
        [a add:self.variableParser];
        [a add:self.constantParser];
        [atomicValueParser add:a];

        a = [TDAlternation alternation];
        [a add:[TDEmpty empty]];
        [a add:self.discardParser];
        [atomicValueParser add:a];
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
    [a.target setObject:toks forKey:parserName];
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
    NSArray *objs = [a objectsAbove:equals];
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
        p = [a.target objectForKey:parserName];
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
    TDSequence *seq = [TDSequence sequence];
    [seq add:top];
    [seq add:[TDRepetition repetitionWithSubparser:top]];
    [a push:seq];
}


- (void)workOnQuestionAssembly:(TDAssembly *)a {
    id top = [a pop];
    TDAlternation *alt = [TDAlternation alternation];
    [alt add:[TDEmpty empty]];
    [alt add:top];
    [a push:alt];
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
@synthesize literalParser;
@synthesize variableParser;
@synthesize constantParser;
@synthesize numParser;
@synthesize assemblerSettingBehavior;
@end
