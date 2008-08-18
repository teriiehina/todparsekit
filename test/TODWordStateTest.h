//
//  TODWordStateTest.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 6/7/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import <TODParseKit/TODParseKit.h>

@interface TODWordStateTest : SenTestCase {
	TODWordState *wordState;
	TODReader *r;
	NSString *s;	
}
@end
