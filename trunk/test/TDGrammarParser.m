//
//  TDGrammarParser.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/12/08.
//  Copyright 2008 Todd Ditchendorf All rights reserved.
//

#import "TDGrammarParser.h"
#import "NSString+TDParseKitAdditions.h"

/*
 start              = statement*
 statement			= exprOrAssignment ';'
 exprOrAssignment	= expression | assigment
 assigment			= declaration '=' expression
 declaration		= '$' Word
 variable			= '$' Word
 expression			= term orTerm*
 term				= factor nextFactor*
 orTerm				= '|' term
 factor				= phrase | phraseStar | phraseQuestion | phrasePlus
 nextFactor			= factor
 phrase				= atomicValue | '(' expression ')'
 phraseStar			= phrase '*'
 phraseQuestion		= phrase '?'
 phrasePlus			= phrase '+'
 atomicValue        = Word | Num | QuotedString | variable
*/

static NSString * const kTDEqualsString = @"=";
static NSString * const kTDVariablePrefix = @"$";
static NSString * const kTDVariableSuffix = @"";

@interface TDGrammarParser ()
@property (retain, readwrite) TDTokenizer *tokenizer;
- (void)addSymbolString:(NSString *)s toTokenizer:(TDTokenizer *)t;

- (void)workOnWordAssembly:(TDAssembly *)a;
- (void)workOnNumAssembly:(TDAssembly *)a;
- (void)workOnQuotedStringAssembly:(TDAssembly *)a;
- (void)workOnStarAssembly:(TDAssembly *)a;
- (void)workOnQuestionAssembly:(TDAssembly *)a;
- (void)workOnPlusAssembly:(TDAssembly *)a;
- (void)workOnTermAssembly:(TDAssembly *)a;
- (void)workOnAndAssembly:(TDAssembly *)a;
- (void)workOnOrAssembly:(TDAssembly *)a;
- (void)workOnAssignmentAssembly:(TDAssembly *)a;
- (void)workOnVariableAssembly:(TDAssembly *)a;
@end

@implementation TDGrammarParser

- (id)init {
    self = [super initWithSubparser:self.statementParser];
    if (self) {
    }
    return self;
}


- (void)dealloc {
    self.statementParser = nil;
    self.exprOrAssignmentParser = nil;
    self.assignmentParser = nil;
    self.declarationParser = nil;
    self.variableParser = nil;
    self.expressionParser = nil;
    self.termParser = nil;
    self.orTermParser = nil;
    self.factorParser = nil;
    self.nextFactorParser = nil;
    self.phraseParser = nil;
    self.phraseStarParser = nil;
    self.phraseQuestionParser = nil;
    self.phrasePlusParser = nil;
    self.atomicValueParser = nil;
    [super dealloc];
}


- (id)parse:(NSString *)s {
    self.tokenizer.string = s;
    TDTokenAssembly *a = [TDTokenAssembly assemblyWithTokenizer:self.tokenizer];
    TDAssembly *result = [self completeMatchFor:a];
    return [result pop];
}


- (TDTokenizer *)tokenizer {
    if (!tokenizer) {
        self.tokenizer = [[[TDTokenizer alloc] init] autorelease];
        [self addSymbolString:kTDEqualsString toTokenizer:tokenizer];
        [self addSymbolString:kTDVariablePrefix toTokenizer:tokenizer];
        [self addSymbolString:kTDVariableSuffix toTokenizer:tokenizer];
    }
    return tokenizer;
}


- (void)addSymbolString:(NSString *)s toTokenizer:(TDTokenizer *)t {
    if (s.length) {
        NSInteger c = [s characterAtIndex:0];
        [t setTokenizerState:t.symbolState from:c to:c];
        [t.symbolState add:s];
    }
}


// statement        = exprOrAssignment ';'
- (TDCollectionParser *)statementParser {
    if (!statementParser) {
        self.statementParser = [TDTrack track];
        statementParser.name = @"statement";
        [statementParser add:self.exprOrAssignmentParser];
        [statementParser add:[[TDSymbol symbolWithString:@";"] discard]];
    }
    return statementParser;
}


// exprOrAssignmentParser        = expression | assignment
- (TDCollectionParser *)exprOrAssignmentParser {
    if (!exprOrAssignmentParser) {
        exprOrAssignmentParser.name = @"exprOrAssignment";
        self.exprOrAssignmentParser = [TDAlternation alternation];
        [exprOrAssignmentParser add:self.expressionParser];
        [exprOrAssignmentParser add:self.assignmentParser];
    }
    return exprOrAssignmentParser;
}


