//
//  TDXMLParserTest.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"
#import "TDParserFactory.h"

@interface TDXMLParserTest : SenTestCase {
    NSString *s;
    NSString *g;
    TDParserFactory *factory;
    TDTokenAssembly *a;
    PKAssembly *res;
    TDParser *p;
    TDTokenizer *t;
}

@end
