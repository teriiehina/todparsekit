//
//  TDTokenizerTest.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/11/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@class TDTokenizer;

@interface TDTokenizerTest : SenTestCase {
    TDTokenizer *tokenizer;
    NSString *string;
}
@property (retain) TDTokenizer *tokenizer;
@property (copy) NSString *string;
@end
