//
//  TODTokenizerTest.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/11/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@class TODTokenizer;

@interface TODTokenizerTest : SenTestCase {
	TODTokenizer *tokenizer;
	NSString *string;
}
@property (retain) TODTokenizer *tokenizer;
@property (copy) NSString *string;
@end
