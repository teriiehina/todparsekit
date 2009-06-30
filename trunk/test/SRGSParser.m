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
- (void)workOnWord:(PKAssembly *)a;
- (void)workOnNum:(PKAssembly *)a;
- (void)workOnQuotedString:(PKAssembly *)a;
- (void)workOnStar:(PKAssembly *)a;
- (void)workOnQuestion:(PKAssembly *)a;
- (void)workOnAnd:(PKAssembly *)a;
- (void)workOnOr:(PKAssembly *)a;
- (void)workOnAssignment:(PKAssembly *)a;
- (void)workOnVariable:(PKAssembly *)a;
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
    PKAssembly *a = [self assemblyWithString:s];
    a = [self completeMatchFor:a];
    return [a pop];
}


- (PKAssembly *)assemblyWithString:(NSString *)s {
    PKTokenizer *t = [[[PKTokenizer alloc] initWithString:s] autorelease];
    [t setTokenizerState:t.symbolState from: '-' to: '-'];
    [t setTokenizerState:t.symbolState from: '.' to: '.'];
    //[t.wordState setWordChars:YES from:'-' to:'-'];

    PKTokenAssembly *a = [PKTokenAssembly assemblyWithTokenizer:t];
    //    TDNCNameState *NCNameState = [[[TDNCNameState alloc] init] autorelease];
    return a;
}


//selfIdentHeader ::= '#ABNF' #x20 VersionNumber (#x20 CharEncoding)? ';'
//VersionNumber    ::= '1.0'
//CharEncoding     ::= Nmtoken
- (PKCollectionParser *)selfIdentHeader {
    if (!selfIdentHeader) {
        self.selfIdentHeader = [PKSequence sequence];
        selfIdentHeader.name = @"selfIdentHeader";
        
        [selfIdentHeader add:[TDSymbol symbolWithString:@"#"]];
        [selfIdentHeader add:[TDLiteral literalWithString:@"ABNF"]];
        [selfIdentHeader add:[TDNum num]];  // VersionNumber
        
        PKAlternation *a = [PKAlternation alternation];
        [a add:[PKEmpty empty]];
        [a add:[TDWord word]]; // CharEncoding
        
        [selfIdentHeader add:a];
        [selfIdentHeader add:[TDSymbol symbolWithString:@";"]];
    }
    return selfIdentHeader;
}


//RuleName         ::= '$' ConstrainedName 
//ConstrainedName  ::= Name - (Char* ('.' | ':' | '-') Char*)
- (PKCollectionParser *)ruleName {
    if (!ruleName) {
        self.ruleName = [PKSequence sequence];
        [ruleName add:[TDSymbol symbolWithString:@"$"]];
        [ruleName add:[TDWord word]]; // TODO: ConstrainedName
    }
    return ruleName;
}

//TagFormat ::= ABNF_URI
- (PKCollectionParser *)tagFormat {
    if (!tagFormat) {
        self.tagFormat = self.ABNF_URI;
    }
    return tagFormat;
}


//LexiconURI ::= ABNF_URI | ABNF_URI_with_Media_Type
- (PKCollectionParser *)lexiconURI {
    if (!lexiconURI) {
        self.lexiconURI = [PKAlternation alternation];
        [lexiconURI add:self.ABNF_URI];
        [lexiconURI add:self.ABNF_URI_with_Media_Type];
    }
    return lexiconURI;
}


//Weight ::= '/' Number '/'
- (PKCollectionParser *)weight {
    if (!weight) {
        self.weight = [PKSequence sequence];
        [weight add:[TDSymbol symbolWithString:@"/"]];
        [weight add:[TDNum num]];
        [weight add:[TDSymbol symbolWithString:@"/"]];
    }
    return weight;
}


//Repeat ::= [0-9]+ ('-' [0-9]*)?
- (PKCollectionParser *)repeat {
    if (!repeat) {
        self.repeat = [PKSequence sequence];
        [repeat add:[TDNum num]];
        
        PKSequence *s = [PKSequence sequence];
        [s add:[TDSymbol symbolWithString:@"-"]];
        [s add:[TDNum num]];
        
        PKAlternation *a = [PKAlternation alternation];
        [a add:[PKEmpty empty]];
        [a add:s];
        
        [repeat add:a];
    }
    return repeat;
}


