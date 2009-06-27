//
//  SRGSParser.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/15/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "SRGSParser.h"
#import "NSString+TDParseKitAdditions.h"

@interface SRGSParser ()
- (void)workOnWord:(TDAssembly *)a;
- (void)workOnNum:(TDAssembly *)a;
- (void)workOnQuotedString:(TDAssembly *)a;
- (void)workOnStar:(TDAssembly *)a;
- (void)workOnQuestion:(TDAssembly *)a;
- (void)workOnAnd:(TDAssembly *)a;
- (void)workOnOr:(TDAssembly *)a;
- (void)workOnAssignment:(TDAssembly *)a;
- (void)workOnVariable:(TDAssembly *)a;
@end

@implementation SRGSParser

- (id)init {
    if (self = [super init]) {
        [self add:self.grammar];
    }
    return self;
}


- (void)dealloc {
    self.selfIdentHeader = nil;
    self.ruleName = nil;
    self.tagFormat = nil;
    self.lexiconURI = nil;
    self.weight = nil;
    self.repeat = nil;
    self.probability = nil;
    self.externalRuleRef = nil;
    self.token = nil;
    self.languageAttachment = nil;
    self.tag = nil;
    self.grammar = nil;
    self.declaration = nil;
    self.baseDecl = nil;
    self.languageDecl = nil;
    self.modeDecl = nil;
    self.rootRuleDecl = nil;
    self.tagFormatDecl = nil;
    self.lexiconDecl = nil;
    self.metaDecl = nil;
    self.tagDecl = nil;
    self.ruleDefinition = nil;
    self.scope = nil;
    self.ruleExpansion = nil;
    self.ruleAlternative = nil;
    self.sequenceElement = nil;
    self.subexpansion = nil;
    self.ruleRef = nil;
    self.localRuleRef = nil;
    self.specialRuleRef = nil;
    self.repeatOperator = nil;
    
    self.baseURI = nil;
    self.languageCode = nil;
    self.ABNF_URI = nil;
    self.ABNF_URI_with_Media_Type = nil;
    [super dealloc];
}


- (id)parse:(NSString *)s {
    TDAssembly *a = [self assemblyWithString:s];
    a = [self completeMatchFor:a];
    return [a pop];
}


- (TDAssembly *)assemblyWithString:(NSString *)s {
    TDTokenizer *t = [[[TDTokenizer alloc] initWithString:s] autorelease];
    [t setTokenizerState:t.symbolState from: '-' to: '-'];
    [t setTokenizerState:t.symbolState from: '.' to: '.'];
    //[t.wordState setWordChars:YES from:'-' to:'-'];

    TDTokenAssembly *a = [TDTokenAssembly assemblyWithTokenizer:t];
    //    TDNCNameState *NCNameState = [[[TDNCNameState alloc] init] autorelease];
    return a;
}


//selfIdentHeader ::= '#ABNF' #x20 VersionNumber (#x20 CharEncoding)? ';'
//VersionNumber    ::= '1.0'
//CharEncoding     ::= Nmtoken
- (TDCollectionParser *)selfIdentHeader {
    if (!selfIdentHeader) {
        self.selfIdentHeader = [TDSequence sequence];
        selfIdentHeader.name = @"selfIdentHeader";
        
        [selfIdentHeader add:[TDSymbol symbolWithString:@"#"]];
        [selfIdentHeader add:[TDLiteral literalWithString:@"ABNF"]];
        [selfIdentHeader add:[TDNum num]];  // VersionNumber
        
        TDAlternation *a = [TDAlternation alternation];
        [a add:[TDEmpty empty]];
        [a add:[TDWord word]]; // CharEncoding
        
        [selfIdentHeader add:a];
        [selfIdentHeader add:[TDSymbol symbolWithString:@";"]];
    }
    return selfIdentHeader;
}


//RuleName         ::= '$' ConstrainedName 
//ConstrainedName  ::= Name - (Char* ('.' | ':' | '-') Char*)
- (TDCollectionParser *)ruleName {
    if (!ruleName) {
        self.ruleName = [TDSequence sequence];
        [ruleName add:[TDSymbol symbolWithString:@"$"]];
        [ruleName add:[TDWord word]]; // TODO: ConstrainedName
    }
    return ruleName;
}

