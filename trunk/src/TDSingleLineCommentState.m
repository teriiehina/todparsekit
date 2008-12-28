//
//  TDSingleLineCommentState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/28/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDSingleLineCommentState.h"

@interface TDSingleLineCommentState ()
@end

@implementation TDSingleLineCommentState

- (id)init {
    self = [super init];
    if (self) {
        self.startSymbols = [NSMutableArray array];
    }
    return self;
}


- (void)dealloc {
    self.startSymbols = nil;
    [super dealloc];
}


- (void)addStartSymbol:(NSString *)start {
    NSParameterAssert(start.length);
    
    [startSymbols addObject:start];
}

@synthesize startSymbols;
@end
