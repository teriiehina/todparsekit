//
//  TDSimpleCSSAssemblerTest.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/25/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"
#import "TDGrammarParserFactory.h"
#import "TDSimpleCSSAssembler.h"

@interface TDSimpleCSSAssemblerTest : SenTestCase {
    NSString *path;
    NSString *grammarString;
    NSString *s;
    TDSimpleCSSAssembler *ass;
    TDGrammarParserFactory *factory;
    TDParser *lp;
    TDAssembly *a;
}

@end
