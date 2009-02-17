//
//  RelaxParser.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/15/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "RelaxParser.h"

@implementation RelaxParser

- (TDTokenizer *)tokenizer {
	if (!tokenizer) {
		self.tokenizer = [TDTokenizer tokenizer];
		[tokenizer.symbolState add:@"|="];
		[tokenizer.symbolState add:@"&="];
	}
	return tokenizer;
}

// topLevel ::= decl* (pattern | grammarContent*)
- (TDCollectionParser *)topLevelParser {
	if (!topLevelParser) {
		self.topLevelParser = [TDSequence sequence];
		
		TDAlternation *a = [TDAlternation alternation];
		[a add:[TDEmpty empty]];
		[a add:self.declParser];
		[topLevelParser add:a];
		
		a = [TDAlternation alternation];
		[a add:self.patternParser];
		[a add:[TDRepetition repetitionWithSubparser:self.grammarContentParser]];
		[topLevelParser add:a];
	}
	return topLevelParser;
}

// decl ::= "namespace" identifierOrKeyword "=" namespaceURILiteral
// | "default" "namespace" [identifierOrKeyword] "=" namespaceURILiteral
// | "datatypes" identifierOrKeyword "=" literal
- (TDCollectionParser *)declParser {
	if (!declParser) {
		self.declParser = [TDAlternation alternation];
		
		TDSequence *s = [TDSequence sequence];
		[s add:[TDLiteral literalWithString:@"namespace"]];
		[s add:self.identifierOrKeywordParser];
		[s add:[TDSymbol symbolWithString:@"="]];
		[a add:self.namespaceURILiteralParser];
		[declParser add:s];
		
		s = [TDSequence sequence];
		[s add:[TDLiteral literalWithString:@"default"]];
		[s add:[TDLiteral literalWithString:@"namespace"]];
		[s add:self.identifierOrKeywordParser];
		[s add:[TDSymbol symbolWithString:@"="]];
		[a add:self.namespaceURILiteralParser];
		[declParser add:s];
		
		s = [TDSequence sequence];
		[s add:[TDLiteral literalWithString:@"datatypes"]];
		[s add:self.identifierOrKeywordParser];
		[s add:[TDSymbol symbolWithString:@"="]];
		[a add:[TDQuotedString quotedString]];
		[declParser add:s];		
	}
	return declParser;
}


- (TDCollectionParser *)atLeastOneOf:(TDParser *)p {
	TDSequence *s = [TDSequence sequence];
	[s add:p];
	[s add:[TDRepetition repetitionWithSubparser:p]];
	return s;
}

// pattern ::= 
//  elementPattern
// | attributePattern
// | pattern commaPattern+
// | pattern andPattern+
// | pattern orPattern+
// | patternQuestion
// | patternStar
// | patternPlus
// | listPattern
// | mixedPattern
// | identifier
// | parent
// | emptyKeyword
// | textKeyword
// | [datatypeName] datatypeValue
// | datatypeName ["{" param* "}"] [exceptPattern]
// | "notAllowed"
// | "external" anyURILiteral [inherit]
// | "grammar" "{" grammarContent* "}"
// | "(" pattern ")"
- (TDCollectionParser *)patternParser {
	if (!patternParser) {
		self.patternParser = [TDAlternation alternation];
		[patternParser add:self.elementPatternParser];
		[patternParser add:self.attributePatternParser];
		[patternParser add:[self atLeastOneOf:self.commaPatternParser]];
		[patternParser add:[self atLeastOneOf:self.andPatternParser]];
		[patternParser add:[self atLeastOneOf:self.orPatternParser]];
		[patternParser add:[self atLeastOneOf:self.patternQuestionParser]];
		[patternParser add:[self atLeastOneOf:self.patternStarParser]];
		[patternParser add:[self atLeastOneOf:self.patternPlusParser]];
		[patternParser add:self.listPatternParser];
		[patternParser add:self.mixedPatternParser];
		[patternParser add:self.identifierParser];
		[patternParser add:self.parentParser];
		[patternParser add:self.emptyKeywordParser];
		[patternParser add:self.textKeywordParser];
		
		
        
        
		s = [TDSequence sequence];
		[s add:patternParser];
		
	}
}

