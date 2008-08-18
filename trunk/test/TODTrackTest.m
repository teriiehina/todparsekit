//
//  TODTrackTest.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODTrackTest.h"
#import "TODParseKit.h"


@implementation TODTrackTest

//	list = '(' contents ')'
//	contents = empty | actualList
//	actualList = Word (',' Word)*


- (TODParser *)listParser {
	TODTrack *commaWord = [TODTrack track];
	[commaWord add:[TODSymbol symbolWithString:@","]];
	[commaWord add:[TODWord word]];
	
	TODSequence *actualList = [TODSequence sequence];
	[actualList add:[TODWord word]];
	[actualList add:[TODRepetition repetitionWithSubparser:commaWord]];
	
	TODAlternation *contents = [TODAlternation alternation];
	[contents add:[TODEmpty empty]];
	[contents add:actualList];
	
	TODTrack *list = [TODTrack track];
	[list add:[[TODSymbol symbolWithString:@"("] discard]];
	[list add:contents];
	[list add:[[TODSymbol symbolWithString:@")"] discard]];

	return list;
}


- (void)testTrack {
	
	TODParser *list = [self listParser];
	
	NSArray *test = [NSArray arrayWithObjects:
					 @"()",
					 @"(pilfer)",
					 @"(pilfer, pinch)",
					 @"(pilfer, pinch, purloin)",
					 @"(pilfer, pinch,, purloin)",
					 @"(",
					 @"(pilfer",
					 @"(pilfer, ",
					 @"(, pinch, purloin)",
					 @"pilfer, pinch",
					 nil];
	
	for (NSString *s in test) {
		NSLog(@"\n----testing: %@", s);
		TODAssembly *a = [TODTokenAssembly assemblyWithString:s];
		@try {
			TODAssembly *result = [list completeMatchFor:a];
			if (!result) {
				NSLog(@"[list completeMatchFor:] returns nil");
			} else {
				NSString *stack = [[[list completeMatchFor:a] stack] description];
				NSLog(@"OK stack is: %@", stack);
			}
		}
		@catch (NSException * e) {
			NSLog(@"\n\n%@\n\n", [e reason]);
		}
	}
	
}

@end
