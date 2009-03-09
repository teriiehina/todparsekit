//
//  TDJsonParser.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/18/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDParseKit.h>

@interface TDJsonParser : TDAlternation {
    BOOL shouldAssemble;
    TDParser *stringParser;
    TDParser *numberParser;
    TDParser *nullParser;
    TDCollectionParser *booleanParser;
    TDCollectionParser *arrayParser;
    TDCollectionParser *objectParser;
    TDCollectionParser *valueParser;
    TDCollectionParser *commaValueParser;
    TDCollectionParser *propertyParser;
    TDCollectionParser *commaPropertyParser;
    
    TDToken *curly;
    TDToken *bracket;
}

- (id)initWithIntentToAssemble:(BOOL)shouldAssemble;

- (id)parse:(NSString *)s;

@property (nonatomic, retain, readonly) TDTokenizer *tokenizer;
@property (nonatomic, retain) TDParser *stringParser;
@property (nonatomic, retain) TDParser *numberParser;
@property (nonatomic, retain) TDParser *nullParser;
@property (nonatomic, retain) TDCollectionParser *booleanParser;
@property (nonatomic, retain) TDCollectionParser *arrayParser;
@property (nonatomic, retain) TDCollectionParser *objectParser;
@property (nonatomic, retain) TDCollectionParser *valueParser;
@property (nonatomic, retain) TDCollectionParser *commaValueParser;
@property (nonatomic, retain) TDCollectionParser *propertyParser;
@property (nonatomic, retain) TDCollectionParser *commaPropertyParser;
@end