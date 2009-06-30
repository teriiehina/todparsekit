//
//  TDPlistParser.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/9/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/ParseKit.h>

@interface TDPlistParser : TDAlternation {
    TDCollectionParser *dictParser;
    TDCollectionParser *keyValuePairParser;
    TDCollectionParser *arrayParser;
    TDCollectionParser *commaValueParser;
    TDCollectionParser *keyParser;
    TDCollectionParser *valueParser;
    TDCollectionParser *stringParser;
    PKParser *numParser;
    PKParser *nullParser;
    TDToken *curly;
    TDToken *paren;
}
- (id)parse:(NSString *)s;

@property (nonatomic, readonly, retain) TDTokenizer *tokenizer;
@property (nonatomic, retain) TDCollectionParser *dictParser;
@property (nonatomic, retain) TDCollectionParser *keyValuePairParser;
@property (nonatomic, retain) TDCollectionParser *arrayParser;
@property (nonatomic, retain) TDCollectionParser *commaValueParser;
@property (nonatomic, retain) TDCollectionParser *keyParser;
@property (nonatomic, retain) TDCollectionParser *valueParser;
@property (nonatomic, retain) TDCollectionParser *stringParser;
@property (nonatomic, retain) PKParser *numParser;
@property (nonatomic, retain) PKParser *nullParser;
@end
