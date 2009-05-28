//
//  Query.h
//  Documents
//
//  Created by Jesse Grosjean on 5/27/09.
//  Copyright 2009 Hog Bay Software. All rights reserved.
//

#import <TDParseKit/TDParseKit.h>


@interface QueryParser : TDSequence {
    TDCollectionParser *expressionParser;
    TDCollectionParser *andTermParser;
    TDCollectionParser *orTermParser;
    TDCollectionParser *notFactorParser;
    TDCollectionParser *factorParser;
    TDCollectionParser *predicateParser;
}

- (NSPredicate *)parse:(NSString *)s;

@property (retain) TDCollectionParser *expressionParser;
@property (retain) TDCollectionParser *andTermParser;
@property (retain) TDCollectionParser *orTermParser;
@property (retain) TDCollectionParser *notFactorParser;
@property (retain) TDCollectionParser *factorParser;
@property (retain) TDCollectionParser *predicateParser;

@end
