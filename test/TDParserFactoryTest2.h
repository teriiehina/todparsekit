//
//  TDParserFactoryTest2.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/31/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"
#import "TDParserFactory.h"

@interface TDParserFactoryTest2 : SenTestCase {
    NSString *g;
    NSString *s;
    TDTokenAssembly *a;
    TDParserFactory *factory;
    PKAssembly *res;
    PKParser *lp; // language parser
    TDTokenizer *t;
    TDToken *tok;
}

@end
