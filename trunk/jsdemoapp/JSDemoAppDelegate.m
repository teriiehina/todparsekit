//
//  JSDemoAppDelegate.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/10/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "JSDemoAppDelegate.h"
#import <WebKit/WebKit.h>

@interface JSDemoAppDelegate ()
//+ (void)setUpDefaults;
@end

@implementation JSDemoAppDelegate

//+ (void)load {
//    if ([JSDemoAppDelegate class] == self) {
//        [self setUpDefaults];
//    }
//}
//
//
//+ (void)setUpDefaults {
//	NSString *path = [[NSBundle mainBundle] pathForResource:@"DefaultValues" ofType:@"plist"];
//    id defaultValues = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//	[[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:defaultValues];
//	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
//	[[NSUserDefaults standardUserDefaults] synchronize];
//}


- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)dealloc {
    self.webView = nil;
    [super dealloc];
}


- (IBAction)openLocation:(id)sender {
    [window makeFirstResponder:comboBox];
}


- (IBAction)goToLocation:(id)sender {
    NSString *URLString = [comboBox stringValue];
    
    if (!URLString.length) {
        NSBeep();
        return;
    }
    
    if (![URLString hasPrefix:@"http://"] && ![URLString hasPrefix:@"https://"]) {
        URLString = [NSString stringWithFormat:@"http://%@", URLString];
        [comboBox setStringValue:URLString];
    }
    
    [webView setMainFrameURL:URLString];
}


- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame {    
    if (frame != [sender mainFrame]) return;
    
    [window setTitle:title];
}


- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame {
    if (frame != [sender mainFrame]) return;
    
    NSString *URLString = [[[[frame provisionalDataSource] request] URL] absoluteString];
    [comboBox setStringValue:URLString];
}        


- (void)webView:(WebView *)sender didReceiveServerRedirectForProvisionalLoadForFrame:(WebFrame *)frame {
    if (frame != [sender mainFrame]) return;
    
    NSString *URLString = [[[[frame provisionalDataSource] request] URL] absoluteString];
    [comboBox setStringValue:URLString];
}


- (void)webView:(WebView *)sender willPerformClientRedirectToURL:(NSURL *)URL delay:(NSTimeInterval)seconds fireDate:(NSDate *)date forFrame:(WebFrame *)frame {
    [comboBox setStringValue:[URL absoluteString]];
}

@synthesize webView;
@end
