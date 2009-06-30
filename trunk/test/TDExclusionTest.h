//
//  TDMinusTest.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/26/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"

@interface TDExclusionTest : SenTestCase {
    PKTokenizer *t;
    PKParser *p;
    PKParser *minus;
    PKAssembly *a;
    PKAssembly *res;
    NSString *s;    
}

@end