// elementPattern := "element" nameClass "{" pattern "}"
- (TDCollectionParser *)elementPatternParser {
	if (!elementPatternParser) {
		self.elementPatternParser = [TDSequence sequence];
		[elementPatternParser add:[TDLiteral literalWithString:@"element"]];
		[elementPatternParser add:self.nameClass];
		[elementPatternParser add:[TDSymbol symbolWithString:@"{"]];
		[elementPatternParser add:patternParser];
		[elementPatternParser add:[TDSymbol symbolWithString:@"}"]];
	}
	return elementPatternParser;
}


// attributePattern := "attribute" nameClass "{" pattern "}"
- (TDCollectionParser *)attributePatternParser {
	if (!attributePatternParser) {
		attributePatternParser = [TDSequence sequence];
		[attributePatternParser add:[TDLiteral literalWithString:@"attribute"]];
		[attributePatternParser add:self.nameClass];
		[attributePatternParser add:[TDSymbol symbolWithString:@"{"]];
		[attributePatternParser add:patternParser];
		[attributePatternParser add:[TDSymbol symbolWithString:@"}"]];
	}
	return attributePatternParser;
}


// commaPattern := "," pattern
- (TDCollectionParser *)commaPatternParser {
	if (!commaPatternParser) {
		self.commaPatternParser = [TDSequence sequence];
		[commaPatternParser add:[TDSymbol symbolWithString:@","]];
		[commaPatternParser add:self.patternParser];
	}
	return commaPatternParser;
}


// andPattern := "&" pattern
- (TDCollectionParser *)andPatternParser {
	if (!andPatternParser) {
		self.andPatternParser = [TDSequence sequence];
		[andPatternParser add:[TDSymbol symbolWithString:@"&"]];
		[andPatternParser add:self.patternParser];
	}
	return andPatternParser;
}


// orPattern := "|" pattern
- (TDCollectionParser *)orPatternParser {
	if (!orPatternParser) {
		self.orPatternParser = [TDSequence sequence];
		[orPatternParser add:[TDSymbol symbolWithString:@"|"]];
		[orPatternParser add:self.patternParser];
	}
	return orPatternParser;
}


// patternQuestion := pattern "?"
- (TDCollectionParser *)patternQuestionParser {
	if (!patternQuestionParser) {
		self.patternQuestionParser = [TDSequence sequence];
		[patternQuestionParser add:self.patternParser];
		[patternQuestionParser add:[TDSymbol symbolWithString:@"?"]];
	}
	return patternQuestionParser;
}


// patternQuestion := pattern "*"
- (TDCollectionParser *)patternStarParser {
	if (!patternStarParser) {
		self.patternStarParser = [TDSequence sequence];
		[patternStarParser add:self.patternParser];
		[patternStarParser add:[TDSymbol symbolWithString:@"*"]];
	}
	return patternStarParser;
}


// patternQuestion := pattern "+"
- (TDCollectionParser *)patternPlusParser {
	if (!patternPlusParser) {
		self.patternPlusParser = [TDSequence sequence];
		[patternPlusParser add:self.patternParser];
		[patternPlusParser add:[TDSymbol symbolWithString:@"+"]];
	}
	return patternPlusParser;
}

// | "list" "{" pattern "}"
- (TDCollectionParser *)listPatternParser {
	if (!listPatternParser) {
		self.listPatternParser = [TDSequence sequence];
		[listPatternParser add:[TDLiteral literalWithString:@"list"]];
		[listPatternParser add:[TDSymbol symbolWithString:@"{"]];
		[listPatternParser add:patternParser];
		[listPatternParser add:[TDSymbol symbolWithString:@"}"]];
	}
	return listPatternParser;
}

