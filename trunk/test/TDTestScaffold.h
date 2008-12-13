//
//  TDTestScaffold.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
#import <TDParseKit/TDParseKit.h>

#define TDAssertTrue(e) STAssertTrue((e), @"")
#define TDAssertFalse(e) STAssertFalse((e), @"")
#define TDAssertNil(e) STAssertNil((e), @"")
#define TDAssertNotNil(e) STAssertNotNil((e), @"")
#define TDAssertEquals(e1, e2) STAssertEquals((e1), (e2), @"")
#define TDAssertEqualObjects(e1, e2) STAssertEqualObjects((e1), (e2), @"")
#define TDAssertThrows(e) STAssertThrows((e), @"")

@interface TDTestScaffold : SenTestSuite {

}

@end
