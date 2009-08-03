//
//  DemoTreesViewController.h
//  ParseKit
//
//  Created by Todd Ditchendorf on 8/2/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PKParseTreeView;

@interface DemoTreesViewController : NSViewController {
    IBOutlet NSTextView *grammarTextView;
    IBOutlet NSTextView *inputTextView;
    IBOutlet PKParseTreeView *parseTreeView;    
}

- (IBAction)parse:(id)sender;
@end
