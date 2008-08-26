//
//  TDArithmeticParser.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <TDParseKit/TDParseKit.h>

@interface TDArithmeticParser : TDSequence {
	TDCollectionParser *exprParser;
	TDCollectionParser *termParser;
	TDCollectionParser *plusTermParser;
	TDCollectionParser *minusTermParser;
	TDCollectionParser *factorParser;
	TDCollectionParser *timesFactorParser;
	TDCollectionParser *divFactorParser;
	TDCollectionParser *exponentFactorParser;
	TDCollectionParser *phraseParser;
}
- (CGFloat)parse:(NSString *)s;

@property (retain) TDCollectionParser *exprParser;
@property (retain) TDCollectionParser *termParser;
@property (retain) TDCollectionParser *plusTermParser;
@property (retain) TDCollectionParser *minusTermParser;
@property (retain) TDCollectionParser *factorParser;
@property (retain) TDCollectionParser *timesFactorParser;
@property (retain) TDCollectionParser *divFactorParser;
@property (retain) TDCollectionParser *exponentFactorParser;
@property (retain) TDCollectionParser *phraseParser;
@end
