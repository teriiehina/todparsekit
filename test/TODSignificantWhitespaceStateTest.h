//
//  TODSignificantWhitespaceStateTest.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import <TODParseKit/TODParseKit.h>

@interface TODSignificantWhitespaceStateTest : SenTestCase {
	TODSignificantWhitespaceState *whitespaceState;
	TODReader *r;
	NSString *s;	
}
@end
