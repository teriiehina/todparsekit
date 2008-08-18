//
//  TODFastJsonParser.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TODTokenizer;
@class TODToken;

@interface TODFastJsonParser : NSObject {
	TODTokenizer *tokenizer;
	NSMutableArray *stack;
	TODToken *curly;
	TODToken *bracket;
}
- (id)parse:(NSString *)s;
@end
