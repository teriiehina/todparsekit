//
//  TDParseTreeTest.h
//  ParseKit
//
//  Created by Todd Ditchendorf on 8/1/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"

@interface TDParseTreeTest : SenTestCase {
    PKParserFactory *factory;
    PKParseTreeAssembler *as;
    NSString *g;
    NSString *s;
    PKTokenAssembly *a;
    PKAssembly *res;
    PKParser *lp; // language parser
    PKTokenizer *t;
    PKToken *tok;
}

@end
