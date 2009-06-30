//
//  PKGenericAssemblerTest.h
//  ParseKit
//
//  Created by Todd Ditchendorf on 12/25/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"
#import "TDParserFactory.h"
#import "TDMiniCSSAssembler.h"
#import "TDGenericAssembler.h"

@interface TDGenericAssemblerTest : SenTestCase {
    NSString *path;
    NSString *grammarString;
    NSString *s;
    TDMiniCSSAssembler *cssAssember;
    TDParserFactory *factory;
    PKParser *cssParser;
    PKAssembly *a;
    TDGenericAssembler *genericAssember;
}

@end
