//
//  TDGrammarParserFactoryTest.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/12/08.
//  Copyright 2008 Todd Ditchendorf All rights reserved.
//

#import "TDTestScaffold.h"
#import "TDGrammarParserFactory.h"

@interface TDGrammarParserFactoryTest : SenTestCase {
    NSString *s;
    TDTokenizer *t;
    TDTokenAssembly *a;
    TDParser *lp; // language parser
    TDGrammarParserFactory *factory;
    TDAssembly *res;

    TDSequence *exprSeq;
    TDParser *p;
}

@end
