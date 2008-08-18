//
//  DebugAppDelegate.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/12/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "DebugAppDelegate.h"
#import <TODParseKit/TODParseKit.h>
#import "TODJsonParser.h"
#import "TODFastJsonParser.h"
#import "TODRegularParser.h"
#import "TODXmlNameState.h"
#import "TODXmlToken.h"

@implementation DebugAppDelegate

- (IBAction)run:(id)sender {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

//	NSString *s = @"123";
//	TODAssembly *a = [TODCharacterAssembly assemblyWithString:s];
//	TODParser *p = [TODDigit digit];
//	
//	TODAssembly *result = [p completeMatchFor:a];

//	NSString *s = @"a b c";
//	TODAssembly *a = [TODTokenAssembly assemblyWithString:s];
//	TODParser *p = [TODWord word];
//	
//	TODAssembly *result = [p completeMatchFor:a];
	
	
	NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"apple-boss" ofType:@"json"];
	NSString *s = [NSString stringWithContentsOfFile:path];
	
	TODJsonParser *p = [[[TODJsonParser alloc] init] autorelease];
//	TODFastJsonParser *p = [[[TODFastJsonParser alloc] init] autorelease];
	
	id result = nil;
	
	@try {
		result = [p parse:s];
	}
	@catch (NSException *e) {
		NSLog(@"\n\n\nexception:\n\n %@", [e reason]);
	}
	NSLog(@"result %@", result);
	
	[pool release];
	
}

@end
