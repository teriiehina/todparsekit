//
//  TDParserExpando.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDParseKit.h>

@class TDGrammarParserFactory;

@interface TDParserExpando : TDParser {
    NSMutableDictionary *table;
    TDGrammarParserFactory *factory;
}
- (TDParser *)parserForName:(NSString *)name;
- (void)setExpression:(NSString *)expr forParserName:(NSString *)name;
@end
