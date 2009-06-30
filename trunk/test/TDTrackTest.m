//
//  TDTrackTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDTrackTest.h"
#import "ParseKit.h"


@implementation TDTrackTest

//    list = '(' contents ')'
//    contents = empty | actualList
//    actualList = Word (',' Word)*


- (PKParser *)listParser {
    PKTrack *commaWord = [PKTrack track];
    [commaWord add:[[TDSymbol symbolWithString:@","] discard]];
    [commaWord add:[TDWord word]];
    
    PKSequence *actualList = [PKSequence sequence];
    [actualList add:[TDWord word]];
    [actualList add:[PKRepetition repetitionWithSubparser:commaWord]];
    
    PKAlternation *contents = [PKAlternation alternation];
    [contents add:[PKEmpty empty]];
    [contents add:actualList];
    
    PKTrack *list = [PKTrack track];
    [list add:[[TDSymbol symbolWithString:@"("] discard]];
    [list add:contents];
    [list add:[[TDSymbol symbolWithString:@")"] discard]];

    return list;
}


- (void)testTrack {
    
    PKParser *list = [self listParser];
    
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
        //NSLog(@"\n----testing: %@", s);
        PKAssembly *a = [TDTokenAssembly assemblyWithString:s];
        @try {
            PKAssembly *result = [list completeMatchFor:a];
            if (!result) {
                //NSLog(@"[list completeMatchFor:] returns nil");
            } else {
                //NSString *stack = [[[list completeMatchFor:a] stack] description];
                //NSLog(@"OK stack is: %@", stack);
            }
        } @catch (PKTrackException *e) {
            //NSLog(@"\n\n%@\n\n", [e reason]);
        }
    }
    
}


- (void)testMissingParen {
    PKTrack *track = [PKTrack track];
    [track add:[TDSymbol symbolWithString:@"("]];
    [track add:[TDSymbol symbolWithString:@")"]];
    
    PKAssembly *a = [TDTokenAssembly assemblyWithString:@"("];
    STAssertThrowsSpecificNamed([track completeMatchFor:a], PKTrackException, TDTrackExceptionName, @"");
    
    @try {
        [track completeMatchFor:a];
        STAssertTrue(0, @"Should not be reached");
    } @catch (PKTrackException *e) {
        TDEqualObjects([e class], [PKTrackException class]);
        TDEqualObjects([e name], TDTrackExceptionName);
        
        NSDictionary *userInfo = e.userInfo;
        TDNotNil(userInfo);
        
        NSString *after = [userInfo objectForKey:@"after"];
        NSString *expected = [userInfo objectForKey:@"expected"];
        NSString *found = [userInfo objectForKey:@"found"];
        
        TDNotNil(after);
        TDNotNil(expected);
        TDNotNil(found);
        
        TDEqualObjects(after, @"(");
        TDEqualObjects(expected, @"Symbol )");
        TDEqualObjects(found, @"-nothing-");
    }
}

@end
