//
//  TDSingleLineCommentState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/28/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDSingleLineCommentState.h"

@interface TDSingleLineCommentState ()
@property (nonatomic, retain) NSMutableArray *startTokens;
@end

@implementation TDSingleLineCommentState

- (id)init {
    self = [super init];
    if (self) {
        self.startTokens = [NSMutableArray array];
    }
    return self;
}


- (void)dealloc {
    self.startTokens = nil;
    [super dealloc];
}


- (void)addStartToken:(TDToken *)startTok {
    NSParameterAssert(startTok);
    
    [startTokens addObject:startTok];
}

@synthesize startTokens;
@end
