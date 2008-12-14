//
//  TDGrammarParserTest.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/12/08.
//  Copyright 2008 Todd Ditchendorf All rights reserved.
//

#import "TDTestScaffold.h"
#import "TDGrammarParser.h"

@interface TDGrammarParserTest : SenTestCase {
    NSString *s;
    TDTokenizer *t;
    TDTokenAssembly *a;
    TDSequence *exprSeq;
    TDParser *lp; // language parser
    TDGrammarParser *gp;
    TDAssembly *res;
}

@end
