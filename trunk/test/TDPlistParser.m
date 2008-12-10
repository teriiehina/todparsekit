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
//    dictKey =     {
//        bar = foo;
//    };
//    47 = 0;
//    IntegerKey = 1;
//    47.7 = 0;
//    <null> = <null>;
//    ArrayKey =     (
//                    "one one",
//                    two,
//                    three
//                    );
//    "Null Key" = <null>;
//    emptyDictKey =     {
//    };
//    StringKey = String;
//    "1.0" = 1;
//    YESKey = 1;
//    "NO Key" = 0;
//}


// dict                 = '{' dictContent '}'
// dictContent          = Empty | keyValuePair*
// keyValuePair         = key '=' value ';'
// key                  = num | string | null
// value                = num | string | null | array | dict
// null                 = '<null>'
// string               = Word | QuotedString
// num                  = Num

// array                = '(' arrayContent ')'
// arrayContent         = Empty | actualArray
// actualArray          = value commaValue*
// commaValue           = ',' value

static NSString *kTDPlistNullString = @"<null>";

@interface TDPlistParser ()
@property (nonatomic, retain) TDToken *curly;
@property (nonatomic, retain) TDToken *paren;
@end

@implementation TDPlistParser

- (id)init {
    self = [super init];
    if (self != nil) {
        self.curly = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:@"{" floatValue:0.];
        self.paren = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:@"(" floatValue:0.];
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
    self.stringParser = nil;
    self.numParser = nil;
    self.nullParser = nil;
    self.curly = nil;
    self.paren = nil;
    [super dealloc];
}


- (id)parse:(NSString *)s {
    TDTokenAssembly *a = [TDTokenAssembly assemblyWithString:s];
    
    // add '<null>' as a multichar symbol
    TDTokenizer *t = a.tokenizer;
    [t.symbolState add:kTDPlistNullString];
    
    // parse
    TDAssembly *res = [self completeMatchFor:a];

    // pop the built result off the assembly's stack and return.
    // this will be an array or a dictionary
    return [res pop];
}


// dict                 = '{' dictContent '}'
// dictContent          = Empty | keyValuePair*
- (TDCollectionParser *)dictParser {
    if (!dictParser) {
        self.dictParser = [TDSequence sequence];
        [dictParser add:[TDSymbol symbolWithString:@"{"]]; // dont discard. serves as fence
        
        TDAlternation *a = [TDAlternation alternation];
        [a add:[TDEmpty empty]];
        [a add:[TDRepetition repetitionWithSubparser:self.keyValuePairParser]];
        
        [dictParser add:a];
        [dictParser add:[[TDSymbol symbolWithString:@"}"] discard]];
        
        [dictParser setAssembler:self selector:@selector(workOnDictAssembly:)];
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
        [arrayParser add:[TDSymbol symbolWithString:@"("]]; // dont discard. serves as fence
        
        TDAlternation *arrayContent = [TDAlternation alternation];
        [arrayContent add:[TDEmpty empty]];
        
        TDSequence *actualArray = [TDSequence sequence];
        [actualArray add:self.valueParser];
        [actualArray add:[TDRepetition repetitionWithSubparser:self.commaValueParser]];
        
        [arrayContent add:actualArray];
        [arrayParser add:[[TDSymbol symbolWithString:@")"] discard]];

        [arrayParser setAssembler:self selector:@selector(workOnArrayAssembly:)];
    }
    return arrayParser;
}


// key                  = Num | string | null
- (TDCollectionParser *)keyParser {
    if (!keyParser) {
        self.keyParser = [TDAlternation alternation];
        [keyParser add:self.numParser];
        [keyParser add:self.stringParser];
        [keyParser add:self.nullParser];
    }
    return keyParser;
}


// value                = Num | string | null | array | dict
- (TDCollectionParser *)valueParser {
    if (!valueParser) {
        self.valueParser = [TDAlternation alternation];
        [valueParser add:self.arrayParser];
        [valueParser add:self.dictParser];
        [valueParser add:self.stringParser];
        [valueParser add:self.numParser];
        [valueParser add:self.nullParser];
    }
    return valueParser;
}


- (TDCollectionParser *)stringParser {
    if (!stringParser) {
        self.stringParser = [TDAlternation alternation];
        [stringParser add:[TDQuotedString quotedString]];
        [stringParser add:[TDWord word]];

        [stringParser setAssembler:self selector:@selector(workOnStringAssembly:)];
    }
    return stringParser;
}


- (TDParser *)numParser {
    if (!numParser) {
        self.numParser = [TDNum num];

        [numParser setAssembler:self selector:@selector(workOnNumAssembly:)];
    }
    return numParser;
}


- (TDParser *)nullParser {
    if (!nullParser) {
        self.nullParser = [TDLiteral literalWithString:kTDPlistNullString];

        [nullParser setAssembler:self selector:@selector(workOnNullAssembly:)];
    }
    return nullParser;
}


- (void)workOnDictAssembly:(TDAssembly *)a {
    NSArray *objs = [a objectsAbove:self.curly];
    NSMutableDictionary *res = [NSMutableDictionary dictionaryWithCapacity:objs.count / 2.];
    
    NSInteger i = 0;
    for ( ; i < objs.count - 1; i++) {
        id key = [objs objectAtIndex:i++];
        id value = [objs objectAtIndex:i];
        [res setObject:value forKey:key];
    }
    
    [a pop]; // discard '{' tok
    [a push:[[res copy] autorelease]];
}


- (void)workOnArrayAssembly:(TDAssembly *)a {
    NSArray *objs = [a objectsAbove:self.paren];
    NSMutableArray *res = [NSMutableArray arrayWithCapacity:objs.count];
    
    id obj = nil;
    NSEnumerator *e = [objs reverseObjectEnumerator];
    while (obj = [e nextObject]) {
        [res addObject:obj];
    }
    
    [a pop]; // discard '[' tok
    [a push:[[res copy] autorelease]];
}


- (void)workOnStringAssembly:(TDAssembly *)a {
    TDToken *tok = [a pop];
    [a push:tok.stringValue];
}


- (void)workOnNumAssembly:(TDAssembly *)a {
    TDToken *tok = [a pop];
    [a push:[NSNumber numberWithFloat:tok.floatValue]];
}


- (void)workOnNullAssembly:(TDAssembly *)a {
    [a pop]; // discard '<null>' tok
    [a push:[NSNull null]];
}

@synthesize dictParser;
@synthesize keyValuePairParser;
@synthesize arrayParser;
@synthesize commaValueParser;
@synthesize keyParser;
@synthesize valueParser;
@synthesize stringParser;
@synthesize numParser;
@synthesize nullParser;
@synthesize curly;
@synthesize paren;
@end