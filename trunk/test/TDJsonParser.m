//
//  TDJsonParser.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/18/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDJsonParser.h"
#import "TDParseKit.h"
#import "NSString+TDParseKitAdditions.h"

@interface TDJsonParser ()
@property (retain) TDToken *curly;
@property (retain) TDToken *bracket;
@end

@implementation TDJsonParser

- (id)init {
    self = [super init];
    if (self != nil) {
        self.curly = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:@"{" floatValue:0.0f];
        self.bracket = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:@"[" floatValue:0.0f];
    }
    return self;
}


- (void)dealloc {
    self.stringParser = nil;
    self.numberParser = nil;
    self.nullParser = nil;
    self.booleanParser = nil;
    self.arrayParser = nil;
    self.objectParser = nil;
    self.valueParser = nil;
    self.propertyParser = nil;
    self.commaPropertyParser = nil;
    self.commaValueParser = nil;
    self.curly = nil;
    self.bracket = nil;
    [super dealloc];
}


- (id)parse:(NSString *)s {
    [self add:[TDEmpty empty]];
    [self add:self.arrayParser];
    [self add:self.objectParser];
    
    TDTokenAssembly *a = [TDTokenAssembly assemblyWithString:s];
    
    TDTokenizer *tokenizer = a.tokenizer;
    [tokenizer setTokenizerState:tokenizer.symbolState from: '/' to: '/']; // JSON doesn't have slash slash or slash star comments
    [tokenizer setTokenizerState:tokenizer.symbolState from: '\'' to: '\'']; // JSON does not have single quoted strings

    TDAssembly *result = [self completeMatchFor:a];
    return [result pop];
}


- (TDParser *)stringParser {
    if (!stringParser) {
        self.stringParser = [TDQuotedString quotedString];
        [stringParser setAssembler:self selector:@selector(workOnStringAssembly:)];
    }
    return stringParser;
}


- (TDParser *)numberParser {
    if (!numberParser) {
        self.numberParser = [TDNum num];
        [numberParser setAssembler:self selector:@selector(workOnNumberAssembly:)];
    }
    return numberParser;
}


- (TDParser *)nullParser {
    if (!nullParser) {
        self.nullParser = [[TDLiteral literalWithString:@"null"] discard];
        [nullParser setAssembler:self selector:@selector(workOnNullAssembly:)];
    }
    return nullParser;
}


- (TDCollectionParser *)booleanParser {
    if (!booleanParser) {
        self.booleanParser = [TDAlternation alternation];
        [booleanParser add:[TDLiteral literalWithString:@"true"]];
        [booleanParser add:[TDLiteral literalWithString:@"false"]];
        [booleanParser setAssembler:self selector:@selector(workOnBooleanAssembly:)];
    }
    return booleanParser;
}


- (TDCollectionParser *)arrayParser {
    if (!arrayParser) {

        // array = '[' content ']'
        // content = Empty | actualArray
        // actualArray = value commaValue*

        TDTrack *actualArray = [TDTrack sequence];
        [actualArray add:self.valueParser];
        [actualArray add:[TDRepetition repetitionWithSubparser:self.commaValueParser]];

        TDAlternation *content = [TDAlternation alternation];
        [content add:[TDEmpty empty]];
        [content add:actualArray];
        
        self.arrayParser = [TDSequence sequence];
        [arrayParser add:[TDSymbol symbolWithString:@"["]];
        [arrayParser add:content];
        [arrayParser add:[[TDSymbol symbolWithString:@"]"] discard]];
        
        [arrayParser setAssembler:self selector:@selector(workOnArrayAssembly:)];
    }
    return arrayParser;
}


- (TDCollectionParser *)objectParser {
    if (!objectParser) {
        
        // object = '{' content '}'
        // content = Empty | actualObject
        // actualObject = property commaProperty*
        // property = QuotedString ':' value
        // commaProperty = ',' property
        
        TDTrack *actualObject = [TDTrack sequence];
        [actualObject add:self.propertyParser];
        [actualObject add:[TDRepetition repetitionWithSubparser:self.commaPropertyParser]];
        
        TDAlternation *content = [TDAlternation alternation];
        [content add:[TDEmpty empty]];
        [content add:actualObject];
        
        self.objectParser = [TDSequence sequence];
        [objectParser add:[TDSymbol symbolWithString:@"{"]];
        [objectParser add:content];
        [objectParser add:[[TDSymbol symbolWithString:@"}"] discard]];

        [objectParser setAssembler:self selector:@selector(workOnObjectAssembly:)];
    }
    return objectParser;
}


