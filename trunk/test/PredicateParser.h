//
//  PredicateParser.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/27/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDParseKit.h>

@interface PredicateParser : TDSequence {
    TDCollectionParser *expressionParser;
    TDCollectionParser *termParser;
    TDCollectionParser *orTermParser;
    TDCollectionParser *andPhraseParser;
    TDCollectionParser *phraseParser;
    TDCollectionParser *atomicValueParser;
}

@property (nonatomic, retain) TDCollectionParser *expressionParser;
@property (nonatomic, retain) TDCollectionParser *termParser;
@property (nonatomic, retain) TDCollectionParser *orTermParser;
@property (nonatomic, retain) TDCollectionParser *andPhraseParser;
@property (nonatomic, retain) TDCollectionParser *phraseParser;
@property (nonatomic, retain) TDCollectionParser *atomicValueParser;
@end
