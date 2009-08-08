//
//  DemoTreesViewController.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 8/2/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "DemoTreesViewController.h"
#import "PKParseTreeView.h"
#import <ParseKit/ParseKit.h>

@implementation DemoTreesViewController

- (id)init {
    return [self initWithNibName:@"TreesView" bundle:nil];
}


- (id)initWithNibName:(NSString *)name bundle:(NSBundle *)b {
    if (self = [super initWithNibName:name bundle:b]) {
        
    }
    return self;
}


- (void)dealloc {
    self.grammarString = nil;
    self.inString = nil;
    [super dealloc];
}


- (void)awakeFromNib {
    self.grammarString = 
//@"@start=expr;expr='foo' 'bar' 'baz';";
        @"@start = expr;"
        @"expr = addExpr;"
        @"addExpr = atom (('+'|'-') atom)*;"
        @"atom = Number;";
    
//    self.inString = @"foo bar baz";
    self.inString = @"1 + 2";
}


- (IBAction)parse:(id)sender {
    if (![inString length] || ![grammarString length]) {
        NSBeep();
        return;
    }
    
    self.busy = YES;
    
    [NSThread detachNewThreadSelector:@selector(doParse) toTarget:self withObject:nil];
}


- (void)doParse {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    PKParseTreeAssembler *as = [[[PKParseTreeAssembler alloc] init] autorelease];
    PKParser *p = [[PKParserFactory factory] parserFromGrammar:grammarString assembler:as preassembler:as];
    PKParseTree *tr = [p parse:inString];
    [parseTreeView drawParseTree:tr];
    
    [self performSelectorOnMainThread:@selector(done) withObject:nil waitUntilDone:NO];
    
    [pool drain];
}


- (void)done {
    self.busy = NO;
}    

@synthesize grammarString;
@synthesize inString;
@synthesize busy;
@end