//TagFormat ::= ABNF_URI
- (TDCollectionParser *)tagFormat {
    if (!tagFormat) {
        self.tagFormat = self.ABNF_URI;
    }
    return tagFormat;
}


//LexiconURI ::= ABNF_URI | ABNF_URI_with_Media_Type
- (TDCollectionParser *)lexiconURI {
    if (!lexiconURI) {
        self.lexiconURI = [TDAlternation alternation];
        [lexiconURI add:self.ABNF_URI];
        [lexiconURI add:self.ABNF_URI_with_Media_Type];
    }
    return lexiconURI;
}


//Weight ::= '/' Number '/'
- (TDCollectionParser *)weight {
    if (!weight) {
        self.weight = [TDSequence sequence];
        [weight add:[TDSymbol symbolWithString:@"/"]];
        [weight add:[TDNum num]];
        [weight add:[TDSymbol symbolWithString:@"/"]];
    }
    return weight;
}


//Repeat ::= [0-9]+ ('-' [0-9]*)?
- (TDCollectionParser *)repeat {
    if (!repeat) {
        self.repeat = [TDSequence sequence];
        [repeat add:[TDNum num]];
        
        TDSequence *s = [TDSequence sequence];
        [s add:[TDSymbol symbolWithString:@"-"]];
        [s add:[TDNum num]];
        
        TDAlternation *a = [TDAlternation alternation];
        [a add:[TDEmpty empty]];
        [a add:s];
        
        [repeat add:a];
    }
    return repeat;
}


//Probability      ::= '/' Number '/'
- (TDCollectionParser *)probability {
    if (!probability) {
        self.probability = [TDSequence sequence];
        [probability add:[TDSymbol symbolWithString:@"/"]];
        [probability add:[TDNum num]];
        [probability add:[TDSymbol symbolWithString:@"/"]];
    }
    return probability;
}



//ExternalRuleRef  ::= '$' ABNF_URI | '$' ABNF_URI_with_Media_Type
- (TDCollectionParser *)externalRuleRef {
    if (!externalRuleRef) {
        self.externalRuleRef = [TDAlternation alternation];
        
        TDSequence *s = [TDSequence sequence];
        [s add:[TDSymbol symbolWithString:@"$"]];
        [s add:self.ABNF_URI];
        [externalRuleRef add:s];

        s = [TDSequence sequence];
        [s add:[TDSymbol symbolWithString:@"$"]];
        [s add:self.ABNF_URI_with_Media_Type];
        [externalRuleRef add:s];
    }
    return externalRuleRef;
}


//Token  ::= Nmtoken | DoubleQuotedCharacters
- (TDCollectionParser *)token {
    if (!token) {
        self.token = [TDAlternation alternation];
        [token add:[TDWord word]];
        [token add:[TDQuotedString quotedString]];
    }
    return token;
}


//LanguageAttachment ::= '!' LanguageCode
- (TDCollectionParser *)languageAttachment {
    if (!languageAttachment) {
        self.languageAttachment = [TDSequence sequence];
        [languageAttachment add:[TDSymbol symbolWithString:@"!"]];
        [languageAttachment add:self.languageCode];
    }
    return languageAttachment;
}


//Tag ::= '{' [^}]* '}' | '{!{' (Char* - (Char* '}!}' Char*)) '}!}'
- (TDCollectionParser *)tag {
    if (!tag) {
        self.tag = [TDAlternation alternation];

        
        TDSequence *s = [TDSequence sequence];
        [s add:[TDSymbol symbolWithString:@"{"]];
        TDAlternation *a = [TDAlternation alternation];
        [a add:[TDWord word]];
        [a add:[TDNum num]];
        [a add:[TDSymbol symbol]];
        [a add:[TDQuotedString quotedString]];
        [s add:[TDRepetition repetitionWithSubparser:a]];
        [s add:[TDSymbol symbolWithString:@"}"]];
        [tag add:s];
        
        s = [TDSequence sequence];
        [s add:[TDLiteral literalWithString:@"{!{"]];
        a = [TDAlternation alternation];
        [a add:[TDWord word]];
        [a add:[TDNum num]];
        [a add:[TDSymbol symbol]];
        [a add:[TDQuotedString quotedString]];
        [s add:[TDRepetition repetitionWithSubparser:a]];
        [s add:[TDLiteral literalWithString:@"}!}"]];
        [tag add:s];
    }
    return tag;
}


