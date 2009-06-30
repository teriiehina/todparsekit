//
//  TDFastJsonParser.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PKTokenizer;
@class PKToken;

@interface TDFastJsonParser : NSObject {
    PKTokenizer *tokenizer;
    NSMutableArray *stack;
    PKToken *curly;
    PKToken *bracket;
}
- (id)parse:(NSString *)s;
@end
