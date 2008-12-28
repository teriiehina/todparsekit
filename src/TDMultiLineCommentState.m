//
//  TDMultiLineCommentState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/28/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDMultiLineCommentState.h"

@interface TDMultiLineCommentState ()
@property (nonatomic, retain) NSMutableArray *startTokens;
@property (nonatomic, retain) NSMutableArray *endTokens;
@end

@implementation TDMultiLineCommentState

- (id)init {
    self = [super init];
    if (self) {
        self.startTokens = [NSMutableArray array];
        self.endTokens = [NSMutableArray array];
    }
    return self;
}


- (void)dealloc {
    self.startTokens = nil;
    self.endTokens = nil;
    [super dealloc];
}


- (void)addStartToken:(TDToken *)startTok endToken:(TDToken *)endTok {
    NSParameterAssert(startTok);
    NSParameterAssert(endTok);
    
    [startTokens addObject:startTok];
    [endTokens addObject:endTok];
}

@synthesize startTokens;
@synthesize endTokens;
@end