#pragma mark -
#pragma mark Grammar

// grammar ::= selfIdentHeader declaration* ruleDefinition*
- (TDCollectionParser *)grammar {
    if (!grammar) {
        self.grammar = [TDSequence sequence];
        [grammar add:self.selfIdentHeader];
        [grammar add:[TDRepetition repetitionWithSubparser:self.declaration]];
        [grammar add:[TDRepetition repetitionWithSubparser:self.ruleDefinition]];
    }
    return grammar;
}

// declaration ::= baseDecl | languageDecl | modeDecl | rootRuleDecl | tagFormatDecl | lexiconDecl | metaDecl | tagDecl
- (TDCollectionParser *)declaration {
    if (!declaration) {
        self.declaration = [TDAlternation alternation];
        [declaration add:self.baseDecl];
        [declaration add:self.languageDecl];
        [declaration add:self.modeDecl];
        [declaration add:self.rootRuleDecl];
        [declaration add:self.tagFormatDecl];
        [declaration add:self.lexiconDecl];
        [declaration add:self.tagDecl];
    }
    return declaration;
}

// baseDecl ::= 'base' BaseURI ';'
- (TDCollectionParser *)baseDecl {
    if (!baseDecl) {
        self.baseDecl = [TDSequence sequence];
        [baseDecl add:[TDLiteral literalWithString:@"base"]];
        [baseDecl add:self.baseURI];
        [baseDecl add:[TDSymbol symbolWithString:@";"]];
    }
    return baseDecl;
}

// languageDecl    ::= 'language' LanguageCode ';'
- (TDCollectionParser *)languageDecl {
    if (!languageDecl) {
        self.languageDecl = [TDSequence sequence];
        [languageDecl add:[TDLiteral literalWithString:@"language"]];
        [languageDecl add:self.languageCode];
        [languageDecl add:[TDSymbol symbolWithString:@";"]];
    }
    return languageDecl;
}



// modeDecl        ::= 'mode' 'voice' ';' | 'mode' 'dtmf' ';'
- (TDCollectionParser *)modeDecl {
    if (!modeDecl) {
        self.modeDecl = [TDAlternation alternation];
        
        TDSequence *s = [TDSequence sequence];
        [s add:[TDLiteral literalWithString:@"mode"]];
        [s add:[TDLiteral literalWithString:@"voice"]];
        [s add:[TDSymbol symbolWithString:@";"]];
        [modeDecl add:s];
        
        s = [TDSequence sequence];
        [s add:[TDLiteral literalWithString:@"mode"]];
        [s add:[TDLiteral literalWithString:@"dtmf"]];
        [s add:[TDSymbol symbolWithString:@";"]];
        [modeDecl add:s];
    }
    return modeDecl;
}


// rootRuleDecl    ::= 'root' RuleName ';'
- (TDCollectionParser *)rootRuleDecl {
    if (!rootRuleDecl) {
        self.rootRuleDecl = [TDSequence sequence];
        [rootRuleDecl add:[TDLiteral literalWithString:@"root"]];
        [rootRuleDecl add:self.ruleName];
        [rootRuleDecl add:[TDSymbol symbolWithString:@";"]];
    }
    return rootRuleDecl;
}


// tagFormatDecl   ::=     'tag-format' TagFormat ';'
- (TDCollectionParser *)tagFormatDecl {
    if (!tagFormatDecl) {
        self.tagFormatDecl = [TDSequence sequence];
        [tagFormatDecl add:[TDLiteral literalWithString:@"tag-format"]];
        [tagFormatDecl add:self.tagFormat];
        [tagFormatDecl add:[TDSymbol symbolWithString:@";"]];
    }
    return tagFormatDecl;
}



// lexiconDecl     ::= 'lexicon' LexiconURI ';'
- (TDCollectionParser *)lexiconDecl {
    if (!lexiconDecl) {
        self.lexiconDecl = [TDSequence sequence];
        [lexiconDecl add:[TDLiteral literalWithString:@"lexicon"]];
        [lexiconDecl add:self.lexiconURI];
        [lexiconDecl add:[TDSymbol symbolWithString:@";"]];
    }
    return lexiconDecl;
}


