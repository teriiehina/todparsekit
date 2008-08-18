//
//  DemoAppDelegate.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/12/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TODTokenizer;

@interface DemoAppDelegate : NSObject {
	IBOutlet NSTokenField *tokenField;
	
	TODTokenizer *tokenizer;
	NSString *inString;
	NSString *outString;
	NSString *tokString;
	BOOL busy;
}
- (IBAction)parse:(id)sender;

@property (retain) TODTokenizer *tokenizer;
@property (retain) NSString *inString;
@property (retain) NSString *outString;
@property (retain) NSString *tokString;
@property BOOL busy;
@end
