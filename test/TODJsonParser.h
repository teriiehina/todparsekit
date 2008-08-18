//
//  TODJsonParser.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/18/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODParseKit.h"

@interface TODJsonParser : TODAlternation {
	TODParser *stringParser;
	TODParser *numberParser;
	TODParser *nullParser;
	TODCollectionParser *booleanParser;
	TODCollectionParser *arrayParser;
	TODCollectionParser *objectParser;
	TODCollectionParser *valueParser;
	TODCollectionParser *commaValueParser;
	TODCollectionParser *propertyParser;
	TODCollectionParser *commaPropertyParser;
	
	TODToken *curly;
	TODToken *bracket;
}

- (id)parse:(NSString *)s;

@property (retain) TODParser *stringParser;
@property (retain) TODParser *numberParser;
@property (retain) TODParser *nullParser;
@property (retain) TODParser *booleanParser;
@property (retain) TODParser *arrayParser;
@property (retain) TODParser *objectParser;
@property (retain) TODParser *valueParser;
@property (retain) TODParser *commaValueParser;
@property (retain) TODParser *propertyParser;
@property (retain) TODParser *commaPropertyParser;
@end