// metaDecl        ::=
//    'http-equiv' QuotedCharacters 'is' QuotedCharacters ';'
//    | 'meta' QuotedCharacters 'is' QuotedCharacters ';'
- (TDCollectionParser *)metaDecl {
    if (!metaDecl) {
        self.metaDecl = [TDAlternation alternation];
        
        TDSequence *s = [TDSequence sequence];
        [s add:[TDLiteral literalWithString:@"http-equiv"]];
        [s add:[TDQuotedString quotedString]];
        [s add:[TDLiteral literalWithString:@"is"]];
        [s add:[TDQuotedString quotedString]];
        [s add:[TDSymbol symbolWithString:@";"]];
        [metaDecl add:s];
        
        s = [TDSequence sequence];
        [s add:[TDLiteral literalWithString:@"meta"]];
        [s add:[TDQuotedString quotedString]];
        [s add:[TDLiteral literalWithString:@"is"]];
        [s add:[TDQuotedString quotedString]];
        [s add:[TDSymbol symbolWithString:@";"]];
        [metaDecl add:s];
    }
    return metaDecl;
}



// tagDecl  ::=  Tag ';'
- (TDCollectionParser *)tagDecl {
    if (!tagDecl) {
        self.tagDecl = [TDSequence sequence];
        [tagDecl add:self.tag];
        [tagDecl add:[TDSymbol symbolWithString:@";"]];
    }
    return tagDecl;
}


// ruleDefinition  ::= scope? RuleName '=' ruleExpansion ';'
- (TDCollectionParser *)ruleDefinition {
    if (!ruleDefinition) {
        self.ruleDefinition = [TDSequence sequence];
        
        TDAlternation *a = [TDAlternation alternation];
        [a add:[TDEmpty empty]];
        [a add:self.scope];
        
        [ruleDefinition add:a];
        [ruleDefinition add:self.ruleName];
        [ruleDefinition add:[TDSymbol symbolWithString:@"="]];
        [ruleDefinition add:self.ruleExpansion];
        [ruleDefinition add:[TDSymbol symbolWithString:@";"]];
    }
    return ruleDefinition;
}

// scope ::=  'private' | 'public'
- (TDCollectionParser *)scope {
    if (!scope) {
        self.scope = [TDAlternation alternation];
        [scope add:[TDLiteral literalWithString:@"private"]];
        [scope add:[TDLiteral literalWithString:@"public"]];
    }
    return scope;
}


// ruleExpansion   ::= ruleAlternative ( '|' ruleAlternative )*
- (TDCollectionParser *)ruleExpansion {
    if (!ruleExpansion) {
        self.ruleExpansion = [TDSequence sequence];
        [ruleExpansion add:self.ruleAlternative];
        
        TDSequence *pipeRuleAlternative = [TDSequence sequence];
        [pipeRuleAlternative add:[TDSymbol symbolWithString:@"|"]];
        [pipeRuleAlternative add:self.ruleAlternative];
        [ruleExpansion add:[TDRepetition repetitionWithSubparser:pipeRuleAlternative]];
    }
    return ruleExpansion;
}


// ruleAlternative ::= Weight? sequenceElement+
- (TDCollectionParser *)ruleAlternative {
    if (!ruleAlternative) {
        self.ruleAlternative = [TDSequence sequence];
        
        TDAlternation *a = [TDAlternation alternation];
        [a add:[TDEmpty empty]];
        [a add:self.weight];
        
        [ruleAlternative add:a];
        [ruleAlternative add:self.sequenceElement];
        [ruleAlternative add:[TDRepetition repetitionWithSubparser:self.sequenceElement]];
    }
    return ruleAlternative;
}

// sequenceElement ::= subexpansion | subexpansion repeatOperator

// me: changing to: 
// sequenceElement ::= subexpansion repeatOperator?
- (TDCollectionParser *)sequenceElement {
    if (!sequenceElement) {
//        self.sequenceElement = [TDAlternation alternation];
//        [sequenceElement add:self.subexpansion];
//        
//        TDSequence *s = [TDSequence sequence];
//        [s add:self.subexpansion];
//        [s add:self.repeatOperator];
//        
//        [sequenceElement add:s];

        self.sequenceElement = [TDSequence sequence];
        [sequenceElement add:self.subexpansion];
        
        TDAlternation *a = [TDAlternation alternation];
        [a add:[TDEmpty empty]];
        [a add:self.repeatOperator];
        
        [sequenceElement add:a];
    }
    return sequenceElement;
}