// | "mixed" "{" pattern "}"
- (TDCollectionParser *)mixedPatternParser {
	if (!mixedPatternParser) {
		self.mixedPatternParser = [TDSequence sequence];
		[mixedPatternParser add:[TDLiteral literalWithString:@"mixed"]];
		[mixedPatternParser add:[TDSymbol symbolWithString:@"{"]];
		[mixedPatternParser add:patternParser];
		[mixedPatternParser add:[TDSymbol symbolWithString:@"}"]];
	}
	return mixedPatternParser;
}

// | "parent" identifier
- (TDCollectionParser *)parentParser {
	if (!parentParser) {
		self.parentParser = [TDSequence sequence];
		[parentParser add:[TDLiteral literalWithString:@"parent"]];
		[parentParser add:self.identifierParser];
	}
	return parentParser;
}


// param ::= identifierOrKeyword "=" literal
- (TDCollectionParser *)paramParser {
	if (!paramParser) {
		self.paramParser = [TDSequence sequence];
		[paramParser add:self.identifierOrKeywordParser];
		[paramParser add:[TDSymbol symbolWithString:@"="]];
		[paramParser add:self.literalParser];
	}
	return paramParser;
}

// exceptPattern ::= "-" pattern
- (TDCollectionParser *)exceptPatternParser {
	if (!exceptPattern) {
		self.exceptPattern = [TDSequence sequence];
		[exceptPattern add:[TDSymbol symbolWithString:@"-"]];
		[exceptPattern add:self.patternParser];
	}
	return exceptPattern;
}


//    grammarContent ::= start | define | "element" "{" grammarContent* "}" | "include" anyURILiteral [inherit] ["{" includeContent* "}"]
//
//    includeContent ::= define | start | elementIncludeContent
- (TDCollectionParser *)includeContentParser {
	if (!includeContentParser) {
		self.includeContentParser = [TDAlternation alternation];
		[includeContentParser add:self.defineParser];
		[includeContentParser add:self.startParser];
		[includeContentParser add:self.elementIncludeContentParser];
	}
	return includeContentParser;
}

// elementIncludeContent ::= "element" "{" includeContent* "}"
- (TDCollectionParser *)elementIncludeContentParser {
	if (!elementIncludeContentParser) {
		self.elementIncludeContentParser = [TDSequence sequence];
		[s add:self.elementKeywordParser];
		[s add:[TDSymbol symbolWithString:@"{"]];
		[s add:[TDRepetition repetitionWithSubparser:self.includeContentParser]]
		[s add:[TDSymbol symbolWithString:@"}"]];
		
		[elementIncludeContentParser add:s];
	}
	return elementIncludeContentParser;
}


//
//    start ::= "start" assignMethod pattern
- (TDCollectionParser *)startParser {
	if (!startParser) {
		self.startParser = [TDSequence sequence];
		[startParser add:self.startKeywordParser];
		[startParser add:self.assignMethodParser];
		[startParser add:self.patternParser];
	}
	return startParser;
}


//
//    define ::= identifier assignMethod pattern
- (TDCollectionParser *)defineParser {
	if (!defineParser) {
		self.defineParser = [TDSequence sequence];
		[defineParser add:self.identifierParser];
		[defineParser add:self.assignMethodParser];
		[defineParser add:self.patternParser];
	}
	return defineParser;
}


//
//    assignMethod ::= "=" | "|=" | "&="
- (TDCollectionParser *)assignMethodParser {
	if (!assignMethodParser) {
		self.assignMethodParser = [TDAlternation alternation];
		[assignMethodParser add:[TDSymbol symbolWithString:@"="]];
		[assignMethodParser add:[TDSymbol symbolWithString:@"|="]];
		[assignMethodParser add:[TDSymbol symbolWithString:@"&="]];
	}
	return assignMethodParser;
}

