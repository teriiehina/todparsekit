//
//  TDSlashStarState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDSlashStarState.h>
#import <TDParseKit/TDReader.h>
#import <TDParseKit/TDTokenizer.h>
#import <TDParseKit/TDToken.h>

@implementation TDSlashStarState

- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    NSInteger c;
    do {
        c = [r read];
        
        if ('*' == c) {
            NSInteger peek = [r read];
            if ('/' == peek) {
                c = [r read];
                break;
            } else {
                if (-1 != peek) {
                    [r unread];
                }
            }
        }
    } while (-1 != c);

    if (-1 != c) {
        [r unread];
    }
    
    return [t nextToken];
}

@end
