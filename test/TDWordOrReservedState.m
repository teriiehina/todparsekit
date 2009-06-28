//
//  TDWordOrReservedState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDWordOrReservedState.h>

@interface TDWordOrReservedState ()
@property (nonatomic, retain) NSMutableSet *reservedWords;
@end

@implementation TDWordOrReservedState

- (id)init {
    if (self = [super init]) {
        self.reservedWords = [NSMutableSet set];
    }
    return self;
}


- (void)dealloc {
    self.reservedWords = nil;
    [super dealloc];
}


- (void)addReservedWord:(NSString *)s {
    [reservedWords addObject:s];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(TDUniChar)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    return nil;
}

@synthesize reservedWords;
@end