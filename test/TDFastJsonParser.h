//
//  TDFastJsonParser.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDTokenizer;
@class TDToken;

@interface TDFastJsonParser : NSObject {
    TDTokenizer *tokenizer;
    NSMutableArray *stack;
    TDToken *curly;
    TDToken *bracket;
}
- (id)parse:(NSString *)s;
@end
