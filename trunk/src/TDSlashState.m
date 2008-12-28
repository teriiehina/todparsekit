//
//  TDSlashState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDSlashState.h>
#import <TDParseKit/TDReader.h>
#import <TDParseKit/TDTokenizer.h>
#import <TDParseKit/TDToken.h>
#import <TDParseKit/TDSlashSlashState.h>
#import <TDParseKit/TDSlashStarState.h>

@interface TDSlashState ()
@property (nonatomic, retain) TDSlashSlashState *slashSlashState;
@property (nonatomic, retain) TDSlashStarState *slashStarState;
@end

@implementation TDSlashState

- (id)init {
    self = [super init];
    if (self) {
        self.slashSlashState = [[[TDSlashSlashState alloc] init] autorelease];
        self.slashStarState  = [[[TDSlashStarState alloc] init] autorelease];
    }
    return self;
}


- (void)dealloc {
    self.slashSlashState = nil;
    self.slashStarState = nil;
    [super dealloc];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    NSParameterAssert(t);
    
    NSInteger c = [r read];
    if ('/' == c) {
        return [slashSlashState nextTokenFromReader:r startingWith:c tokenizer:t];
    } else if ('*' == c) {
        return [slashStarState nextTokenFromReader:r startingWith:c tokenizer:t];
    } else {
        if (-1 != c) {
            [r unread];
        }
        return [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:@"/" floatValue:0.0];
    }
}

@synthesize slashSlashState;
@synthesize slashStarState;
@synthesize reportsCommentTokens;
@end
