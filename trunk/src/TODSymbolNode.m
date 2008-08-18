//
//  TODSymbolNode.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import "TODSymbolNode.h"

@interface TODSymbolNode ()
@property (nonatomic, readwrite, retain) NSString *ancestry;
@property (nonatomic, readwrite, assign) TODSymbolNode *parent;  // this must be 'assign' to avoid retain loop leak
@property (nonatomic, readwrite, retain) NSMutableDictionary *children;
@property (nonatomic, readwrite) NSInteger character;

- (void)determineAncestry;
@end

@implementation TODSymbolNode

- (id)initWithParent:(TODSymbolNode *)p character:(NSInteger)c {
	self = [super init];
	if (self != nil) {
		self.parent = p;
		self.character = c;
		self.children = [NSMutableDictionary dictionary];
		[self determineAncestry];
	}
	return self;
}


- (void)dealloc {
	self.parent = nil;
	self.ancestry = nil;
	self.children = nil;
	[super dealloc];
}


- (void)determineAncestry {
	TODSymbolNode *n = self;
	NSMutableString *result = [NSMutableString string];
	
	while (-1 != n.character) {
		[result insertString:[NSString stringWithFormat:@"%C", n.character] atIndex:0];
		n = n.parent;
	}

	self.ancestry = result;	
}


- (NSString *)description {
	return [NSString stringWithFormat:@"<TODSymbolNode %@>", self.ancestry];
}

@synthesize ancestry;
@synthesize parent;
@synthesize character;
@synthesize children;
@end