// subexpansion    ::=
//     Token LanguageAttachment?
//     | ruleRef 
//     | Tag
//     | '(' ')'
//     | '(' ruleExpansion ')' LanguageAttachment?
//     | '[' ruleExpansion ']' LanguageAttachment?
- (TDCollectionParser *)subexpansion {
    if (!subexpansion) {
        self.subexpansion = [TDAlternation alternation];
        
        TDSequence *s = [TDSequence sequence];
        [s add:self.token];
        TDAlternation *a = [TDAlternation alternation];
        [a add:[TDEmpty empty]];
        [a add:self.languageAttachment];
        [s add:a];
        [subexpansion add:s];
        
        [subexpansion add:self.ruleRef];
        [subexpansion add:self.tag];
        
        s = [TDSequence sequence];
        [s add:[TDSymbol symbolWithString:@"("]];
        [s add:[TDSymbol symbolWithString:@")"]];
        [subexpansion add:s];
        
        s = [TDSequence sequence];
        [s add:[TDSymbol symbolWithString:@"("]];
        [s add:self.ruleExpansion];    
        [s add:[TDSymbol symbolWithString:@")"]];
        a = [TDAlternation alternation];
        [a add:[TDEmpty empty]];
        [a add:self.languageAttachment];
        [s add:a];
        [subexpansion add:s];
        
        s = [TDSequence sequence];
        [s add:[TDSymbol symbolWithString:@"["]];
        [s add:self.ruleExpansion];    
        [s add:[TDSymbol symbolWithString:@"]"]];
        a = [TDAlternation alternation];
        [a add:[TDEmpty empty]];
        [a add:self.languageAttachment];
        [s add:a];
        [subexpansion add:s];
    }
    return subexpansion;
}


// ruleRef  ::= localRuleRef | ExternalRuleRef | specialRuleRef
- (TDCollectionParser *)ruleRef {
    if (!ruleRef) {
        self.ruleRef = [TDAlternation alternation];
        [ruleRef add:self.localRuleRef];
        [ruleRef add:self.externalRuleRef];
        [ruleRef add:self.specialRuleRef];
    }
    return ruleRef;
}

// localRuleRef    ::= RuleName
- (TDCollectionParser *)localRuleRef {
    if (!localRuleRef) {
        self.localRuleRef = self.ruleName;
    }
    return localRuleRef;
}


// specialRuleRef  ::= '$NULL' | '$VOID' | '$GARBAGE'
- (TDCollectionParser *)specialRuleRef {
    if (!specialRuleRef) {
        self.specialRuleRef = [TDAlternation alternation];
        [specialRuleRef add:[TDLiteral literalWithString:@"$NULL"]];
        [specialRuleRef add:[TDLiteral literalWithString:@"$VOID"]];
        [specialRuleRef add:[TDLiteral literalWithString:@"$GARBAGE"]];
    }
    return specialRuleRef;
}


// repeatOperator  ::='<' Repeat Probability? '>'
- (TDCollectionParser *)repeatOperator {
    if (!repeatOperator) {
        self.repeatOperator = [TDSequence sequence];
        [repeatOperator add:[TDSymbol symbolWithString:@"<"]];
        [repeatOperator add:self.repeat];
        
        TDAlternation *a = [TDAlternation alternation];
        [a add:[TDEmpty empty]];
        [a add:self.probability];
        [repeatOperator add:a];
        
        [repeatOperator add:[TDSymbol symbolWithString:@">"]];
    }
    return repeatOperator;
}


//BaseURI ::= ABNF_URI
- (TDCollectionParser *)baseURI {
    if (!baseURI) {
        self.baseURI = [TDWord word];
    }
    return baseURI;
}


//LanguageCode ::= Nmtoken
- (TDCollectionParser *)languageCode {
    if (!languageCode) {
        self.languageCode = [TDSequence sequence];
        [languageCode add:[TDWord word]];
//        [languageCode add:[TDSymbol symbolWithString:@"-"]];
//        [languageCode add:[TDWord word]];
    }
    return languageCode;
}


- (TDCollectionParser *)ABNF_URI {
    if (!ABNF_URI) {
        self.ABNF_URI = [TDWord word];
    }
    return ABNF_URI;
}


