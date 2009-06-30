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
    PKParser *p;
    TDTokenizer *t;
    PKAssembly *a;
    PKAssembly *res;
    TDToken *tok;
}

@end
