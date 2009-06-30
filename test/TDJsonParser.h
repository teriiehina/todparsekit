//
//  TDJsonParser.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/18/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/ParseKit.h>

@interface TDJsonParser : TDAlternation {
    BOOL shouldAssemble;
    PKParser *stringParser;
    PKParser *numberParser;
    PKParser *nullParser;
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
@property (nonatomic, retain) PKParser *stringParser;
@property (nonatomic, retain) PKParser *numberParser;
@property (nonatomic, retain) PKParser *nullParser;
@property (nonatomic, retain) TDCollectionParser *booleanParser;
@property (nonatomic, retain) TDCollectionParser *arrayParser;
@property (nonatomic, retain) TDCollectionParser *objectParser;
@property (nonatomic, retain) TDCollectionParser *valueParser;
@property (nonatomic, retain) TDCollectionParser *commaValueParser;
@property (nonatomic, retain) TDCollectionParser *propertyParser;
@property (nonatomic, retain) TDCollectionParser *commaPropertyParser;
@end