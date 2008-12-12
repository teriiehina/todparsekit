//
//  TDTokenStringSource.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/11/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDTokenizer;
@class TDToken;

@interface TDTokenStringSource : NSObject {
    TDTokenizer *tokenizer;
    NSString *delimiter;
    TDToken *nextToken;
}

- (id)initWithTokenizer:(TDTokenizer *)t delimiter:(NSString *)s;
- (BOOL)hasMore;
- (NSArray *)nextTokenString;
@end