//Probability      ::= '/' Number '/'
- (PKCollectionParser *)probability {
    if (!probability) {
        self.probability = [PKSequence sequence];
        [probability add:[TDSymbol symbolWithString:@"/"]];
        [probability add:[TDNum num]];
        [probability add:[TDSymbol symbolWithString:@"/"]];
    }
    return probability;
}



//ExternalRuleRef  ::= '$' ABNF_URI | '$' ABNF_URI_with_Media_Type
- (PKCollectionParser *)externalRuleRef {
    if (!externalRuleRef) {
        self.externalRuleRef = [PKAlternation alternation];
        
        PKSequence *s = [PKSequence sequence];
        [s add:[TDSymbol symbolWithString:@"$"]];
        [s add:self.ABNF_URI];
        [externalRuleRef add:s];

        s = [PKSequence sequence];
        [s add:[TDSymbol symbolWithString:@"$"]];
        [s add:self.ABNF_URI_with_Media_Type];
        [externalRuleRef add:s];
    }
    return externalRuleRef;
}


//Token  ::= Nmtoken | DoubleQuotedCharacters
- (PKCollectionParser *)token {
    if (!token) {
        self.token = [PKAlternation alternation];
        [token add:[TDWord word]];
        [token add:[TDQuotedString quotedString]];
    }
    return token;
}


//LanguageAttachment ::= '!' LanguageCode
- (PKCollectionParser *)languageAttachment {
    if (!languageAttachment) {
        self.languageAttachment = [PKSequence sequence];
        [languageAttachment add:[TDSymbol symbolWithString:@"!"]];
        [languageAttachment add:self.languageCode];
    }
    return languageAttachment;
}


//Tag ::= '{' [^}]* '}' | '{!{' (Char* - (Char* '}!}' Char*)) '}!}'
- (PKCollectionParser *)tag {
    if (!tag) {
        self.tag = [PKAlternation alternation];

        
        PKSequence *s = [PKSequence sequence];
        [s add:[TDSymbol symbolWithString:@"{"]];
        PKAlternation *a = [PKAlternation alternation];
        [a add:[TDWord word]];
        [a add:[TDNum num]];
        [a add:[TDSymbol symbol]];
        [a add:[TDQuotedString quotedString]];
        [s add:[PKRepetition repetitionWithSubparser:a]];
        [s add:[TDSymbol symbolWithString:@"}"]];
        [tag add:s];
        
        s = [PKSequence sequence];
        [s add:[TDLiteral literalWithString:@"{!{"]];
        a = [PKAlternation alternation];
        [a add:[TDWord word]];
        [a add:[TDNum num]];
        [a add:[TDSymbol symbol]];
        [a add:[TDQuotedString quotedString]];
        [s add:[PKRepetition repetitionWithSubparser:a]];
        [s add:[TDLiteral literalWithString:@"}!}"]];
        [tag add:s];
    }
    return tag;
}


#pragma mark -
#pragma mark Grammar

// grammar ::= selfIdentHeader declaration* ruleDefinition*
- (PKCollectionParser *)grammar {
    if (!grammar) {
        self.grammar = [PKSequence sequence];
        [grammar add:self.selfIdentHeader];
        [grammar add:[PKRepetition repetitionWithSubparser:self.declaration]];
        [grammar add:[PKRepetition repetitionWithSubparser:self.ruleDefinition]];
    }
    return grammar;
}

