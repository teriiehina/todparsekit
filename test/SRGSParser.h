//
//  SRGSParser.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/15/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/ParseKit.h>

@interface SRGSParser : TDSequence {
    TDCollectionParser *selfIdentHeader;
    TDCollectionParser *ruleName;
    TDCollectionParser *tagFormat;
    TDCollectionParser *lexiconURI;
    TDCollectionParser *weight;
    TDCollectionParser *repeat;
    TDCollectionParser *probability;
    TDCollectionParser *externalRuleRef;
    TDCollectionParser *token;
    TDCollectionParser *languageAttachment;
    TDCollectionParser *tag;
    TDCollectionParser *grammar;
    TDCollectionParser *declaration;
    TDCollectionParser *baseDecl;
    TDCollectionParser *languageDecl;
    TDCollectionParser *modeDecl;
    TDCollectionParser *rootRuleDecl;
    TDCollectionParser *tagFormatDecl;
    TDCollectionParser *lexiconDecl;
    TDCollectionParser *metaDecl;
    TDCollectionParser *tagDecl;
    TDCollectionParser *ruleDefinition;
    TDCollectionParser *scope;
    TDCollectionParser *ruleExpansion;
    TDCollectionParser *ruleAlternative;
    TDCollectionParser *sequenceElement;
    TDCollectionParser *subexpansion;
    TDCollectionParser *ruleRef;
    TDCollectionParser *localRuleRef;
    TDCollectionParser *specialRuleRef;
    TDCollectionParser *repeatOperator;
    
    TDCollectionParser *baseURI;
    TDCollectionParser *languageCode;
    TDCollectionParser *ABNF_URI;
    TDCollectionParser *ABNF_URI_with_Media_Type;
}
- (id)parse:(NSString *)s;
- (TDAssembly *)assemblyWithString:(NSString *)s;

@property (nonatomic, retain) TDCollectionParser *selfIdentHeader;
@property (nonatomic, retain) TDCollectionParser *ruleName;
@property (nonatomic, retain) TDCollectionParser *tagFormat;
@property (nonatomic, retain) TDCollectionParser *lexiconURI;
@property (nonatomic, retain) TDCollectionParser *weight;
@property (nonatomic, retain) TDCollectionParser *repeat;
@property (nonatomic, retain) TDCollectionParser *probability;
@property (nonatomic, retain) TDCollectionParser *externalRuleRef;
@property (nonatomic, retain) TDCollectionParser *token;
@property (nonatomic, retain) TDCollectionParser *languageAttachment;
@property (nonatomic, retain) TDCollectionParser *tag;
@property (nonatomic, retain) TDCollectionParser *grammar;
@property (nonatomic, retain) TDCollectionParser *declaration;
@property (nonatomic, retain) TDCollectionParser *baseDecl;
@property (nonatomic, retain) TDCollectionParser *languageDecl;
@property (nonatomic, retain) TDCollectionParser *modeDecl;
@property (nonatomic, retain) TDCollectionParser *rootRuleDecl;
@property (nonatomic, retain) TDCollectionParser *tagFormatDecl;
@property (nonatomic, retain) TDCollectionParser *lexiconDecl;
@property (nonatomic, retain) TDCollectionParser *metaDecl;
@property (nonatomic, retain) TDCollectionParser *tagDecl;
@property (nonatomic, retain) TDCollectionParser *ruleDefinition;
@property (nonatomic, retain) TDCollectionParser *scope;
@property (nonatomic, retain) TDCollectionParser *ruleExpansion;
@property (nonatomic, retain) TDCollectionParser *ruleAlternative;
@property (nonatomic, retain) TDCollectionParser *sequenceElement;
@property (nonatomic, retain) TDCollectionParser *subexpansion;
@property (nonatomic, retain) TDCollectionParser *ruleRef;
@property (nonatomic, retain) TDCollectionParser *localRuleRef;
@property (nonatomic, retain) TDCollectionParser *specialRuleRef;
@property (nonatomic, retain) TDCollectionParser *repeatOperator;

@property (nonatomic, retain) TDCollectionParser *baseURI;
@property (nonatomic, retain) TDCollectionParser *languageCode;
@property (nonatomic, retain) TDCollectionParser *ABNF_URI;
@property (nonatomic, retain) TDCollectionParser *ABNF_URI_with_Media_Type;
@end
