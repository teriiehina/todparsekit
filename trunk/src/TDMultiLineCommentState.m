//
//  TDMultiLineCommentState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/28/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDMultiLineCommentState.h"

@interface TDMultiLineCommentState ()
@end

@implementation TDMultiLineCommentState

- (id)init {
    self = [super init];
    if (self) {
        self.startSymbols = [NSMutableArray array];
        self.endSymbols = [NSMutableArray array];
    }
    return self;
}


- (void)dealloc {
    self.startSymbols = nil;
    self.endSymbols = nil;
    [super dealloc];
}


- (void)addStartSymbol:(NSString *)start endSymbol:(NSString *)end {
    NSParameterAssert(start.length);
    NSParameterAssert(end.length);
    
    [startSymbols addObject:start];
    [endSymbols addObject:end];
}

@synthesize startSymbols;
@synthesize endSymbols;
@end
