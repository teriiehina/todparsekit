//
//  TDParserFactoryTest.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/12/08.
//  Copyright 2008 Todd Ditchendorf All rights reserved.
//

#import "TDTestScaffold.h"
#import "TDParserFactory.h"

@interface TDParserFactoryTest : SenTestCase {
    NSString *s;
    PKTokenAssembly *a;
    TDParserFactory *factory;
    PKAssembly *res;

    PKSequence *exprSeq;
    PKTokenizer *t;
    PKParser *lp; // language parser
}

@end
