//
//  PKSymbolState.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/PKSymbolState.h>
#import <ParseKit/PKToken.h>
#import <ParseKit/PKSymbolRootNode.h>
#import <ParseKit/PKReader.h>
#import <ParseKit/PKTokenizer.h>

@interface PKToken ()
@property (nonatomic, readwrite) NSUInteger offset;
@end

@interface PKTokenizerState ()
- (void)resetWithReader:(PKReader *)r;
@end

@interface PKSymbolState ()
@property (nonatomic, retain) PKSymbolRootNode *rootNode;
@property (nonatomic, retain) NSMutableArray *addedSymbols;
@end

@implementation PKSymbolState

- (id)init {
    if (self = [super init]) {
        self.rootNode = [[[PKSymbolRootNode alloc] init] autorelease];
        self.addedSymbols = [NSMutableArray array];
    }
    return self;
}


- (void)dealloc {
    self.rootNode = nil;
    self.addedSymbols = nil;
    [super dealloc];
}


- (PKToken *)nextTokenFromReader:(PKReader *)r startingWith:(PKUniChar)cin tokenizer:(PKTokenizer *)t {
    NSParameterAssert(r);
    [self resetWithReader:r];
    
    NSString *symbol = [rootNode nextSymbol:r startingWith:cin];
    NSUInteger len = symbol.length;

    if (0 == len || (len > 1 && [addedSymbols containsObject:symbol])) {
        PKToken *tok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:symbol floatValue:0.0];
        tok.offset = offset;
        return tok;
    } else {
        [r unread:len - 1];
        PKToken *tok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:[NSString stringWithFormat:@"%C", cin] floatValue:0.0];
        tok.offset = offset;
        return tok;
    }
}


- (void)add:(NSString *)s {
    NSParameterAssert(s);
    [rootNode add:s];
    [addedSymbols addObject:s];
}


- (void)remove:(NSString *)s {
    NSParameterAssert(s);
    [rootNode remove:s];
    [addedSymbols removeObject:s];
}

@synthesize rootNode;
@synthesize addedSymbols;
@end
