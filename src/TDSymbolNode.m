//
//  TDSymbolNode.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDSymbolNode.h>

@interface TDSymbolNode ()
@property (nonatomic, readwrite, retain) NSString *ancestry;
@property (nonatomic, readwrite, assign) TDSymbolNode *parent;  // this must be 'assign' to avoid retain loop leak
@property (nonatomic, readwrite, retain) NSMutableDictionary *children;
@property (nonatomic, readwrite) NSInteger character;

- (void)determineAncestry;
@end

@implementation TDSymbolNode

- (id)initWithParent:(TDSymbolNode *)p character:(NSInteger)c {
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
	TDSymbolNode *n = self;
	NSMutableString *result = [NSMutableString string];
	
	while (-1 != n.character) {
		[result insertString:[NSString stringWithFormat:@"%C", n.character] atIndex:0];
		n = n.parent;
	}

	self.ancestry = result;	
}


- (NSString *)description {
	return [NSString stringWithFormat:@"<TDSymbolNode %@>", self.ancestry];
}

@synthesize ancestry;
@synthesize parent;
@synthesize character;
@synthesize children;
@end
