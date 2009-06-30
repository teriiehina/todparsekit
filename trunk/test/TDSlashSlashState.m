//
//  TDSlashSlashState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/TDSlashSlashState.h>
#import <ParseKit/TDSlashState.h>
#import <ParseKit/PKReader.h>
#import <ParseKit/TDTokenizer.h>
#import <ParseKit/TDToken.h>
#import <ParseKit/PKTypes.h>

@interface TDTokenizerState ()
- (void)resetWithReader:(PKReader *)r;
- (void)append:(PKUniChar)c;
- (NSString *)bufferedString;
@end

@implementation TDSlashSlashState

- (TDToken *)nextTokenFromReader:(PKReader *)r startingWith:(PKUniChar)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    NSParameterAssert(t);
    
    BOOL reportTokens = t.slashState.reportsCommentTokens;
    if (reportTokens) {
        [self resetWithReader:r];
        [self append:'/'];
    }
    
    NSInteger c = cin;

    while ('\n' != c && '\r' != c && -1 != c) {
        if (reportTokens) {
            [self append:c];
        }
        c = [r read];
    }
    if (-1 != c) {
        [r unread];
    }
    
    if (reportTokens) {
        return [TDToken tokenWithTokenType:TDTokenTypeComment stringValue:[self bufferedString] floatValue:0.0];
    } else {
        return [t nextToken];
    }
}

@end
