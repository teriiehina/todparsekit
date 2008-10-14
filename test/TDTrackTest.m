//
//  TDTrackTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDTrackTest.h"
#import "TDParseKit.h"


@implementation TDTrackTest

//	list = '(' contents ')'
//	contents = empty | actualList
//	actualList = Word (',' Word)*


- (TDParser *)listParser {
	TDTrack *commaWord = [TDTrack track];
	[commaWord add:[[TDSymbol symbolWithString:@","] discard]];
	[commaWord add:[TDWord word]];
	
	TDSequence *actualList = [TDSequence sequence];
	[actualList add:[TDWord word]];
	[actualList add:[TDRepetition repetitionWithSubparser:commaWord]];
	
	TDAlternation *contents = [TDAlternation alternation];
	[contents add:[TDEmpty empty]];
	[contents add:actualList];
	
	TDTrack *list = [TDTrack track];
	[list add:[[TDSymbol symbolWithString:@"("] discard]];
	[list add:contents];
	[list add:[[TDSymbol symbolWithString:@")"] discard]];

	return list;
}


- (void)testTrack {
	
	TDParser *list = [self listParser];
	
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
		TDAssembly *a = [TDTokenAssembly assemblyWithString:s];
		@try {
			TDAssembly *result = [list completeMatchFor:a];
			if (!result) {
				NSLog(@"[list completeMatchFor:] returns nil");
			} else {
				NSString *stack = [[[list completeMatchFor:a] stack] description];
				NSLog(@"OK stack is: %@", stack);
			}
		} @catch (TDTrackException *e) {
			NSLog(@"\n\n%@\n\n", [e reason]);
		}
	}
	
}


- (void)testMissingParen {
	TDTrack *track = [TDTrack track];
	[track add:[TDSymbol symbolWithString:@"("]];
	[track add:[TDSymbol symbolWithString:@")"]];
	
	TDAssembly *a = [TDTokenAssembly assemblyWithString:@"("];
	STAssertThrowsSpecificNamed([track completeMatchFor:a], TDTrackException, @"Track Exception", @"");
	
	@try {
		[track completeMatchFor:a];
		STAssertTrue(0, @"Should not be reached");
	} @catch (TDTrackException *e) {
		STAssertEqualObjects([e class], [TDTrackException class], @"");
		STAssertEqualObjects([e name], @"Track Exception", @"");
		
		NSDictionary *userInfo = e.userInfo;
		STAssertNotNil(userInfo, @"");
		
		NSString *after = [userInfo objectForKey:@"after"];
		NSString *expected = [userInfo objectForKey:@"expected"];
		NSString *found = [userInfo objectForKey:@"found"];
		
		STAssertNotNil(after, @"");
		STAssertNotNil(expected, @"");
		STAssertNotNil(found, @"");
		
		STAssertEqualObjects(after, @"(", @"");
		STAssertEqualObjects(expected, @"Symbol )", @"");
		STAssertEqualObjects(found, @"-nothing-", @"");
	}
}

@end
