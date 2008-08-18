//
//  TODSequence.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODSequence.h"
#import "TODAssembly.h"

@interface TODParser ()
- (NSSet *)matchAndAssemble:(NSSet *)inAssemblies;
@end

@implementation TODSequence

+ (id)sequence {
	return [[[[self class] alloc] init] autorelease];
}


- (NSSet *)allMatchesFor:(NSSet *)inAssemblies {
	NSSet *outAssemblies = inAssemblies;
	
	for (TODParser *p in subparsers) {
		outAssemblies = [p matchAndAssemble:outAssemblies];
		if (!outAssemblies.count) {
			break;
		}
	}
	
	return outAssemblies;
}

@end
