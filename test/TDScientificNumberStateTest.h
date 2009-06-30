//
//  PKScientificNumberStateTest.h
//  ParseKit
//
//  Created by Todd Ditchendorf on 8/25/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"


@interface TDScientificNumberStateTest : SenTestCase {
    PKScientificNumberState *numberState;
    PKTokenizer *t;
    PKReader *r;
    NSString *s;
}

@end
