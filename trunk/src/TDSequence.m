//
//  TDSequence.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDSequence.h>
#import <TDParseKit/TDAssembly.h>

@interface TDParser ()
- (NSSet *)matchAndAssemble:(NSSet *)inAssemblies;
@end

@implementation TDSequence

+ (id)sequence {
	return [[[self alloc] init] autorelease];
}


- (NSSet *)allMatchesFor:(NSSet *)inAssemblies {
	NSSet *outAssemblies = inAssemblies;
	
	for (TDParser *p in subparsers) {
		outAssemblies = [p matchAndAssemble:outAssemblies];
		if (!outAssemblies.count) {
			break;
		}
	}
	
	return outAssemblies;
}

@end
