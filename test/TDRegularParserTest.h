//
//  PKRegularParserTest.h
//  ParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"
#import "TDRegularParser.h"

@interface TDRegularParserTest : SenTestCase {
    NSString *s;
    TDCharacterAssembly *a;
    TDRegularParser *p;
    PKAssembly *res;
}

@end