//
//    nameClass ::= name
//    | nsName [exceptNameClass]
//    | anyName [exceptNameClass]
//    | nameClass "|" nameClass
//    | "(" nameClass ")"
//
//    name ::= identifierOrKeyword | CName
- (TDCollectionParser *)nameParser {
	if (!nameParser) {
		self.nameParser = [TDAlternation alternation];
		[nameParser add:self.identifierOrKeywordParser];
		[nameParser add:self.CNameParser];
	}
	return nameParser;
}

//
//    exceptNameClass ::= "-" nameClass
- (TDCollectionParser *)exceptNameClassParser {
	if (!exceptNameClassParser) {
		self.exceptNameClassParser = [TDSequence sequence];
		[nameParser add:[TDSymbol symbolWithString:@"-"]];
		[nameParser add:self.nameClassParser];
	}
	return nameParser;
}

//
//    datatypeName ::= CName | "string" | "token"
- (TDCollectionParser *)datatypeNameParser {
	if (!datatypeNameParser) {
		self.datatypeNameParser = [TDAlternation alternation];
		[datatypeNameParser add:self.CNameParser];
		[datatypeNameParser add:self.stringKeywordParser];
		[datatypeNameParser add:self.tokenKeywordParser];
	}
	return datatypeNameParser;
}


//
//    datatypeValue ::= literal
- (TDCollectionParser *)datatypeValueParser {
	if (!datatypeValueParser) {
		self.datatypeValueParser = self.literalParser;
	}
	return datatypeValueParser;
}


//
//    anyURILiteral ::= literal
- (TDCollectionParser *)anyURILiteralParser {
	if (!anyURILiteralParser) {
		self.anyURILiteralParser = self.literalParser;
	}
	return anyURILiteralParser;
}


//
//    namespaceURILiteral ::= literal | "inherit"
//
//    inherit ::= "inherit" "=" identifierOrKeyword
//
//    identifierOrKeyword ::= identifier | keyword
//
//    identifier ::= (NCName - keyword) | quotedIdentifier
//
//    quotedIdentifier ::= "\" NCName
//
//    CName ::= NCName ":" NCName
//
//    nsName ::= NCName ":*"
//
//    anyName ::= "*"
//
//    literal ::= literalSegment ("~" literalSegment)+
//
//    literalSegment ::= '"' (Char - ('"' | newline))* '"'
//    | "'" (Char - ("'" | newline))* "'"
//    | '"""' (['"'] ['"'] (Char - '"'))* '"""'
//    | "'''" (["'"] ["'"] (Char - "'"))* "'''"


// keyword ::= "attribute"
// | "default"
// | "datatypes"
// | "element"
// | "empty"
// | "external"
// | "grammar"
// | "include"
// | "inherit"
// | "list"
// | "mixed"
// | "namespace"
// | "notAllowed"
// | "parent"
// | "start"
// | "string"
// | "text"
// | "token"
// 
- (TDParser *)keywordParser {
	if (!keywordParser) {
		self.keywordParser = [TDAlternation alternation];
		[keywordParser add:self.attributeKeywordParser];
		[keywordParser add:self.defaultKeywordParser];
		[keywordParser add:self.datatypesKeywordParser];
		[keywordParser add:self.elementKeywordParser];
		[keywordParser add:self.emptyKeywordParser];
		[keywordParser add:self.externalKeywordParser];
		[keywordParser add:self.grammarKeywordParser];
		[keywordParser add:self.includeKeywordParser];
		[keywordParser add:self.inheritKeywordParser];
		[keywordParser add:self.listKeywordParser];
		[keywordParser add:self.mixedKeywordParser];
		[keywordParser add:self.namespaceKeywordParser];
		[keywordParser add:self.notAllowedKeywordParser];
		[keywordParser add:self.parentKeywordParser];
		[keywordParser add:self.startKeywordParser];
		[keywordParser add:self.stringKeywordParser];
		[keywordParser add:self.textParser];
		[keywordParser add:self.tokenKeywordParser];
	}
	return keywordParser;
}


