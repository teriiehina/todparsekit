//
//  TDXmlTokenAssembly.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/21/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDAssembly.h>

@class TDXmlTokenizer;

@interface TDXmlTokenAssembly : TDAssembly <NSCopying> {
	TDXmlTokenizer *tokenizer;
	NSMutableArray *tokens;
}
@property (nonatomic, retain) TDXmlTokenizer *tokenizer;
@end
