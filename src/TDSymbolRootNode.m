//
//  TDSymbolRootNode.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDSymbolRootNode.h>
#import <TDParseKit/TDReader.h>

@interface TDSymbolRootNode ()
- (void)addWithFirst:(NSInteger)c rest:(NSString *)s parent:(TDSymbolNode *)p;
- (NSString *)nextWithFirst:(NSInteger)cin rest:(TDReader *)r parent:(TDSymbolNode *)p;
@end

@implementation TDSymbolRootNode

- (void)add:(NSString *)s {
	if (s.length < 2) return;
	
	[self addWithFirst:[s characterAtIndex:0] rest:[s substringFromIndex:1] parent:self];
}


- (void)addWithFirst:(NSInteger)c rest:(NSString *)s parent:(TDSymbolNode *)p {
	NSNumber *key = [NSNumber numberWithInteger:c];
	TDSymbolNode *child = [p.children objectForKey:key];
	if (!child) {
		child = [[[TDSymbolNode alloc] initWithParent:p character:c] autorelease];
		[p.children setObject:child forKey:key];
	}

	NSString *rest = nil;
	
	if (0 == s.length) {
		return;
	} else if (s.length > 1) {
		rest = [s substringFromIndex:1];
	}
	
	[self addWithFirst:[s characterAtIndex:0] rest:rest parent:child];
}


- (NSString *)nextSymbol:(TDReader *)r startingWith:(NSInteger)cin {
	NSString *result = [self nextWithFirst:cin rest:r parent:self];
	return result;
}


- (NSString *)nextWithFirst:(NSInteger)cin rest:(TDReader *)r parent:(TDSymbolNode *)p {
	unichar c = (unichar)cin;
	NSString *result = [NSString stringWithCharacters:&c length:1];
	NSNumber *key = [NSNumber numberWithUnsignedChar:cin];
	TDSymbolNode *child = [p.children objectForKey:key];
	
	if (!child) {
		if (p == self) {
			return result;
		} else {
			[r unread];
			return @"";
		}
	} 
	
	cin = [r read];
	if (-1 == cin) {
		return result;
	}
	
	return [result stringByAppendingString:[self nextWithFirst:cin rest:r parent:child]];
}

@end