- (TDParser *)attributeKeywordParser {
	if (!attributeKeywordParser) {
		self.attributeKeywordParser = [TDLiteral literalWithString:@"attribute"];
	}
	return attributeKeywordParser;
}


- (TDParser *)defaultKeywordParser {
	if (!defaultKeywordParser) {
		self.defaultKeywordParser = [TDLiteral literalWithString:@"default"];
	}
	return defaultKeywordParser;
}


- (TDParser *)datatypesKeywordParser {
	if (!datatypesKeywordParser) {
		self.datatypesKeywordParser = [TDLiteral literalWithString:@"datatypes"];
	}
	return datatypesKeywordParser;
}


- (TDParser *)elementKeywordParser {
	if (!elementKeywordParser) {
		self.elementKeywordParser = [TDLiteral literalWithString:@"element"];
	}
	return elementKeywordParser;
}


- (TDParser *)emptyKeywordParser {
	if (!emptyKeywordParser) {
		self.emptyKeywordParser = [TDLiteral literalWithString:@"empty"];
	}
	return emptyKeywordParser;
}


- (TDParser *)externalKeywordParser {
	if (!externalKeywordParser) {
		self.externalKeywordParser = [TDLiteral literalWithString:@"external"];
	}
	return externalKeywordParser;
}


- (TDParser *)grammarKeywordParser {
	if (!grammarKeywordParser) {
		self.grammarKeywordParser = [TDLiteral literalWithString:@"grammar"];
	}
	return grammarKeywordParser;
}


- (TDParser *)includeKeywordParser {
	if (!includeKeywordParser) {
		self.includeKeywordParser = [TDLiteral literalWithString:@"include"];
	}
	return includeKeywordParser;
}


- (TDParser *)inheritKeywordParser {
	if (!inheritKeywordParser) {
		self.inheritKeywordParser = [TDLiteral literalWithString:@"inherit"];
	}
	return inheritKeywordParser;
}


- (TDParser *)listKeywordParser {
	if (!listKeywordParser) {
		self.listKeywordParser = [TDLiteral literalWithString:@"list"];
	}
	return listKeywordParser;
}


- (TDParser *)mixedKeywordParser {
	if (!mixedKeywordParser) {
		self.mixedKeywordParser = [TDLiteral literalWithString:@"mixed"];
	}
	return mixedKeywordParser;
}


- (TDParser *)namespaceKeywordParser {
	if (!namespaceKeywordParser) {
		self.namespaceKeywordParser = [TDLiteral literalWithString:@"namespace"];
	}
	return namespaceKeywordParser;
}


- (TDParser *)notAllowedKeywordParser {
	if (!notAllowedKeywordParser) {
		self.notAllowedKeywordParser = [TDLiteral literalWithString:@"notAllowed"];
	}
	return notAllowedKeywordParser;
}


- (TDParser *)parentKeywordParser {
	if (!parentKeywordParser) {
		self.parentKeywordParser = [TDLiteral literalWithString:@"parent"];
	}
	return parentKeywordParser;
}


- (TDParser *)startKeywordParser {
	if (!startKeywordParser) {
		self.startKeywordParser = [TDLiteral literalWithString:@"start"];
	}
	return startKeywordParser;
}


- (TDParser *)stringKeywordParser {
	if (!stringKeywordParser) {
		self.stringKeywordParser = [TDLiteral literalWithString:@"string"];
	}
	return stringKeywordParser;
}


- (TDParser *)textKeywordParser {
	if (!textKeywordParser) {
		self.textKeywordParser = [TDLiteral literalWithString:@"text"];
	}
	return textKeywordParser;
}


- (TDParser *)tokenKeywordParser {
	if (!tokenKeywordParser) {
		self.tokenKeywordParser = [TDLiteral literalWithString:@"token"];
	}
	return tokenKeywordParser;
}

@end