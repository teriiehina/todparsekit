//
//  TODTokenAssembly.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TODParseKit/TODAssembly.h>

@class TODTokenizer;

@interface TODTokenAssembly : TODAssembly <NSCopying> {
	TODTokenizer *tokenizer;
	NSMutableArray *tokens;
}
@property (nonatomic, retain) TODTokenizer *tokenizer;
@end
