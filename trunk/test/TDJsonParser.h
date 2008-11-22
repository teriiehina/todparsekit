//
//  TDJsonParser.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/18/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDParseKit.h"

@interface TDJsonParser : TDAlternation {
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

- (id)parse:(NSString *)s;

@property (retain) TDParser *stringParser;
@property (retain) TDParser *numberParser;
@property (retain) TDParser *nullParser;
@property (retain) TDCollectionParser *booleanParser;
@property (retain) TDCollectionParser *arrayParser;
@property (retain) TDCollectionParser *objectParser;
@property (retain) TDCollectionParser *valueParser;
@property (retain) TDCollectionParser *commaValueParser;
@property (retain) TDCollectionParser *propertyParser;
@property (retain) TDCollectionParser *commaPropertyParser;
@end