//
//  TDOldGrammarParserFactoryTest.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/12/08.
//  Copyright 2008 Todd Ditchendorf All rights reserved.
//

#import "TDTestScaffold.h"
#import "TDOldGrammarParserFactory.h"

@interface TDOldGrammarParserFactoryTest : SenTestCase {
    NSString *s;
    TDTokenizer *t;
    TDTokenAssembly *a;
    TDSequence *exprSeq;
    TDParser *lp; // language parser
    TDOldGrammarParserFactory *factory;
    TDAssembly *res;
}

@end
