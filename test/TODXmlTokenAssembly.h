//
//  TODXmlTokenAssembly.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <TODParseKit/TODAssembly.h>

@class TODXmlTokenizer;

@interface TODXmlTokenAssembly : TODAssembly <NSCopying> {
	TODXmlTokenizer *tokenizer;
	NSMutableArray *tokens;
}
@property (nonatomic, retain) TODXmlTokenizer *tokenizer;
@end
