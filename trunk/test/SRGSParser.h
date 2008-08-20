//
//  SRGSParser.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/15/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TODParseKit/TODParseKit.h>

@interface SRGSParser : TODSequence {
	TODCollectionParser *selfIdentHeader;
	TODCollectionParser *ruleName;
	TODCollectionParser *tagFormat;
	TODCollectionParser *lexiconURI;
	TODCollectionParser *weight;
	TODCollectionParser *repeat;
	TODCollectionParser *probability;
	TODCollectionParser *externalRuleRef;
	TODCollectionParser *token;
	TODCollectionParser *languageAttachment;
	TODCollectionParser *tag;
	TODCollectionParser *grammar;
	TODCollectionParser *declaration;
	TODCollectionParser *baseDecl;
	TODCollectionParser *languageDecl;
	TODCollectionParser *modeDecl;
	TODCollectionParser *rootRuleDecl;
	TODCollectionParser *tagFormatDecl;
	TODCollectionParser *lexiconDecl;
	TODCollectionParser *metaDecl;
	TODCollectionParser *tagDecl;
	TODCollectionParser *ruleDefinition;
	TODCollectionParser *scope;
	TODCollectionParser *ruleExpansion;
	TODCollectionParser *ruleAlternative;
	TODCollectionParser *sequenceElement;
	TODCollectionParser *subexpansion;
	TODCollectionParser *ruleRef;
	TODCollectionParser *localRuleRef;
	TODCollectionParser *specialRuleRef;
	TODCollectionParser *repeatOperator;
	
	TODCollectionParser *baseURI;
	TODCollectionParser *languageCode;
	TODCollectionParser *ABNF_URI;
	TODCollectionParser *ABNF_URI_with_Media_Type;
}
- (id)parse:(NSString *)s;
- (TODAssembly *)assemblyWithString:(NSString *)s;

@property (nonatomic, retain) TODCollectionParser *selfIdentHeader;
@property (nonatomic, retain) TODCollectionParser *ruleName;
@property (nonatomic, retain) TODCollectionParser *tagFormat;
@property (nonatomic, retain) TODCollectionParser *lexiconURI;
@property (nonatomic, retain) TODCollectionParser *weight;
@property (nonatomic, retain) TODCollectionParser *repeat;
@property (nonatomic, retain) TODCollectionParser *probability;
@property (nonatomic, retain) TODCollectionParser *externalRuleRef;
@property (nonatomic, retain) TODCollectionParser *token;
@property (nonatomic, retain) TODCollectionParser *languageAttachment;
@property (nonatomic, retain) TODCollectionParser *tag;
@property (nonatomic, retain) TODCollectionParser *grammar;
@property (nonatomic, retain) TODCollectionParser *declaration;
@property (nonatomic, retain) TODCollectionParser *baseDecl;
@property (nonatomic, retain) TODCollectionParser *languageDecl;
@property (nonatomic, retain) TODCollectionParser *modeDecl;
@property (nonatomic, retain) TODCollectionParser *rootRuleDecl;
@property (nonatomic, retain) TODCollectionParser *tagFormatDecl;
@property (nonatomic, retain) TODCollectionParser *lexiconDecl;
@property (nonatomic, retain) TODCollectionParser *metaDecl;
@property (nonatomic, retain) TODCollectionParser *tagDecl;
@property (nonatomic, retain) TODCollectionParser *ruleDefinition;
@property (nonatomic, retain) TODCollectionParser *scope;
@property (nonatomic, retain) TODCollectionParser *ruleExpansion;
@property (nonatomic, retain) TODCollectionParser *ruleAlternative;
@property (nonatomic, retain) TODCollectionParser *sequenceElement;
@property (nonatomic, retain) TODCollectionParser *subexpansion;
@property (nonatomic, retain) TODCollectionParser *ruleRef;
@property (nonatomic, retain) TODCollectionParser *localRuleRef;
@property (nonatomic, retain) TODCollectionParser *specialRuleRef;
@property (nonatomic, retain) TODCollectionParser *repeatOperator;

@property (nonatomic, retain) TODCollectionParser *baseURI;
@property (nonatomic, retain) TODCollectionParser *languageCode;
@property (nonatomic, retain) TODCollectionParser *ABNF_URI;
@property (nonatomic, retain) TODCollectionParser *ABNF_URI_with_Media_Type;
@end
