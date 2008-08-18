//
//  TODRegularParser.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TODParseKit/TODParseKit.h>

@interface TODRegularParser : TODSequence {
	TODCollectionParser *expressionParser;
	TODCollectionParser *termParser;
	TODCollectionParser *orTermParser;
	TODCollectionParser *factorParser;
	TODCollectionParser *nextFactorParser;
	TODCollectionParser *phraseParser;
	TODCollectionParser *phraseStarParser;
	TODCollectionParser *letterOrDigitParser;
}
- (id)parse:(NSString *)s;

@property (retain) TODCollectionParser *expressionParser;
@property (retain) TODCollectionParser *termParser;
@property (retain) TODCollectionParser *orTermParser;
@property (retain) TODCollectionParser *factorParser;
@property (retain) TODCollectionParser *nextFactorParser;
@property (retain) TODCollectionParser *phraseParser;
@property (retain) TODCollectionParser *phraseStarParser;
@property (retain) TODCollectionParser *letterOrDigitParser;
@end
