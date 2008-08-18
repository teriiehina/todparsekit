//
//  TODTrack.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODTrack.h"
#import "TODAssembly.h"

@interface TODParser ()
- (NSSet *)matchAndAssemble:(NSSet *)inAssemblies;
- (TODAssembly *)best:(NSSet *)inAssemblies;
@end

@interface TODTrack ()
- (void)throwTrackExceptionWithPreviousState:(NSSet *)inAssemblies parser:(TODParser *)p;
@end

@implementation TODTrack

+ (id)track {
	return [[[[self class] alloc] init] autorelease];
}


- (NSSet *)allMatchesFor:(NSSet *)inAssemblies {
	BOOL inTrack = NO;
	NSSet *lastAssemblies = inAssemblies;
	NSSet *outAssemblies = inAssemblies;
	
	for (TODParser *p in subparsers) {
		outAssemblies = [p matchAndAssemble:outAssemblies];
		if (!outAssemblies.count) {
			if (inTrack) {
				[self throwTrackExceptionWithPreviousState:lastAssemblies parser:p];
			}
			break;
		}
		inTrack = YES;
		lastAssemblies = outAssemblies;
	}
	
	return outAssemblies;
}


- (void)throwTrackExceptionWithPreviousState:(NSSet *)inAssemblies parser:(TODParser *)p {
	TODAssembly *best = [self best:inAssemblies];

	NSString *after = [best consumed:@" "];
	if (!after.length) {
		after = @"-nothing-";
	}
	
	NSString *expected = [p description];

	id next = [best peek];
	NSString *found = next ? [next description] : @"-nothing-";
	
	NSString *reason = [NSString stringWithFormat:@"\n\nAfter : %@\nExpected : %@\nFound : %@\n\n", after, expected, found];
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
							  after, @"after",
							  expected, @"expected",
							  found, @"found",
							  nil];
	NSException *e = [NSException exceptionWithName:@"TODTrackException" reason:reason userInfo:userInfo];
	[e raise];
}

@end
