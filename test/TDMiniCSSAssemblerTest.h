//
//  PKMiniCSSAssemblerTest.h
//  ParseKit
//
//  Created by Todd Ditchendorf on 12/25/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"
#import "TDParserFactory.h"
#import "TDMiniCSSAssembler.h"

@interface TDMiniCSSAssemblerTest : SenTestCase {
    NSString *path;
    NSString *grammarString;
    NSString *s;
    TDMiniCSSAssembler *ass;
    TDParserFactory *factory;
    PKParser *lp;
    PKAssembly *a;
}

@end
