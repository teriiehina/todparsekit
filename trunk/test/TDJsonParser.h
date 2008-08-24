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
@property (retain) TDParser *booleanParser;
@property (retain) TDParser *arrayParser;
@property (retain) TDParser *objectParser;
@property (retain) TDParser *valueParser;
@property (retain) TDParser *commaValueParser;
@property (retain) TDParser *propertyParser;
@property (retain) TDParser *commaPropertyParser;
@end