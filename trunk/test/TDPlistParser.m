//
//  TDPlistParser.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TDPlistParser.h"

//{
//    0 = 0;
//    StringKey = String;
//    "1.0" = 1;
//    dictKey =     {
//        bar = foo;
//    };
//    IntegerKey = 1;
//    <null> = <null>;
//    YESKey = 1;
//    ArrayKey =     (
//                    "one one",
//                    two,
//                    three
//                    );
//    "Null Key" = <null>;
//    emptyDictKey =     {
//    };
//    "NO Key" = 0;
//}


// dict                 = '{' dictContent '}'
// dictContent          = Empty | keyValuePair*
// keyValuePair         = key '=' value ';'
// key                  = Num | Word | QuotedString | null
// value                = Num | Word | QuotedString | null | array | dict
// null                 = '<null>'

// array                = '(' arrayContent ')'
// arrayContent         = Empty | actualArray
// actualArray          = value commaValue*
// commaValue           = ',' value

@implementation TDPlistParser

- (id)init {
    self = [super init];
    if (self != nil) {
        [self add:[TDEmpty empty]];
        [self add:self.arrayParser];
        [self add:self.dictParser];
    }
    return self;
}


- (void)dealloc {
    self.dictParser = nil;
    self.keyValuePairParser = nil;
    self.arrayParser = nil;
    self.commaValueParser = nil;
    self.keyParser = nil;
    self.valueParser = nil;
    self.nullParser = nil;
    self.numParser = nil;
    self.stringParser = nil;
    [super dealloc];
}


- (id)parse:(NSString *)s {
    TDTokenAssembly *a = [TDTokenAssembly assemblyWithString:s];
    TDTokenizer *t = a.tokenizer;
    [t.symbolState add:@"<null>"];
    TDAssembly *res = [self completeMatchFor:a];
    return [res pop];
}


// dict                 = '{' dictContent '}'
// dictContent          = Empty | keyValuePair*
- (TDCollectionParser *)dictParser {
    if (!dictParser) {
        self.dictParser = [TDSequence sequence];
        [dictParser add:[TDSymbol symbolWithString:@"{"]]; // serves as fence
        
        TDAlternation *a = [TDAlternation alternation];
        [a add:[TDEmpty empty]];
        [a add:[TDRepetition repetitionWithSubparser:self.keyValuePairParser]];
        
        [dictParser add:a];
        [dictParser add:[[TDSymbol symbolWithString:@"}"] discard]];
        
//        [dictParser setAssembler:self selector:@selector(workOnDictAssembly:)];
    }
    return dictParser;
}


// keyValuePair         = key '=' value ';'
- (TDCollectionParser *)keyValuePairParser {
    if (!keyValuePairParser) {
        self.keyValuePairParser = [TDSequence sequence];
        [keyValuePairParser add:self.keyParser];
        [keyValuePairParser add:[[TDSymbol symbolWithString:@"="] discard]];
        [keyValuePairParser add:self.valueParser];
        [keyValuePairParser add:[[TDSymbol symbolWithString:@";"] discard]];
    }
    return keyValuePairParser;
}


// array                = '(' arrayContent ')'
// arrayContent         = Empty | actualArray
// actualArray          = value commaValue*
- (TDCollectionParser *)arrayParser {
    if (!arrayParser) {
        self.arrayParser = [TDSequence sequence];
        [arrayParser add:[TDSymbol symbolWithString:@"("]]; // serves as fence
        
        TDAlternation *arrayContent = [TDAlternation alternation];
        [arrayContent add:[TDEmpty empty]];
        
        TDSequence *actualArray = [TDSequence sequence];
        [actualArray add:self.valueParser];
        [actualArray add:[TDRepetition repetitionWithSubparser:self.commaValueParser]];
        
        [arrayContent add:actualArray];
        [arrayParser add:[[TDSymbol symbolWithString:@")"] discard]];

//        [arrayParser setAssembler:self selector:@selector(workOnArrayAssembly:)];
    }
    return arrayParser;
}


// key                  = Num | Word | QuotedString | null
- (TDCollectionParser *)keyParser {
    if (!keyParser) {
        self.keyParser = [TDAlternation alternation];
        [keyParser add:[TDNum num]];
        [keyParser add:[TDWord word]];
        [keyParser add:[TDQuotedString quotedString]];
        [keyParser add:self.nullParser];
    }
    return keyParser;
}


// value                = Num | Word | QuotedString | null | array | dict
- (TDCollectionParser *)valueParser {
    if (!valueParser) {
        self.valueParser = [TDAlternation alternation];
        [valueParser add:self.numParser];
        [valueParser add:self.stringParser];
        [valueParser add:self.nullParser];
        [valueParser add:self.arrayParser];
        [valueParser add:self.dictParser];
        
//        [valueParser setAssembler:self selector:@selector(workOnValueAssembly:)];
    }
    return valueParser;
}


- (TDParser *)nullParser {
    if (!nullParser) {
        self.nullParser = [TDLiteral literalWithString:@"<null>"];
        [nullParser setAssembler:self selector:@selector(workOnNullAssembly:)];
    }
    return nullParser;
}


- (TDParser *)numParser {
    if (!numParser) {
        self.numParser = [TDNum num];
        [numParser setAssembler:self selector:@selector(workOnNumAssembly:)];
    }
    return numParser;
}


- (TDParser *)stringParser {
    if (!stringParser) {
        self.stringParser = [TDQuotedString quotedString];
        // TODO add TDWord
        [stringParser setAssembler:self selector:@selector(workOnStringAssembly:)];
    }
    return numParser;
}



- (void)workOnNumAssembly:(TDAssembly *)a {
    TDToken *tok = [a pop];
    [a push:[NSNumber numberWithFloat:tok.floatValue]];
}


- (void)workOnStringAssembly:(TDAssembly *)a {
    TDToken *tok = [a pop];
    [a push:tok.stringValue];
}


- (void)workOnNullAssembly:(TDAssembly *)a {
    [a pop]; // discard
    [a push:[NSNull null]];
}


@synthesize dictParser;
@synthesize keyValuePairParser;
@synthesize arrayParser;
@synthesize commaValueParser;
@synthesize keyParser;
@synthesize valueParser;
@synthesize nullParser;
@synthesize numParser;
@synthesize stringParser;
@end