// declaration        = variable '=' expression
- (TDCollectionParser *)assignmentParser {
    if (!assignmentParser) {
        assignmentParser.name = @"assignment";
        self.assignmentParser = [TDSequence sequence];
        [assignmentParser add:self.declarationParser];
        [assignmentParser add:[[TDSymbol symbolWithString:kTDEqualsString] discard]];
        [assignmentParser add:self.expressionParser];
        [assignmentParser setAssembler:self selector:@selector(workOnAssignmentAssembly:)];
    }
    return assignmentParser;
}


// declaration            = '$' Word
- (TDCollectionParser *)declarationParser {
    if (!declarationParser) {
        declarationParser.name = @"declaration";
        self.declarationParser = [TDTrack track];
        [declarationParser add:[[TDSymbol symbolWithString:kTDVariablePrefix] discard]];
        [declarationParser add:[TDWord word]];
        if (kTDVariableSuffix.length) {
            [declarationParser add:[[TDSymbol symbolWithString:kTDVariableSuffix] discard]];
        }
    }
    return declarationParser;
}


// variable            = '$' Word
- (TDCollectionParser *)variableParser {
    if (!variableParser) {
        variableParser.name = @"variable";
        self.variableParser = [TDTrack track];
        [variableParser add:[[TDSymbol symbolWithString:kTDVariablePrefix] discard]];
        [variableParser add:[TDWord word]];
        if (kTDVariableSuffix.length) {
            [variableParser add:[[TDSymbol symbolWithString:kTDVariableSuffix] discard]];
        }
    }
    return variableParser;
}


// expression        = term orTerm*
- (TDCollectionParser *)expressionParser {
    if (!expressionParser) {
        expressionParser.name = @"expression";
        self.expressionParser = [TDSequence sequence];
        [expressionParser add:self.termParser];
        [expressionParser add:[TDRepetition repetitionWithSubparser:self.orTermParser]];
    }
    return expressionParser;
}


// term                = factor nextFactor*
- (TDCollectionParser *)termParser {
    if (!termParser) {
        self.termParser = [TDSequence sequence];
        termParser.name = @"term";
        [termParser add:self.factorParser];
        TDRepetition *r = [TDRepetition repetitionWithSubparser:self.nextFactorParser];
        [termParser add:r];
        [termParser setAssembler:self selector:@selector(workOnTermAssembly:)];
    }
    return termParser;
}


// orTerm            = '|' term
- (TDCollectionParser *)orTermParser {
    if (!orTermParser) {
        orTermParser.name = @"orTerm";
        self.orTermParser = [TDTrack track];
        [orTermParser add:[[TDSymbol symbolWithString:@"|"] discard]];
        [orTermParser add:self.termParser];
        [orTermParser setAssembler:self selector:@selector(workOnOrAssembly:)];
    }
    return orTermParser;
}


// factor            = phrase | phraseStar | phraseQuestion | phrasePlus
- (TDCollectionParser *)factorParser {
    if (!factorParser) {
        self.factorParser = [TDAlternation alternation];
        factorParser.name = @"factor";
        [factorParser add:self.phraseParser];
        [factorParser add:self.phraseStarParser];
        [factorParser add:self.phraseQuestionParser];
        [factorParser add:self.phrasePlusParser];
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
        [nextFactorParser add:self.phraseQuestionParser];
        [nextFactorParser add:self.phrasePlusParser];
        
//        [nextFactorParser setAssembler:self selector:@selector(workOnAndAssembly:)];
    }
    return nextFactorParser;
}


