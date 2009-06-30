//
//  PKJsonParser.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 7/18/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDJsonParser.h"
#import "ParseKit.h"
#import "NSString+TDParseKitAdditions.h"

@interface PKCollectionParser ()
@property (nonatomic, readwrite, retain) NSMutableArray *subparsers;
@end

@interface TDJsonParser ()
@property (nonatomic, retain, readwrite) PKTokenizer *tokenizer;
@property (nonatomic, retain) PKToken *curly;
@property (nonatomic, retain) PKToken *bracket;
@end

@implementation TDJsonParser

- (id)init {
    return [self initWithIntentToAssemble:YES];
}


- (id)initWithIntentToAssemble:(BOOL)yn {
    if (self = [super init]) {
        shouldAssemble = yn;
        self.curly = [PKToken tokenWithTokenType:TDTokenTypeSymbol stringValue:@"{" floatValue:0.0];
        self.bracket = [PKToken tokenWithTokenType:TDTokenTypeSymbol stringValue:@"[" floatValue:0.0];
        
        self.tokenizer = [PKTokenizer tokenizer];
        [tokenizer setTokenizerState:tokenizer.symbolState from: '/' to: '/']; // JSON doesn't have slash slash or slash star comments
        [tokenizer setTokenizerState:tokenizer.symbolState from: '\'' to: '\'']; // JSON does not have single quoted strings
        
        [self add:self.objectParser];    
        [self add:self.arrayParser];
    }
    return self;
}


- (void)dealloc {
    // yikes. this is necessary to prevent a very nasty retain cycle leak.
    // to be safe, release the subparsers of all collection parsers (as they may have retain cycles in complex grammars like this one)
    // technically i only need to release the valueParser.subparers in this case, but better to be paranoid than to leak.
    booleanParser.subparsers = nil;
    arrayParser.subparsers = nil;
    objectParser.subparsers = nil;
    valueParser.subparsers = nil;
    commaValueParser.subparsers = nil;
    propertyParser.subparsers = nil;
    commaPropertyParser.subparsers = nil;
    
    self.tokenizer = nil;
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
    tokenizer.string = s;
    PKTokenAssembly *a = [PKTokenAssembly assemblyWithTokenizer:tokenizer];
    
    PKAssembly *result = [self completeMatchFor:a];
    return [result pop];
}


- (PKParser *)stringParser {
    if (!stringParser) {
        self.stringParser = [PKQuotedString quotedString];
        if (shouldAssemble) {
            [stringParser setAssembler:self selector:@selector(workOnString:)];
        }
    }
    return stringParser;
}


- (PKParser *)numberParser {
    if (!numberParser) {
        self.numberParser = [PKNum num];
        if (shouldAssemble) {
            [numberParser setAssembler:self selector:@selector(workOnNumber:)];
        }
    }
    return numberParser;
}


- (PKParser *)nullParser {
    if (!nullParser) {
        self.nullParser = [[PKLiteral literalWithString:@"null"] discard];
        if (shouldAssemble) {
            [nullParser setAssembler:self selector:@selector(workOnNull:)];
        }
    }
    return nullParser;
}


- (PKCollectionParser *)booleanParser {
    if (!booleanParser) {
        self.booleanParser = [PKAlternation alternation];
        [booleanParser add:[PKLiteral literalWithString:@"true"]];
        [booleanParser add:[PKLiteral literalWithString:@"false"]];
        if (shouldAssemble) {
            [booleanParser setAssembler:self selector:@selector(workOnBoolean:)];
        }
    }
    return booleanParser;
}


- (PKCollectionParser *)arrayParser {
    if (!arrayParser) {

        // array = '[' content ']'
        // content = Empty | actualArray
        // actualArray = value commaValue*

        PKTrack *actualArray = [PKTrack sequence];
        [actualArray add:self.valueParser];
        [actualArray add:[PKRepetition repetitionWithSubparser:self.commaValueParser]];

        PKAlternation *content = [PKAlternation alternation];
        [content add:[PKEmpty empty]];
        [content add:actualArray];
        
        self.arrayParser = [PKSequence sequence];
        [arrayParser add:[PKSymbol symbolWithString:@"["]]; // serves as fence
        [arrayParser add:content];
        [arrayParser add:[[PKSymbol symbolWithString:@"]"] discard]];
        
        if (shouldAssemble) {
            [arrayParser setAssembler:self selector:@selector(workOnArray:)];
        }
    }
    return arrayParser;
}


