//
//  TODAlternation.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODAlternation.h"
#import "TODAssembly.h"

@interface TODParser ()
- (NSSet *)matchAndAssemble:(NSSet *)inAssemblies;
@end

@implementation TODAlternation

+ (id)alternation {
	return [[[[self class] alloc] init] autorelease];
}


- (NSSet *)allMatchesFor:(NSSet *)inAssemblies {
	NSMutableSet *outAssemblies = [NSMutableSet set];
	
	for (TODParser *p in subparsers) {
		[outAssemblies unionSet:[p matchAndAssemble:inAssemblies]];
	}
	
	return outAssemblies;
}

@end
