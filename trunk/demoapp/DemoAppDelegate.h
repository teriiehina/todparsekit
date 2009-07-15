//
//  DemoAppDelegate.h
//  ParseKit
//
//  Created by Todd Ditchendorf on 7/12/08.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PKTokenizer;

@interface DemoAppDelegate : NSObject {
    IBOutlet NSTokenField *tokenField;
    
    PKTokenizer *tokenizer;
    NSString *inString;
    NSString *outString;
    NSString *tokString;
    NSMutableArray *toks;
    BOOL busy;
}
- (IBAction)parse:(id)sender;

@property (retain) PKTokenizer *tokenizer;
@property (retain) NSString *inString;
@property (retain) NSString *outString;
@property (retain) NSString *tokString;
@property (retain) NSMutableArray *toks;
@property BOOL busy;
@end
