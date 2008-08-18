//
//  TODTestScaffold.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODTestScaffold.h"

@interface SenTestSuite (TODAdditions)
- (void)addSuitesForClassNames:(NSArray *)classNames;
@end

@implementation SenTestSuite (TODAdditions)
- (void)addSuitesForClassNames:(NSArray *)classNames {
	for (NSString *className in classNames) {
		SenTestSuite *suite = [SenTestSuite testSuiteForTestCaseWithName:className];
		[self addTest:suite];
	}
	
}
@end

#define RUN_ALL_TEST_CASES 1

@implementation TODTestScaffold

+ (void)load {
	[self poseAsClass:[SenTestSuite class]];
}


+ (SenTestSuite *)tokensTestSuite {
	SenTestSuite *suite = [SenTestSuite testSuiteWithName:@"Tokens Test Suite"];
	
	NSArray *classNames = [NSArray arrayWithObjects:
						   @"TODReaderTest",
						   @"TODTokenizerTest",
						   @"TODTokenizerTest",
						   @"TODNumberStateTest",
						   @"TODQuoteStateTest",
						   @"TODWhitespaceStateTest",
						   @"TODWordStateTest",
						   @"TODSlashStateTest",
						   @"TODSymbolStateTest",
						   nil];
	
	[suite addSuitesForClassNames:classNames];
	return suite;
}


+ (SenTestSuite *)charsTestSuite {
	SenTestSuite *suite = [SenTestSuite testSuiteWithName:@"Chars Test Suite"];
	
	NSArray *classNames = [NSArray arrayWithObjects:
						   @"TODCharacterAssemblyTest",
						   @"TODDigitTest",
						   @"TODCharTest",
						   @"TODLetterTest",
						   @"TODSpecificCharTest",
						   nil];
	
	[suite addSuitesForClassNames:classNames];
	return suite;
}


+ (SenTestSuite *)parseTestSuite {
	SenTestSuite *suite = [SenTestSuite testSuiteWithName:@"Parse Test Suite"];
	
	NSArray *classNames = [NSArray arrayWithObjects:
						   @"TODParserTest",
						   @"TODTokenAssemblyTest",
						   @"TODLiteralTest",
						   @"TODRepetitionTest",
						   @"TODSequenceTest",
						   @"TODAlternationTest",
						   @"TODSymbolTest",
						   @"TODRobotCommandTest",
						   @"TODXmlParserTest",
						   @"TODJsonParserTest",
						   @"TODFastJsonParserTest",
						   @"TODRegularParserTest",
						   @"SRGSParserTest",
						   @"EBNFParserTest",
						   @"TODXmlNameTest",
						   @"XPathParserTest",
						   nil];
	
	[suite addSuitesForClassNames:classNames];
	return suite;
}


+ (id)testSuiteForBundlePath:(NSString *) bundlePath {
	SenTestSuite *suite = nil;
	
#if RUN_ALL_TEST_CASES
	suite = [super defaultTestSuite];
#else
	suite = [SenTestSuite testSuiteWithName:@"My Tests"]; 
	[suite addTest:[self charsTestSuite]];
	[suite addTest:[self tokensTestSuite]];
	[suite addTest:[self parseTestSuite]];
#endif
	
	return suite;
}

@end