// phrase            = atomicValue | '(' expression ')'
- (TDCollectionParser *)phraseParser {
    if (!phraseParser) {
        TDSequence *s = [TDTrack track];
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


// phraseQuestion        = phrase '?'
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


// phrasePlus            = phrase '+'
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


// atomicValue        = Word | Num | QuotedString | Variable
- (TDCollectionParser *)atomicValueParser {
    if (!atomicValueParser) {
        self.atomicValueParser = [TDAlternation alternation];
        atomicValueParser.name = @"atomicValue";
        
        TDParser *p = [TDWord word];
        [p setAssembler:self selector:@selector(workOnWordAssembly:)];
        [atomicValueParser add:p];
        
        p = [TDNum num];
        [p setAssembler:self selector:@selector(workOnNumAssembly:)];
        [atomicValueParser add:p];
        
        p = [TDQuotedString quotedString];
        [p setAssembler:self selector:@selector(workOnQuotedStringAssembly:)];
        [atomicValueParser add:p];
        
        p = self.variableParser;
        [p setAssembler:self selector:@selector(workOnVariableAssembly:)];
        [atomicValueParser add:p];
    }
    return atomicValueParser;
}


- (void)workOnWordAssembly:(TDAssembly *)a {
    //    NSLog(@"%s", _cmd);
    //    NSLog(@"a: %@", a);
    TDToken *tok = [a pop];
    [a push:[TDLiteral literalWithString:tok.stringValue]];
}


- (void)workOnNumAssembly:(TDAssembly *)a {
    //    NSLog(@"%s", _cmd);
    //    NSLog(@"a: %@", a);
    TDToken *tok = [a pop];
    [a push:[TDLiteral literalWithString:tok.stringValue]];
}


- (void)workOnQuotedStringAssembly:(TDAssembly *)a {
    //    NSLog(@"%s", _cmd);
    //    NSLog(@"a: %@", a);
    TDToken *tok = [a pop];
    NSString *s = [tok.stringValue stringByRemovingFirstAndLastCharacters];
    
    TDSequence *p = [TDSequence sequence];
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    TDToken *eof = [TDToken EOFToken];
    while (eof != (tok = [t nextToken])) {
        [p add:[TDLiteral literalWithString:tok.stringValue]];
    }
    
    [a push:p];
}


- (void)workOnStarAssembly:(TDAssembly *)a {
    //    NSLog(@"%s", _cmd);
    //    NSLog(@"a: %@", a);
    TDRepetition *p = [TDRepetition repetitionWithSubparser:[a pop]];
    [a push:p];
}


- (void)workOnQuestionAssembly:(TDAssembly *)a {
    //    NSLog(@"%s", _cmd);
    //    NSLog(@"a: %@", a);
    TDAlternation *p = [TDAlternation alternation];
    [p add:[a pop]];
    [p add:[TDEmpty empty]];
    [a push:p];
}


- (void)workOnPlusAssembly:(TDAssembly *)a {
    //    NSLog(@"%s", _cmd);
    //    NSLog(@"a: %@", a);
    id top = [a pop];
    TDSequence *p = [TDSequence sequence];
    [p add:top];
    [p add:[TDRepetition repetitionWithSubparser:top]];
    [a push:p];
}


- (void)workOnAndAssembly:(TDAssembly *)a {
    //    NSLog(@"%s", _cmd);
    //    NSLog(@"a: %@", a);
    id top = [a pop];
    TDSequence *p = [TDSequence sequence];
    [p add:[a pop]];
    [p add:top];
    [a push:p];
}


- (void)workOnTermAssembly:(TDAssembly *)a {
    NSLog(@"%s", _cmd);
    NSLog(@"a: %@", a);

    NSMutableArray *objs = [NSMutableArray array];
    while (![a isStackEmpty]) {
        [objs addObject:[a pop]];
    }

    if (objs.count > 1) {
        TDSequence *p = [TDSequence sequence];
        
        id obj = nil;
        NSEnumerator *e = [objs reverseObjectEnumerator];
        while (obj = [e nextObject]) {
            [p add:obj];
        }
        [a push:p];
    } else if (1 == objs.count) {
        [a push:[objs objectAtIndex:0]];
    }
}


- (void)workOnOrAssembly:(TDAssembly *)a {
    //    NSLog(@"%s", _cmd);
    //    NSLog(@"a: %@", a);
    id top = [a pop];
    //    NSLog(@"top: %@", top);
    //    NSLog(@"top class: %@", [top class]);
    TDAlternation *p = [TDAlternation alternation];
    [p add:[a pop]];
    [p add:top];
    [a push:p];
}


- (void)workOnAssignmentAssembly:(TDAssembly *)a {
    //    NSLog(@"%s", _cmd);
    //    NSLog(@"a: %@", a);
    TDSequence *s = [a pop];
    NSAssert(s.subparsers.count == 2, @"");
    id key = [s.subparsers objectAtIndex:0];
    id val = [s.subparsers objectAtIndex:1];
    NSMutableDictionary *table = [NSMutableDictionary dictionaryWithDictionary:a.target];
    [table setObject:val forKey:key];
    a.target = table;
}


- (void)workOnVariableAssembly:(TDAssembly *)a {
    //    NSLog(@"%s", _cmd);
    //    NSLog(@"a: %@", a);
    TDToken *keyTok = [a pop];
    id val = [a.target objectForKey:keyTok.stringValue];
    if (val) {
        [a push:val];
    }
}

@synthesize tokenizer;
@synthesize statementParser;
@synthesize exprOrAssignmentParser;
@synthesize assignmentParser;
@synthesize declarationParser;
@synthesize variableParser;
@synthesize expressionParser;
@synthesize termParser;
@synthesize orTermParser;
@synthesize factorParser;
@synthesize nextFactorParser;
@synthesize phraseParser;
@synthesize phraseStarParser;
@synthesize phraseQuestionParser;
@synthesize phrasePlusParser;
@synthesize atomicValueParser;
@end
