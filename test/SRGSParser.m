//
//  SRGSParser.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/15/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "SRGSParser.h"

@interface SRGSParser ()
- (void)workOnWordAssembly:(TODAssembly *)a;
- (void)workOnNumAssembly:(TODAssembly *)a;
- (void)workOnQuotedStringAssembly:(TODAssembly *)a;
- (void)workOnStarAssembly:(TODAssembly *)a;
- (void)workOnQuestionAssembly:(TODAssembly *)a;
- (void)workOnAndAssembly:(TODAssembly *)a;
- (void)workOnOrAssembly:(TODAssembly *)a;
- (void)workOnAssignmentAssembly:(TODAssembly *)a;
- (void)workOnVariableAssembly:(TODAssembly *)a;
@end

@implementation SRGSParser

- (id)init {
	self = [super init];
	if (self != nil) {
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
	TODAssembly *a = [self assemblyWithString:s];
	a = [self completeMatchFor:a];
	return [a pop];
}


- (TODAssembly *)assemblyWithString:(NSString *)s {
	TODTokenAssembly *a = [TODTokenAssembly assemblyWithString:s];
	TODTokenizer *t = a.tokenizer;
	
	//	TODNCNameState *NCNameState = [[[TODNCNameState alloc] init] autorelease];
	
	[t setCharacterState:t.symbolState from: '-' to: '-'];
	[t setCharacterState:t.symbolState from: '.' to: '.'];
	//[t.wordState setWordChars:YES from:'-' to:'-'];
	return a;	
}




//selfIdentHeader ::= '#ABNF' #x20 VersionNumber (#x20 CharEncoding)? ';'
//VersionNumber    ::= '1.0'
//CharEncoding     ::= Nmtoken
- (TODCollectionParser *)selfIdentHeader {
	if (!selfIdentHeader) {
		self.selfIdentHeader = [TODSequence sequence];
		selfIdentHeader.name = @"selfIdentHeader";
		
		[selfIdentHeader add:[TODSymbol symbolWithString:@"#"]];
		[selfIdentHeader add:[TODLiteral literalWithString:@"ABNF"]];
		[selfIdentHeader add:[TODNum num]];  // VersionNumber
		
		TODAlternation *a = [TODAlternation alternation];
		[a add:[TODEmpty empty]];
		[a add:[TODWord word]]; // CharEncoding
		
		[selfIdentHeader add:a];
		[selfIdentHeader add:[TODSymbol symbolWithString:@";"]];
	}
	return selfIdentHeader;
}


//RuleName         ::= '$' ConstrainedName 
//ConstrainedName  ::= Name - (Char* ('.' | ':' | '-') Char*)
- (TODCollectionParser *)ruleName {
	if (!ruleName) {
		self.ruleName = [TODSequence sequence];
		[ruleName add:[TODSymbol symbolWithString:@"$"]];
		[ruleName add:[TODWord word]]; // TODO: ConstrainedName
	}
	return ruleName;
}

//TagFormat ::= ABNF_URI
- (TODCollectionParser *)tagFormat {
	if (!tagFormat) {
		self.tagFormat = self.ABNF_URI;
	}
	return tagFormat;
}


//LexiconURI ::= ABNF_URI | ABNF_URI_with_Media_Type
- (TODCollectionParser *)lexiconURI {
	if (!lexiconURI) {
		self.lexiconURI = [TODAlternation alternation];
		[lexiconURI add:self.ABNF_URI];
		[lexiconURI add:self.ABNF_URI_with_Media_Type];
	}
	return lexiconURI;
}


//Weight ::= '/' Number '/'
- (TODCollectionParser *)weight {
	if (!weight) {
		self.weight = [TODSequence sequence];
		[weight add:[TODSymbol symbolWithString:@"/"]];
		[weight add:[TODNum num]];
		[weight add:[TODSymbol symbolWithString:@"/"]];
	}
	return weight;
}


//Repeat ::= [0-9]+ ('-' [0-9]*)?
- (TODCollectionParser *)repeat {
	if (!repeat) {
		self.repeat = [TODSequence sequence];
		[repeat add:[TODNum num]];
		
		TODSequence *s = [TODSequence sequence];
		[s add:[TODSymbol symbolWithString:@"-"]];
		[s add:[TODNum num]];
		
		TODAlternation *a = [TODAlternation alternation];
		[a add:[TODEmpty empty]];
		[a add:s];
		
		[repeat add:a];
	}
	return repeat;
}


//Probability      ::= '/' Number '/'
- (TODCollectionParser *)probability {
	if (!probability) {
		self.probability = [TODSequence sequence];
		[probability add:[TODSymbol symbolWithString:@"/"]];
		[probability add:[TODNum num]];
		[probability add:[TODSymbol symbolWithString:@"/"]];
	}
	return probability;
}



//ExternalRuleRef  ::= '$' ABNF_URI | '$' ABNF_URI_with_Media_Type
- (TODCollectionParser *)externalRuleRef {
	if (!externalRuleRef) {
		self.externalRuleRef = [TODAlternation alternation];
		
		TODSequence *s = [TODSequence sequence];
		[s add:[TODSymbol symbolWithString:@"$"]];
		[s add:self.ABNF_URI];
		[externalRuleRef add:s];

		s = [TODSequence sequence];
		[s add:[TODSymbol symbolWithString:@"$"]];
		[s add:self.ABNF_URI_with_Media_Type];
		[externalRuleRef add:s];
	}
	return externalRuleRef;
}


//Token  ::= Nmtoken | DoubleQuotedCharacters
- (TODCollectionParser *)token {
	if (!token) {
		self.token = [TODAlternation alternation];
		[token add:[TODWord word]];
		[token add:[TODQuotedString quotedString]];
	}
	return token;
}


//LanguageAttachment ::= '!' LanguageCode
- (TODCollectionParser *)languageAttachment {
	if (!languageAttachment) {
		self.languageAttachment = [TODSequence sequence];
		[languageAttachment add:[TODSymbol symbolWithString:@"!"]];
		[languageAttachment add:self.languageCode];
	}
	return languageAttachment;
}


//Tag ::= '{' [^}]* '}' | '{!{' (Char* - (Char* '}!}' Char*)) '}!}'
- (TODCollectionParser *)tag {
	if (!tag) {
		self.tag = [TODAlternation alternation];

		
		TODSequence *s = [TODSequence sequence];
		[s add:[TODSymbol symbolWithString:@"{"]];
		TODAlternation *a = [TODAlternation alternation];
		[a add:[TODWord word]];
		[a add:[TODNum num]];
		[a add:[TODSymbol symbol]];
		[a add:[TODQuotedString quotedString]];
		[s add:[TODRepetition repetitionWithSubparser:a]];
		[s add:[TODSymbol symbolWithString:@"}"]];
		[tag add:s];
		
		s = [TODSequence sequence];
		[s add:[TODLiteral literalWithString:@"{!{"]];
		a = [TODAlternation alternation];
		[a add:[TODWord word]];
		[a add:[TODNum num]];
		[a add:[TODSymbol symbol]];
		[a add:[TODQuotedString quotedString]];
		[s add:[TODRepetition repetitionWithSubparser:a]];
		[s add:[TODLiteral literalWithString:@"}!}"]];
		[tag add:s];
	}
	return tag;
}


#pragma mark -
#pragma mark Grammar

// grammar ::= selfIdentHeader declaration* ruleDefinition*
- (TODCollectionParser *)grammar {
	if (!grammar) {
		self.grammar = [TODSequence sequence];
		[grammar add:self.selfIdentHeader];
		[grammar add:[TODRepetition repetitionWithSubparser:self.declaration]];
		[grammar add:[TODRepetition repetitionWithSubparser:self.ruleDefinition]];
	}
	return grammar;
}

// declaration ::= baseDecl | languageDecl | modeDecl | rootRuleDecl | tagFormatDecl | lexiconDecl | metaDecl | tagDecl
- (TODCollectionParser *)declaration {
	if (!declaration) {
		self.declaration = [TODAlternation alternation];
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
- (TODCollectionParser *)baseDecl {
	if (!baseDecl) {
		self.baseDecl = [TODSequence sequence];
		[baseDecl add:[TODLiteral literalWithString:@"base"]];
		[baseDecl add:self.baseURI];
		[baseDecl add:[TODSymbol symbolWithString:@";"]];
	}
	return baseDecl;
}

// languageDecl    ::= 'language' LanguageCode ';'
- (TODCollectionParser *)languageDecl {
	if (!languageDecl) {
		self.languageDecl = [TODSequence sequence];
		[languageDecl add:[TODLiteral literalWithString:@"language"]];
		[languageDecl add:self.languageCode];
		[languageDecl add:[TODSymbol symbolWithString:@";"]];
	}
	return languageDecl;
}



// modeDecl        ::= 'mode' 'voice' ';' | 'mode' 'dtmf' ';'
- (TODCollectionParser *)modeDecl {
	if (!modeDecl) {
		self.modeDecl = [TODAlternation alternation];
		
		TODSequence *s = [TODSequence sequence];
		[s add:[TODLiteral literalWithString:@"mode"]];
		[s add:[TODLiteral literalWithString:@"voice"]];
		[s add:[TODSymbol symbolWithString:@";"]];
		[modeDecl add:s];
		
		s = [TODSequence sequence];
		[s add:[TODLiteral literalWithString:@"mode"]];
		[s add:[TODLiteral literalWithString:@"dtmf"]];
		[s add:[TODSymbol symbolWithString:@";"]];
		[modeDecl add:s];
	}
	return modeDecl;
}


// rootRuleDecl    ::= 'root' RuleName ';'
- (TODCollectionParser *)rootRuleDecl {
	if (!rootRuleDecl) {
		self.rootRuleDecl = [TODSequence sequence];
		[rootRuleDecl add:[TODLiteral literalWithString:@"root"]];
		[rootRuleDecl add:self.ruleName];
		[rootRuleDecl add:[TODSymbol symbolWithString:@";"]];
	}
	return rootRuleDecl;
}


// tagFormatDecl   ::=     'tag-format' TagFormat ';'
- (TODCollectionParser *)tagFormatDecl {
	if (!tagFormatDecl) {
		self.tagFormatDecl = [TODSequence sequence];
		[tagFormatDecl add:[TODLiteral literalWithString:@"tag-format"]];
		[tagFormatDecl add:self.tagFormat];
		[tagFormatDecl add:[TODSymbol symbolWithString:@";"]];
	}
	return tagFormatDecl;
}



// lexiconDecl     ::= 'lexicon' LexiconURI ';'
- (TODCollectionParser *)lexiconDecl {
	if (!lexiconDecl) {
		self.lexiconDecl = [TODSequence sequence];
		[lexiconDecl add:[TODLiteral literalWithString:@"lexicon"]];
		[lexiconDecl add:self.lexiconURI];
		[lexiconDecl add:[TODSymbol symbolWithString:@";"]];
	}
	return lexiconDecl;
}


// metaDecl        ::=
//    'http-equiv' QuotedCharacters 'is' QuotedCharacters ';'
//    | 'meta' QuotedCharacters 'is' QuotedCharacters ';'
- (TODCollectionParser *)metaDecl {
	if (!metaDecl) {
		self.metaDecl = [TODAlternation alternation];
		
		TODSequence *s = [TODSequence sequence];
		[s add:[TODLiteral literalWithString:@"http-equiv"]];
		[s add:[TODQuotedString quotedString]];
		[s add:[TODLiteral literalWithString:@"is"]];
		[s add:[TODQuotedString quotedString]];
		[s add:[TODSymbol symbolWithString:@";"]];
		[metaDecl add:s];
		
		s = [TODSequence sequence];
		[s add:[TODLiteral literalWithString:@"meta"]];
		[s add:[TODQuotedString quotedString]];
		[s add:[TODLiteral literalWithString:@"is"]];
		[s add:[TODQuotedString quotedString]];
		[s add:[TODSymbol symbolWithString:@";"]];
		[metaDecl add:s];
	}
	return metaDecl;
}



// tagDecl  ::=  Tag ';'
- (TODCollectionParser *)tagDecl {
	if (!tagDecl) {
		self.tagDecl = [TODSequence sequence];
		[tagDecl add:self.tag];
		[tagDecl add:[TODSymbol symbolWithString:@";"]];
	}
	return tagDecl;
}


// ruleDefinition  ::= scope? RuleName '=' ruleExpansion ';'
- (TODCollectionParser *)ruleDefinition {
	if (!ruleDefinition) {
		self.ruleDefinition = [TODSequence sequence];
		
		TODAlternation *a = [TODAlternation alternation];
		[a add:[TODEmpty empty]];
		[a add:self.scope];
		
		[ruleDefinition add:a];
		[ruleDefinition add:self.ruleName];
		[ruleDefinition add:[TODSymbol symbolWithString:@"="]];
		[ruleDefinition add:self.ruleExpansion];
		[ruleDefinition add:[TODSymbol symbolWithString:@";"]];
	}
	return ruleDefinition;
}

// scope ::=  'private' | 'public'
- (TODCollectionParser *)scope {
	if (!scope) {
		self.scope = [TODAlternation alternation];
		[scope add:[TODLiteral literalWithString:@"private"]];
		[scope add:[TODLiteral literalWithString:@"public"]];
	}
	return scope;
}


// ruleExpansion   ::= ruleAlternative ( '|' ruleAlternative )*
- (TODCollectionParser *)ruleExpansion {
	if (!ruleExpansion) {
		self.ruleExpansion = [TODSequence sequence];
		[ruleExpansion add:self.ruleAlternative];
		
		TODSequence *pipeRuleAlternative = [TODSequence sequence];
		[pipeRuleAlternative add:[TODSymbol symbolWithString:@"|"]];
		[pipeRuleAlternative add:self.ruleAlternative];
		[ruleExpansion add:[TODRepetition repetitionWithSubparser:pipeRuleAlternative]];
	}
	return ruleExpansion;
}


// ruleAlternative ::= Weight? sequenceElement+
- (TODCollectionParser *)ruleAlternative {
	if (!ruleAlternative) {
		self.ruleAlternative = [TODSequence sequence];
		
		TODAlternation *a = [TODAlternation alternation];
		[a add:[TODEmpty empty]];
		[a add:self.weight];
		
		[ruleAlternative add:a];
		[ruleAlternative add:self.sequenceElement];
		[ruleAlternative add:[TODRepetition repetitionWithSubparser:self.sequenceElement]];
	}
	return ruleAlternative;
}

// sequenceElement ::= subexpansion | subexpansion repeatOperator

// me: changing to: 
// sequenceElement ::= subexpansion repeatOperator?
- (TODCollectionParser *)sequenceElement {
	if (!sequenceElement) {
//		self.sequenceElement = [TODAlternation alternation];
//		[sequenceElement add:self.subexpansion];
//		
//		TODSequence *s = [TODSequence sequence];
//		[s add:self.subexpansion];
//		[s add:self.repeatOperator];
//		
//		[sequenceElement add:s];

		self.sequenceElement = [TODSequence sequence];
		[sequenceElement add:self.subexpansion];
		
		TODAlternation *a = [TODAlternation alternation];
		[a add:[TODEmpty empty]];
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
- (TODCollectionParser *)subexpansion {
	if (!subexpansion) {
		self.subexpansion = [TODAlternation alternation];
		
		TODSequence *s = [TODSequence sequence];
		[s add:self.token];
		TODAlternation *a = [TODAlternation alternation];
		[a add:[TODEmpty empty]];
		[a add:self.languageAttachment];
		[s add:a];
		[subexpansion add:s];
		
		[subexpansion add:self.ruleRef];
		[subexpansion add:self.tag];
		
		s = [TODSequence sequence];
		[s add:[TODSymbol symbolWithString:@"("]];
		[s add:[TODSymbol symbolWithString:@")"]];
		[subexpansion add:s];
		
		s = [TODSequence sequence];
		[s add:[TODSymbol symbolWithString:@"("]];
		[s add:self.ruleExpansion];		
		[s add:[TODSymbol symbolWithString:@")"]];
		a = [TODAlternation alternation];
		[a add:[TODEmpty empty]];
		[a add:self.languageAttachment];
		[s add:a];
		[subexpansion add:s];
		
		s = [TODSequence sequence];
		[s add:[TODSymbol symbolWithString:@"["]];
		[s add:self.ruleExpansion];		
		[s add:[TODSymbol symbolWithString:@"]"]];
		a = [TODAlternation alternation];
		[a add:[TODEmpty empty]];
		[a add:self.languageAttachment];
		[s add:a];
		[subexpansion add:s];
	}
	return subexpansion;
}


// ruleRef  ::= localRuleRef | ExternalRuleRef | specialRuleRef
- (TODCollectionParser *)ruleRef {
	if (!ruleRef) {
		self.ruleRef = [TODAlternation alternation];
		[ruleRef add:self.localRuleRef];
		[ruleRef add:self.externalRuleRef];
		[ruleRef add:self.specialRuleRef];
	}
	return ruleRef;
}

// localRuleRef    ::= RuleName
- (TODCollectionParser *)localRuleRef {
	if (!localRuleRef) {
		self.localRuleRef = self.ruleName;
	}
	return localRuleRef;
}


// specialRuleRef  ::= '$NULL' | '$VOID' | '$GARBAGE'
- (TODCollectionParser *)specialRuleRef {
	if (!specialRuleRef) {
		self.specialRuleRef = [TODAlternation alternation];
		[specialRuleRef add:[TODLiteral literalWithString:@"$NULL"]];
		[specialRuleRef add:[TODLiteral literalWithString:@"$VOID"]];
		[specialRuleRef add:[TODLiteral literalWithString:@"$GARBAGE"]];
	}
	return specialRuleRef;
}


// repeatOperator  ::='<' Repeat Probability? '>'
- (TODCollectionParser *)repeatOperator {
	if (!repeatOperator) {
		self.repeatOperator = [TODSequence sequence];
		[repeatOperator add:[TODSymbol symbolWithString:@"<"]];
		[repeatOperator add:self.repeat];
		
		TODAlternation *a = [TODAlternation alternation];
		[a add:[TODEmpty empty]];
		[a add:self.probability];
		[repeatOperator add:a];
		
		[repeatOperator add:[TODSymbol symbolWithString:@">"]];
	}
	return repeatOperator;
}


//BaseURI ::= ABNF_URI
- (TODCollectionParser *)baseURI {
	if (!baseURI) {
		self.baseURI = [TODWord word];
	}
	return baseURI;
}


//LanguageCode ::= Nmtoken
- (TODCollectionParser *)languageCode {
	if (!languageCode) {
		self.languageCode = [TODSequence sequence];
		[languageCode add:[TODWord word]];
//		[languageCode add:[TODSymbol symbolWithString:@"-"]];
//		[languageCode add:[TODWord word]];
	}
	return languageCode;
}


- (TODCollectionParser *)ABNF_URI {
	if (!ABNF_URI) {
		self.ABNF_URI = [TODWord word];
	}
	return ABNF_URI;
}


- (TODCollectionParser *)ABNF_URI_with_Media_Type {
	if (!ABNF_URI_with_Media_Type) {
		self.ABNF_URI_with_Media_Type = [TODWord word];
	}
	return ABNF_URI_with_Media_Type;
}



#pragma mark -
#pragma mark Assembler Methods

- (void)workOnWordAssembly:(TODAssembly *)a {
//	NSLog(@"%s", _cmd);
//	NSLog(@"a: %@", a);
	TODToken *tok = [a pop];
	[a push:[TODLiteral literalWithString:tok.stringValue]];
}


- (void)workOnNumAssembly:(TODAssembly *)a {
//	NSLog(@"%s", _cmd);
//	NSLog(@"a: %@", a);
	TODToken *tok = [a pop];
	[a push:[TODLiteral literalWithString:tok.stringValue]];
}


- (void)workOnQuotedStringAssembly:(TODAssembly *)a {
//	NSLog(@"%s", _cmd);
//	NSLog(@"a: %@", a);
	TODToken *tok = [a pop];
	NSString *s = [tok.stringValue stringByRemovingFirstAndLastCharacters];
	
	TODSequence *p = [TODSequence sequence];
	TODTokenizer *t = [TODTokenizer tokenizerWithString:s];
	TODToken *eof = [TODToken EOFToken];
	while (eof != (tok = [t nextToken])) {
		[p add:[TODLiteral literalWithString:tok.stringValue]];
	}
	
	[a push:p];
}


- (void)workOnStarAssembly:(TODAssembly *)a {
//	NSLog(@"%s", _cmd);
//	NSLog(@"a: %@", a);
	TODRepetition *p = [TODRepetition repetitionWithSubparser:[a pop]];
	[a push:p];
}


- (void)workOnQuestionAssembly:(TODAssembly *)a {
//	NSLog(@"%s", _cmd);
//	NSLog(@"a: %@", a);
	TODAlternation *p = [TODAlternation alternation];
	[p add:[a pop]];
	[p add:[TODEmpty empty]];
	[a push:p];
}


- (void)workOnAndAssembly:(TODAssembly *)a {
//	NSLog(@"%s", _cmd);
//	NSLog(@"a: %@", a);
	id top = [a pop];
	TODSequence *p = [TODSequence sequence];
	[p add:[a pop]];
	[p add:top];
	[a push:p];
}


- (void)workOnOrAssembly:(TODAssembly *)a {
//	NSLog(@"%s", _cmd);
//	NSLog(@"a: %@", a);
	id top = [a pop];
//	NSLog(@"top: %@", top);
//	NSLog(@"top class: %@", [top class]);
	TODAlternation *p = [TODAlternation alternation];
	[p add:[a pop]];
	[p add:top];
	[a push:p];
}


- (void)workOnAssignmentAssembly:(TODAssembly *)a {
//	NSLog(@"%s", _cmd);
//	NSLog(@"a: %@", a);
	id val = [a pop];
	TODToken *keyTok = [a pop];
	
	NSMutableDictionary *table = [NSMutableDictionary dictionaryWithDictionary:a.target];
	[table setObject:val forKey:keyTok.stringValue];
	a.target = table;
}


- (void)workOnVariableAssembly:(TODAssembly *)a {
//	NSLog(@"%s", _cmd);
//	NSLog(@"a: %@", a);
	TODToken *keyTok = [a pop];
	id val = [a.target objectForKey:keyTok.stringValue];
	
//	TODParser *p = nil;
//	if (valTok.isWord) {
//		p = [TODWord wordWithString:valTok.value];
//	} else if (valTok.isQuotedString) {
//		p = [TODQuotedString quotedStringWithString:valTok.value];
//	} else if (valTok.isNumber) {
//		p = [TODNum numWithString:valTok.stringValue];
//	}
	
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