//
//  TDWhitespaceState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDWhitespaceState.h>
#import <TDParseKit/TDReader.h>
#import <TDParseKit/TDTokenizer.h>
#import <TDParseKit/TDToken.h>

static id TDYesFlag = nil;
static id TDNoFlag = nil;

@interface TDTokenizerState ()
- (void)reset;
@property (nonatomic, retain) NSMutableString *stringbuf;
@end

@interface TDWhitespaceState ()
@property (nonatomic, retain) NSMutableArray *whitespaceChars;
@end

@implementation TDWhitespaceState

+ (void)initialize {
    TDYesFlag = (id)kCFBooleanTrue;
    TDNoFlag = (id)kCFBooleanFalse;
}


- (id)init {
    self = [super init];
    if (self != nil) {
        self.whitespaceChars = [NSMutableArray array];
        NSInteger i = 0;
        for ( ; i < 256; i++) {
            [whitespaceChars addObject:TDNoFlag];
        }
        
        [self setWhitespaceChars:YES from:0 to:' '];
    }
    return self;
}


- (void)dealloc {
    self.whitespaceChars = nil;
    [super dealloc];
}


- (void)setWhitespaceChars:(BOOL)yn from:(NSInteger)start to:(NSInteger)end {
    id obj = yn ? TDYesFlag : TDNoFlag;
    NSInteger i = start;
    for ( ; i <= end; i++) {
        [whitespaceChars replaceObjectAtIndex:i withObject:obj];
    }
}


- (BOOL)isWhitespaceChar:(NSInteger)cin {
    if (-1 == cin || cin > whitespaceChars.count - 1) {
        return NO;
    }
    return TDYesFlag == [whitespaceChars objectAtIndex:cin];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    if (reportsWhitespaceTokens) {
        [self reset];
    }
    
    NSInteger c = cin;
    while ([self isWhitespaceChar:c]) {
        if (reportsWhitespaceTokens) {
            [stringbuf appendFormat:@"%C", c];
        }
        c = [r read];
    }
    if (c != -1) {
        [r unread];
    }
    
    if (reportsWhitespaceTokens) {
        return [TDToken tokenWithTokenType:TDTokenTypeWhitespace stringValue:[[stringbuf copy] autorelease] floatValue:0.0f];
    } else {
        return [t nextToken];
    }
}

@synthesize whitespaceChars;
@synthesize reportsWhitespaceTokens;
@end

