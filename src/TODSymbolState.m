//
//  TODSymbolState.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import "TODSymbolState.h"
#import "TODToken.h"
#import "TODSymbolNode.h"
#import "TODSymbolRootNode.h"
#import "TODReader.h"

@interface TODSymbolState ()
@property (nonatomic, retain) TODSymbolRootNode *rootNode;
@end

@implementation TODSymbolState

- (id)init {
	self = [super init];
	if (self != nil) {
		self.rootNode = [[[TODSymbolRootNode alloc] initWithParent:nil character:-1] autorelease];
	}
	return self;
}


- (void)dealloc {
	self.rootNode = nil;
	[super dealloc];
}


- (TODToken *)nextTokenFromReader:(TODReader *)r startingWith:(NSInteger)cin tokenizer:(TODTokenizer *)t {

	NSString *symbol = [self.rootNode nextSymbol:r startingWith:cin];
	
	return [[[TODToken alloc] initWithTokenType:TODTT_SYMBOL 
												 stringValue:symbol
												 floatValue:0.0f] autorelease];
}


- (void)add:(NSString *)s {
	[self.rootNode add:s];
}

@synthesize rootNode;
@end