// declaration ::= baseDecl | languageDecl | modeDecl | rootRuleDecl | tagFormatDecl | lexiconDecl | metaDecl | tagDecl
- (PKCollectionParser *)declaration {
    if (!declaration) {
        self.declaration = [PKAlternation alternation];
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
- (PKCollectionParser *)baseDecl {
    if (!baseDecl) {
        self.baseDecl = [PKSequence sequence];
        [baseDecl add:[TDLiteral literalWithString:@"base"]];
        [baseDecl add:self.baseURI];
        [baseDecl add:[TDSymbol symbolWithString:@";"]];
    }
    return baseDecl;
}

// languageDecl    ::= 'language' LanguageCode ';'
- (PKCollectionParser *)languageDecl {
    if (!languageDecl) {
        self.languageDecl = [PKSequence sequence];
        [languageDecl add:[TDLiteral literalWithString:@"language"]];
        [languageDecl add:self.languageCode];
        [languageDecl add:[TDSymbol symbolWithString:@";"]];
    }
    return languageDecl;
}



// modeDecl        ::= 'mode' 'voice' ';' | 'mode' 'dtmf' ';'
- (PKCollectionParser *)modeDecl {
    if (!modeDecl) {
        self.modeDecl = [PKAlternation alternation];
        
        PKSequence *s = [PKSequence sequence];
        [s add:[TDLiteral literalWithString:@"mode"]];
        [s add:[TDLiteral literalWithString:@"voice"]];
        [s add:[TDSymbol symbolWithString:@";"]];
        [modeDecl add:s];
        
        s = [PKSequence sequence];
        [s add:[TDLiteral literalWithString:@"mode"]];
        [s add:[TDLiteral literalWithString:@"dtmf"]];
        [s add:[TDSymbol symbolWithString:@";"]];
        [modeDecl add:s];
    }
    return modeDecl;
}


// rootRuleDecl    ::= 'root' RuleName ';'
- (PKCollectionParser *)rootRuleDecl {
    if (!rootRuleDecl) {
        self.rootRuleDecl = [PKSequence sequence];
        [rootRuleDecl add:[TDLiteral literalWithString:@"root"]];
        [rootRuleDecl add:self.ruleName];
        [rootRuleDecl add:[TDSymbol symbolWithString:@";"]];
    }
    return rootRuleDecl;
}


// tagFormatDecl   ::=     'tag-format' TagFormat ';'
- (PKCollectionParser *)tagFormatDecl {
    if (!tagFormatDecl) {
        self.tagFormatDecl = [PKSequence sequence];
        [tagFormatDecl add:[TDLiteral literalWithString:@"tag-format"]];
        [tagFormatDecl add:self.tagFormat];
        [tagFormatDecl add:[TDSymbol symbolWithString:@";"]];
    }
    return tagFormatDecl;
}



// lexiconDecl     ::= 'lexicon' LexiconURI ';'
- (PKCollectionParser *)lexiconDecl {
    if (!lexiconDecl) {
        self.lexiconDecl = [PKSequence sequence];
        [lexiconDecl add:[TDLiteral literalWithString:@"lexicon"]];
        [lexiconDecl add:self.lexiconURI];
        [lexiconDecl add:[TDSymbol symbolWithString:@";"]];
    }
    return lexiconDecl;
}


// metaDecl        ::=
//    'http-equiv' QuotedCharacters 'is' QuotedCharacters ';'
//    | 'meta' QuotedCharacters 'is' QuotedCharacters ';'
- (PKCollectionParser *)metaDecl {
    if (!metaDecl) {
        self.metaDecl = [PKAlternation alternation];
        
        PKSequence *s = [PKSequence sequence];
        [s add:[TDLiteral literalWithString:@"http-equiv"]];
        [s add:[TDQuotedString quotedString]];
        [s add:[TDLiteral literalWithString:@"is"]];
        [s add:[TDQuotedString quotedString]];
        [s add:[TDSymbol symbolWithString:@";"]];
        [metaDecl add:s];
        
        s = [PKSequence sequence];
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
- (PKCollectionParser *)tagDecl {
    if (!tagDecl) {
        self.tagDecl = [PKSequence sequence];
        [tagDecl add:self.tag];
        [tagDecl add:[TDSymbol symbolWithString:@";"]];
    }
    return tagDecl;
}


// ruleDefinition  ::= scope? RuleName '=' ruleExpansion ';'
- (PKCollectionParser *)ruleDefinition {
    if (!ruleDefinition) {
        self.ruleDefinition = [PKSequence sequence];
        
        PKAlternation *a = [PKAlternation alternation];
        [a add:[PKEmpty empty]];
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
- (PKCollectionParser *)scope {
    if (!scope) {
        self.scope = [PKAlternation alternation];
        [scope add:[TDLiteral literalWithString:@"private"]];
        [scope add:[TDLiteral literalWithString:@"public"]];
    }
    return scope;
}


// ruleExpansion   ::= ruleAlternative ( '|' ruleAlternative )*
- (PKCollectionParser *)ruleExpansion {
    if (!ruleExpansion) {
        self.ruleExpansion = [PKSequence sequence];
        [ruleExpansion add:self.ruleAlternative];
        
        PKSequence *pipeRuleAlternative = [PKSequence sequence];
        [pipeRuleAlternative add:[TDSymbol symbolWithString:@"|"]];
        [pipeRuleAlternative add:self.ruleAlternative];
        [ruleExpansion add:[PKRepetition repetitionWithSubparser:pipeRuleAlternative]];
    }
    return ruleExpansion;
}


// ruleAlternative ::= Weight? sequenceElement+
- (PKCollectionParser *)ruleAlternative {
    if (!ruleAlternative) {
        self.ruleAlternative = [PKSequence sequence];
        
        PKAlternation *a = [PKAlternation alternation];
        [a add:[PKEmpty empty]];
        [a add:self.weight];
        
        [ruleAlternative add:a];
        [ruleAlternative add:self.sequenceElement];
        [ruleAlternative add:[PKRepetition repetitionWithSubparser:self.sequenceElement]];
    }
    return ruleAlternative;
}

// sequenceElement ::= subexpansion | subexpansion repeatOperator

// me: changing to: 
// sequenceElement ::= subexpansion repeatOperator?
- (PKCollectionParser *)sequenceElement {
    if (!sequenceElement) {
//        self.sequenceElement = [PKAlternation alternation];
//        [sequenceElement add:self.subexpansion];
//        
//        PKSequence *s = [PKSequence sequence];
//        [s add:self.subexpansion];
//        [s add:self.repeatOperator];
//        
//        [sequenceElement add:s];

        self.sequenceElement = [PKSequence sequence];
        [sequenceElement add:self.subexpansion];
        
        PKAlternation *a = [PKAlternation alternation];
        [a add:[PKEmpty empty]];
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
- (PKCollectionParser *)subexpansion {
    if (!subexpansion) {
        self.subexpansion = [PKAlternation alternation];
        
        PKSequence *s = [PKSequence sequence];
        [s add:self.token];
        PKAlternation *a = [PKAlternation alternation];
        [a add:[PKEmpty empty]];
        [a add:self.languageAttachment];
        [s add:a];
        [subexpansion add:s];
        
        [subexpansion add:self.ruleRef];
        [subexpansion add:self.tag];
        
        s = [PKSequence sequence];
        [s add:[TDSymbol symbolWithString:@"("]];
        [s add:[TDSymbol symbolWithString:@")"]];
        [subexpansion add:s];
        
        s = [PKSequence sequence];
        [s add:[TDSymbol symbolWithString:@"("]];
        [s add:self.ruleExpansion];    
        [s add:[TDSymbol symbolWithString:@")"]];
        a = [PKAlternation alternation];
        [a add:[PKEmpty empty]];
        [a add:self.languageAttachment];
        [s add:a];
        [subexpansion add:s];
        
        s = [PKSequence sequence];
        [s add:[TDSymbol symbolWithString:@"["]];
        [s add:self.ruleExpansion];    
        [s add:[TDSymbol symbolWithString:@"]"]];
        a = [PKAlternation alternation];
        [a add:[PKEmpty empty]];
        [a add:self.languageAttachment];
        [s add:a];
        [subexpansion add:s];
    }
    return subexpansion;
}


// ruleRef  ::= localRuleRef | ExternalRuleRef | specialRuleRef
- (PKCollectionParser *)ruleRef {
    if (!ruleRef) {
        self.ruleRef = [PKAlternation alternation];
        [ruleRef add:self.localRuleRef];
        [ruleRef add:self.externalRuleRef];
        [ruleRef add:self.specialRuleRef];
    }
    return ruleRef;
}

// localRuleRef    ::= RuleName
- (PKCollectionParser *)localRuleRef {
    if (!localRuleRef) {
        self.localRuleRef = self.ruleName;
    }
    return localRuleRef;
}


// specialRuleRef  ::= '$NULL' | '$VOID' | '$GARBAGE'
- (PKCollectionParser *)specialRuleRef {
    if (!specialRuleRef) {
        self.specialRuleRef = [PKAlternation alternation];
        [specialRuleRef add:[TDLiteral literalWithString:@"$NULL"]];
        [specialRuleRef add:[TDLiteral literalWithString:@"$VOID"]];
        [specialRuleRef add:[TDLiteral literalWithString:@"$GARBAGE"]];
    }
    return specialRuleRef;
}


// repeatOperator  ::='<' Repeat Probability? '>'
- (PKCollectionParser *)repeatOperator {
    if (!repeatOperator) {
        self.repeatOperator = [PKSequence sequence];
        [repeatOperator add:[TDSymbol symbolWithString:@"<"]];
        [repeatOperator add:self.repeat];
        
        PKAlternation *a = [PKAlternation alternation];
        [a add:[PKEmpty empty]];
        [a add:self.probability];
        [repeatOperator add:a];
        
        [repeatOperator add:[TDSymbol symbolWithString:@">"]];
    }
    return repeatOperator;
}


//BaseURI ::= ABNF_URI
- (PKCollectionParser *)baseURI {
    if (!baseURI) {
        self.baseURI = [TDWord word];
    }
    return baseURI;
}


//LanguageCode ::= Nmtoken
- (PKCollectionParser *)languageCode {
    if (!languageCode) {
        self.languageCode = [PKSequence sequence];
        [languageCode add:[TDWord word]];
//        [languageCode add:[TDSymbol symbolWithString:@"-"]];
//        [languageCode add:[TDWord word]];
    }
    return languageCode;
}


- (PKCollectionParser *)ABNF_URI {
    if (!ABNF_URI) {
        self.ABNF_URI = [TDWord word];
    }
    return ABNF_URI;
}


- (PKCollectionParser *)ABNF_URI_with_Media_Type {
    if (!ABNF_URI_with_Media_Type) {
        self.ABNF_URI_with_Media_Type = [TDWord word];
    }
    return ABNF_URI_with_Media_Type;
}



#pragma mark -
#pragma mark Assembler Methods

- (void)workOnWord:(PKAssembly *)a {
//    NSLog(@"%s", _cmd);
//    NSLog(@"a: %@", a);
    PKToken *tok = [a pop];
    [a push:[TDLiteral literalWithString:tok.stringValue]];
}


- (void)workOnNum:(PKAssembly *)a {
//    NSLog(@"%s", _cmd);
//    NSLog(@"a: %@", a);
    PKToken *tok = [a pop];
    [a push:[TDLiteral literalWithString:tok.stringValue]];
}


- (void)workOnQuotedString:(PKAssembly *)a {
//    NSLog(@"%s", _cmd);
//    NSLog(@"a: %@", a);
    PKToken *tok = [a pop];
    NSString *s = [tok.stringValue stringByTrimmingQuotes];
    
    PKSequence *p = [PKSequence sequence];
    PKTokenizer *t = [PKTokenizer tokenizerWithString:s];
    PKToken *eof = [PKToken EOFToken];
    while (eof != (tok = [t nextToken])) {
        [p add:[TDLiteral literalWithString:tok.stringValue]];
    }
    
    [a push:p];
}


- (void)workOnStar:(PKAssembly *)a {
//    NSLog(@"%s", _cmd);
//    NSLog(@"a: %@", a);
    PKRepetition *p = [PKRepetition repetitionWithSubparser:[a pop]];
    [a push:p];
}


- (void)workOnQuestion:(PKAssembly *)a {
//    NSLog(@"%s", _cmd);
//    NSLog(@"a: %@", a);
    PKAlternation *p = [PKAlternation alternation];
    [p add:[a pop]];
    [p add:[PKEmpty empty]];
    [a push:p];
}


- (void)workOnAnd:(PKAssembly *)a {
//    NSLog(@"%s", _cmd);
//    NSLog(@"a: %@", a);
    id top = [a pop];
    PKSequence *p = [PKSequence sequence];
    [p add:[a pop]];
    [p add:top];
    [a push:p];
}


- (void)workOnOr:(PKAssembly *)a {
//    NSLog(@"%s", _cmd);
//    NSLog(@"a: %@", a);
    id top = [a pop];
//    NSLog(@"top: %@", top);
//    NSLog(@"top class: %@", [top class]);
    PKAlternation *p = [PKAlternation alternation];
    [p add:[a pop]];
    [p add:top];
    [a push:p];
}


- (void)workOnAssignment:(PKAssembly *)a {
//    NSLog(@"%s", _cmd);
//    NSLog(@"a: %@", a);
    id val = [a pop];
    PKToken *keyTok = [a pop];
    
    NSMutableDictionary *table = [NSMutableDictionary dictionaryWithDictionary:a.target];
    [table setObject:val forKey:keyTok.stringValue];
    a.target = table;
}


- (void)workOnVariable:(PKAssembly *)a {
//    NSLog(@"%s", _cmd);
//    NSLog(@"a: %@", a);
    PKToken *keyTok = [a pop];
    id val = [a.target objectForKey:keyTok.stringValue];
    
//    PKParser *p = nil;
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