- (TDCollectionParser *)valueParser {
    if (!valueParser) {
        self.valueParser = [TDAlternation alternation];
        [valueParser add:self.stringParser];
        [valueParser add:self.numberParser];
        [valueParser add:self.nullParser];
        [valueParser add:self.booleanParser];
        [valueParser add:self.arrayParser];
        [valueParser add:self.objectParser];
    }
    return valueParser;
}


- (TDCollectionParser *)commaValueParser {
    if (!commaValueParser) {
        self.commaValueParser = [TDTrack sequence];
        [commaValueParser add:[[TDSymbol symbolWithString:@","] discard]];
        [commaValueParser add:self.valueParser];
    }
    return commaValueParser;
}


- (TDCollectionParser *)propertyParser {
    if (!propertyParser) {
        self.propertyParser = [TDSequence sequence];
        [propertyParser add:[TDQuotedString quotedString]];
        [propertyParser add:[[TDSymbol symbolWithString:@":"] discard]];
        [propertyParser add:self.valueParser];
        [propertyParser setAssembler:self selector:@selector(workOnPropertyAssembly:)];
    }
    return propertyParser;
}


- (TDCollectionParser *)commaPropertyParser {
    if (!commaPropertyParser) {
        self.commaPropertyParser = [TDTrack sequence];
        [commaPropertyParser add:[[TDSymbol symbolWithString:@","] discard]];
        [commaPropertyParser add:self.propertyParser];
    }
    return commaPropertyParser;
}


- (void)workOnNullAssembly:(TDAssembly *)a {
    [a push:[NSNull null]];
}


- (void)workOnNumberAssembly:(TDAssembly *)a {
    TDToken *tok = [a pop];
    [a push:[NSNumber numberWithFloat:tok.floatValue]];
}


- (void)workOnStringAssembly:(TDAssembly *)a {
    TDToken *tok = [a pop];
    [a push:[tok.stringValue stringByRemovingFirstAndLastCharacters]];
}


- (void)workOnBooleanAssembly:(TDAssembly *)a {
    TDToken *tok = [a pop];
    [a push:[NSNumber numberWithBool:[tok.stringValue isEqualToString:@"true"] ? YES : NO]];
}


- (void)workOnArrayAssembly:(TDAssembly *)a {
    NSArray *elements = [a objectsAbove:self.bracket];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:elements.count];
    
    NSEnumerator *e = [elements reverseObjectEnumerator];
    id element = nil;
    while (element = [e nextObject]) {
        if (element) {
            [array addObject:element];
        }
    }
    [a pop]; // pop the [
    [a push:array];
}


- (void)workOnObjectAssembly:(TDAssembly *)a {
    NSArray *elements = [a objectsAbove:self.curly];
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    
    NSInteger i = 0;
    for ( ; i < elements.count - 1; i++) {
        id value = [elements objectAtIndex:i++];
        NSString *key = [elements objectAtIndex:i];
        if (key && value) {
            [d setObject:value forKey:key];
        }
    }
    
    [a pop]; // pop the {
    [a push:d];
}


- (void)workOnPropertyAssembly:(TDAssembly *)a {
    id value = [a pop];
    TDToken *tok = [a pop];
    NSString *key = [tok.stringValue stringByRemovingFirstAndLastCharacters];
    
    [a push:key];
    [a push:value];
}

@synthesize stringParser;
@synthesize numberParser;
@synthesize nullParser;
@synthesize booleanParser;
@synthesize arrayParser;
@synthesize objectParser;
@synthesize valueParser;
@synthesize commaValueParser;
@synthesize propertyParser;
@synthesize commaPropertyParser;
@synthesize curly;
@synthesize bracket;
@end
