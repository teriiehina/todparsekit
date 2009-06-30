//
//  XPathParserGrammarTest.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/28/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"

@interface XPathParserGrammarTest : SenTestCase {
    NSString *s;
    TDParser *p;
    TDTokenizer *t;
    TDAssembly *a;
    TDAssembly *res;
    TDToken *tok;
}

@end
