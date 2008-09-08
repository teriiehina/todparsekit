//
//  DebugAppDelegate.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/12/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "DebugAppDelegate.h"
#import <TDParseKit/TDParseKit.h>
#import "TDJsonParser.h"
#import "TDFastJsonParser.h"
#import "TDRegularParser.h"
#import "TDXmlNameState.h"
#import "TDXmlToken.h"
#import "TDXmlSyntaxColoring.h"

@implementation DebugAppDelegate

- (void)dealloc {
	self.displayString = nil;
	[super dealloc];
}


- (IBAction)run:(id)sender {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
//	NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"small-xml-file" ofType:@"xml"];
//	NSString *s = [NSString stringWithContentsOfFile:path];
//	
//	TDXmlSyntaxColoring *colorer = [[TDXmlSyntaxColoring alloc] init];
//	self.displayString = [colorer parse:s];
//	[colorer release];

	
	
	NSString *s = @"--> . ";
	TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
	[t.symbolState add:@"-->"];
	TDToken *tok = [t nextToken];
	NSLog(@"sval: %@", tok.stringValue);
	self.displayString = [[[NSAttributedString alloc] initWithString:tok.stringValue] autorelease];

	//STAssertTrue(tok.isSymbol, @"");
	//STAssertEqualObjects(@"-->", tok.stringValue, @"");
	//	STAssertEqualObjects(@"-->", tok.value, @"");
	
	//	tok = [t nextToken];
	//	STAssertEqualObjects(@".", tok.stringValue, @"");
	//	STAssertEqualObjects(@".", tok.value, @"");
	//	STAssertTrue(tok.isSymbol, @"");
	//	
	//	STAssertEquals([TDToken EOFToken], [t nextToken], @"");
	
	

//	NSString *s = @"123";
//	TDAssembly *a = [TDCharacterAssembly assemblyWithString:s];
//	TDParser *p = [TDDigit digit];
//	
//	TDAssembly *result = [p completeMatchFor:a];

//	NSString *s = @"a b c";
//	TDAssembly *a = [TDTokenAssembly assemblyWithString:s];
//	TDParser *p = [TDWord word];
//	
//	TDAssembly *result = [p completeMatchFor:a];
	
	
//	NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"yahoo" ofType:@"json"];
//	NSString *s = [NSString stringWithContentsOfFile:path];
//	
//	TDJsonParser *p = [[[TDJsonParser alloc] init] autorelease];
////	TDFastJsonParser *p = [[[TDFastJsonParser alloc] init] autorelease];
//	
//	id result = nil;
//	
//	@try {
//		result = [p parse:s];
//	}
//	@catch (NSException *e) {
//		NSLog(@"\n\n\nexception:\n\n %@", [e reason]);
//	}
//	NSLog(@"result %@", result);

	
//	NSString *s = @"2e2";
//	TDTokenizer *t = [TDTokenizer tokenizer];
//	TDScientificNumberState *sns = [[[TDScientificNumberState alloc] init] autorelease];
//	t.numberState = sns;
//	[t setTokenizerState:sns from:'0' to:'9'];
//	[t setTokenizerState:sns from:'-' to:'-'];
//	t.string = s;
//	
//	TDToken *tok = [t nextToken];
//	
//	NSLog(@"t: %@", t);
	
	[pool release];
	
}

@synthesize displayString;
@end
