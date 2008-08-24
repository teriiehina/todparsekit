//
//  TDTestScaffold.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"

@interface SenTestSuite (TDAdditions)
- (void)addSuitesForClassNames:(NSArray *)classNames;
@end

@implementation SenTestSuite (TDAdditions)
- (void)addSuitesForClassNames:(NSArray *)classNames {
	for (NSString *className in classNames) {
		SenTestSuite *suite = [SenTestSuite testSuiteForTestCaseWithName:className];
		[self addTest:suite];
	}
	
}
@end

#define RUN_ALL_TEST_CASES 1

@implementation TDTestScaffold

+ (void)load {
	[self poseAsClass:[SenTestSuite class]];
}


+ (SenTestSuite *)soloTestSuite {
	SenTestSuite *suite = [SenTestSuite testSuiteWithName:@"Solo Test Suite"];
	
	NSArray *classNames = [NSArray arrayWithObjects:
						   @"TDXmlTokenizerTest",
						   nil];
	
	[suite addSuitesForClassNames:classNames];
	return suite;
}


+ (SenTestSuite *)tokensTestSuite {
	SenTestSuite *suite = [SenTestSuite testSuiteWithName:@"Tokens Test Suite"];
	
	NSArray *classNames = [NSArray arrayWithObjects:
						   @"TDReaderTest",
						   @"TDTokenizerTest",
						   @"TDTokenizerTest",
						   @"TDNumberStateTest",
						   @"TDQuoteStateTest",
						   @"TDWhitespaceStateTest",
						   @"TDWordStateTest",
						   @"TDSlashStateTest",
						   @"TDSymbolStateTest",
						   nil];
	
	[suite addSuitesForClassNames:classNames];
	return suite;
}


+ (SenTestSuite *)charsTestSuite {
	SenTestSuite *suite = [SenTestSuite testSuiteWithName:@"Chars Test Suite"];
	
	NSArray *classNames = [NSArray arrayWithObjects:
						   @"TDCharacterAssemblyTest",
						   @"TDDigitTest",
						   @"TDCharTest",
						   @"TDLetterTest",
						   @"TDSpecificCharTest",
						   nil];
	
	[suite addSuitesForClassNames:classNames];
	return suite;
}


+ (SenTestSuite *)parseTestSuite {
	SenTestSuite *suite = [SenTestSuite testSuiteWithName:@"Parse Test Suite"];
	
	NSArray *classNames = [NSArray arrayWithObjects:
						   @"TDParserTest",
						   @"TDTokenAssemblyTest",
						   @"TDLiteralTest",
						   @"TDRepetitionTest",
						   @"TDSequenceTest",
						   @"TDAlternationTest",
						   @"TDSymbolTest",
						   @"TDRobotCommandTest",
						   @"TDXmlParserTest",
						   @"TDJsonParserTest",
						   @"TDFastJsonParserTest",
						   @"TDRegularParserTest",
						   @"SRGSParserTest",
						   @"EBNFParserTest",
						   @"TDXmlNameTest",
						   @"XPathParserTest",
						   @"XMLReaderTest",
						   @"TDXmlTokenizerTest",
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
//	[suite addTest:[self charsTestSuite]];
//	[suite addTest:[self tokensTestSuite]];
//	[suite addTest:[self parseTestSuite]];
	[suite addTest:[self soloTestSuite]];
#endif
	
	return suite;
}

@end