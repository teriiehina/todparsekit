//
//  TDGenericAssemblerTest.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/25/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"
#import "TDGrammarParserFactory.h"
#import "TDMiniCSSAssembler.h"
#import "TDGenericAssembler.h"

@interface TDGenericAssemblerTest : SenTestCase {
    NSString *path;
    NSString *grammarString;
    NSString *s;
    TDMiniCSSAssembler *cssAssember;
    TDGrammarParserFactory *factory;
    TDParser *cssParser;
    TDAssembly *a;
    TDGenericAssembler *genericAssember;
}

@end