- (TDCollectionParser *)ABNF_URI_with_Media_Type {
    if (!ABNF_URI_with_Media_Type) {
        self.ABNF_URI_with_Media_Type = [TDWord word];
    }
    return ABNF_URI_with_Media_Type;
}



#pragma mark -
#pragma mark Assembler Methods

- (void)workOnWord:(TDAssembly *)a {
//    NSLog(@"%s", _cmd);
//    NSLog(@"a: %@", a);
    TDToken *tok = [a pop];
    [a push:[TDLiteral literalWithString:tok.stringValue]];
}


- (void)workOnNum:(TDAssembly *)a {
//    NSLog(@"%s", _cmd);
//    NSLog(@"a: %@", a);
    TDToken *tok = [a pop];
    [a push:[TDLiteral literalWithString:tok.stringValue]];
}


- (void)workOnQuotedString:(TDAssembly *)a {
//    NSLog(@"%s", _cmd);
//    NSLog(@"a: %@", a);
    TDToken *tok = [a pop];
    NSString *s = [tok.stringValue stringByTrimmingQuotes];
    
    TDSequence *p = [TDSequence sequence];
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    TDToken *eof = [TDToken EOFToken];
    while (eof != (tok = [t nextToken])) {
        [p add:[TDLiteral literalWithString:tok.stringValue]];
    }
    
    [a push:p];
}


- (void)workOnStar:(TDAssembly *)a {
//    NSLog(@"%s", _cmd);
//    NSLog(@"a: %@", a);
    TDRepetition *p = [TDRepetition repetitionWithSubparser:[a pop]];
    [a push:p];
}


- (void)workOnQuestion:(TDAssembly *)a {
//    NSLog(@"%s", _cmd);
//    NSLog(@"a: %@", a);
    TDAlternation *p = [TDAlternation alternation];
    [p add:[a pop]];
    [p add:[TDEmpty empty]];
    [a push:p];
}


- (void)workOnAnd:(TDAssembly *)a {
//    NSLog(@"%s", _cmd);
//    NSLog(@"a: %@", a);
    id top = [a pop];
    TDSequence *p = [TDSequence sequence];
    [p add:[a pop]];
    [p add:top];
    [a push:p];
}


- (void)workOnOr:(TDAssembly *)a {
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


- (void)workOnAssignment:(TDAssembly *)a {
//    NSLog(@"%s", _cmd);
//    NSLog(@"a: %@", a);
    id val = [a pop];
    TDToken *keyTok = [a pop];
    
    NSMutableDictionary *table = [NSMutableDictionary dictionaryWithDictionary:a.target];
    [table setObject:val forKey:keyTok.stringValue];
    a.target = table;
}


- (void)workOnVariable:(TDAssembly *)a {
//    NSLog(@"%s", _cmd);
//    NSLog(@"a: %@", a);
    TDToken *keyTok = [a pop];
    id val = [a.target objectForKey:keyTok.stringValue];
    
//    TDParser *p = nil;
//    if (valTok.isWord) {
//        p = [TDWord wordWithString:valTok.value];
//    } else if (valTok.isQuotedString) {
//        p = [TDQuotedString quotedStringWithString:valTok.value];
//    } else if (valTok.isNumber) {
//        p = [TDNum numWithString:valTok.stringValue];
//    }
    
    [a push:val];
}

@synthesize selfIdentHeader;
@synthesize ruleName;
@synthesize tagFormat;
@synthesize lexiconURI;
@synthesize weight;
@synthesize repeat;
@synthesize probability;
@synthesize externalRuleRef;
@synthesize token;
@synthesize languageAttachment;
@synthesize tag;
@synthesize grammar;
@synthesize declaration;
@synthesize baseDecl;
@synthesize languageDecl;
@synthesize modeDecl;
@synthesize rootRuleDecl;
@synthesize tagFormatDecl;
@synthesize lexiconDecl;
@synthesize metaDecl;
@synthesize tagDecl;
@synthesize ruleDefinition;
@synthesize scope;
@synthesize ruleExpansion;
@synthesize ruleAlternative;
@synthesize sequenceElement;
@synthesize subexpansion;
@synthesize ruleRef;
@synthesize localRuleRef;
@synthesize specialRuleRef;
@synthesize repeatOperator;

@synthesize baseURI;
@synthesize languageCode;
@synthesize ABNF_URI;
@synthesize ABNF_URI_with_Media_Type;
@end