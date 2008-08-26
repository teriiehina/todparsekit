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

@implementation DebugAppDelegate

- (IBAction)run:(id)sender {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

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

	
	NSString *s = @"2.0e2";
	TDReader *r = [[[TDReader alloc] initWithString:s] autorelease];
	TDTokenizerState *numberState = [[[TDScientificNumberState alloc] init] autorelease];

	TDToken *t = [numberState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	
	NSLog(@"t: %@", t);
	
	[pool release];
	
}

@end
