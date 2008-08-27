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

@interface TDSymbolState ()
@property (nonatomic, retain) TDSymbolRootNode *rootNode;
@end

@implementation TDSymbolState

- (id)init {
	self = [super init];
	if (self != nil) {
		self.rootNode = [[[TDSymbolRootNode alloc] initWithParent:nil character:-1] autorelease];
	}
	return self;
}


- (void)dealloc {
	self.rootNode = nil;
	[super dealloc];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
	NSString *symbol = [self.rootNode nextSymbol:r startingWith:cin];
	
	return [TDToken tokenWithTokenType:TDTT_SYMBOL stringValue:symbol floatValue:0.0f];
}


- (void)add:(NSString *)s {
	[self.rootNode add:s];
}

@synthesize rootNode;
@end