- (PKCollectionParser *)objectParser {
    if (!objectParser) {
        
        // object = '{' content '}'
        // content = Empty | actualObject
        // actualObject = property commaProperty*
        // property = QuotedString ':' value
        // commaProperty = ',' property
        
        PKTrack *actualObject = [PKTrack sequence];
        [actualObject add:self.propertyParser];
        [actualObject add:[PKRepetition repetitionWithSubparser:self.commaPropertyParser]];
        
        PKAlternation *content = [PKAlternation alternation];
        [content add:[PKEmpty empty]];
        [content add:actualObject];
        
        self.objectParser = [PKSequence sequence];
        [objectParser add:[PKSymbol symbolWithString:@"{"]]; // serves as fence
        [objectParser add:content];
        [objectParser add:[[PKSymbol symbolWithString:@"}"] discard]];

        if (shouldAssemble) {
            [objectParser setAssembler:self selector:@selector(workOnObject:)];
        }
    }
    return objectParser;
}


- (PKCollectionParser *)valueParser {
    if (!valueParser) {
        self.valueParser = [PKAlternation alternation];
        [valueParser add:self.stringParser];
        [valueParser add:self.numberParser];
        [valueParser add:self.nullParser];
        [valueParser add:self.booleanParser];
        [valueParser add:self.arrayParser];
        [valueParser add:self.objectParser];
    }
    return valueParser;
}


- (PKCollectionParser *)commaValueParser {
    if (!commaValueParser) {
        self.commaValueParser = [PKTrack sequence];
        [commaValueParser add:[[PKSymbol symbolWithString:@","] discard]];
        [commaValueParser add:self.valueParser];
    }
    return commaValueParser;
}


- (PKCollectionParser *)propertyParser {
    if (!propertyParser) {
        self.propertyParser = [PKSequence sequence];
        [propertyParser add:[PKQuotedString quotedString]];
        [propertyParser add:[[PKSymbol symbolWithString:@":"] discard]];
        [propertyParser add:self.valueParser];
        if (shouldAssemble) {
            [propertyParser setAssembler:self selector:@selector(workOnProperty:)];
        }
    }
    return propertyParser;
}


- (PKCollectionParser *)commaPropertyParser {
    if (!commaPropertyParser) {
        self.commaPropertyParser = [PKTrack sequence];
        [commaPropertyParser add:[[PKSymbol symbolWithString:@","] discard]];
        [commaPropertyParser add:self.propertyParser];
    }
    return commaPropertyParser;
}


- (void)workOnNull:(PKAssembly *)a {
    [a push:[NSNull null]];
}


- (void)workOnNumber:(PKAssembly *)a {
    PKToken *tok = [a pop];
    [a push:[NSNumber numberWithFloat:tok.floatValue]];
}


- (void)workOnString:(PKAssembly *)a {
    PKToken *tok = [a pop];
    [a push:[tok.stringValue stringByTrimmingQuotes]];
}


- (void)workOnBoolean:(PKAssembly *)a {
    PKToken *tok = [a pop];
    [a push:[NSNumber numberWithBool:[tok.stringValue isEqualToString:@"true"] ? YES : NO]];
}


- (void)workOnArray:(PKAssembly *)a {
    NSArray *elements = [a objectsAbove:self.bracket];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:elements.count];
    
    for (id element in [elements reverseObjectEnumerator]) {
        if (element) {
            [array addObject:element];
        }
    }
    [a pop]; // pop the [
    [a push:array];
}


- (void)workOnObject:(PKAssembly *)a {
    NSArray *elements = [a objectsAbove:self.curly];
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithCapacity:elements.count / 2.];
    
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


- (void)workOnProperty:(PKAssembly *)a {
    id value = [a pop];
    PKToken *tok = [a pop];
    NSString *key = [tok.stringValue stringByTrimmingQuotes];
    
    [a push:key];
    [a push:value];
}

@synthesize tokenizer;
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
