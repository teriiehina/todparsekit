//
//  TDSymbolState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDSymbolState.h>
#import <TDParseKit/TDToken.h>
#import <TDParseKit/TDSymbolNode.h>
#import <TDParseKit/TDSymbolRootNode.h>
#import <TDParseKit/TDReader.h>
#import <TDParseKit/TDTokenizer.h>

@interface TDSymbolState ()
@property (nonatomic, retain) TDSymbolRootNode *rootNode;
@property (nonatomic, retain) NSMutableArray *addedSymbols;
@end

@implementation TDSymbolState

- (id)init {
    self = [super init];
    if (self != nil) {
        self.rootNode = [[[TDSymbolRootNode alloc] initWithParent:nil character:-1] autorelease];
        self.addedSymbols = [NSMutableArray array];
    }
    return self;
}


- (void)dealloc {
    self.rootNode = nil;
    self.addedSymbols = nil;
    [super dealloc];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    NSString *symbol = [self.rootNode nextSymbol:r startingWith:cin];
    NSInteger len = symbol.length;

    if (0 == len || (len > 1 && [addedSymbols containsObject:symbol])) {
        return [TDToken tokenWithTokenType:TDTT_SYMBOL stringValue:symbol floatValue:0.0f];
    } else {
        NSInteger i = 0;
        for ( ; i < len - 1; i++) {
            [r unread];
        }
        return [TDToken tokenWithTokenType:TDTT_SYMBOL stringValue:[NSString stringWithFormat:@"%C", cin] floatValue:0.0f];
    }
}


- (void)add:(NSString *)s {
    [self.rootNode add:s];
    [addedSymbols addObject:s];
}

@synthesize rootNode;
@synthesize addedSymbols;
@end
