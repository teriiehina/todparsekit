//
//  TODNumberStateTest.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 1/29/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import <TODParseKit/TODParseKit.h>


@interface TODNumberStateTest : SenTestCase {
	TODNumberState *numberState;
	TODReader *r;
	NSString *s;
}
@end
