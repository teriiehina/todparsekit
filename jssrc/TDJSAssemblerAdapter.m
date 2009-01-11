//
//  TDJSAssemblerAdapter.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/10/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSAssemblerAdapter.h"
#import "TDJSUtils.h"

@implementation TDJSAssemblerAdapter

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)dealloc {
    [self setJsAssembler:NULL fromContext:NULL];
    self.selectorString = nil;
    [super dealloc];
}


- (BOOL)respondsToSelector:(SEL)sel {
    NSString *s = NSStringFromSelector(sel);
    if ([s isEqualToString:selectorString]) {
        return YES;
    }
    return [super respondsToSelector:sel];
}


- (id)performSelector:(SEL)sel withObject:(id)obj {
    NSString *s = NSStringFromSelector(sel);
    if ([s isEqualToString:selectorString]) {
        JSStringRef funcName = JSStringCreateWithCFString((CFStringRef)selectorString);
        JSObjectRef func = (JSObjectRef)JSObjectGetProperty(ctx, jsAssembler, funcName, NULL);
        JSStringRelease(funcName);
        JSValueRef argv[] = { (JSValueRef)TDTokenAssembly_new(ctx, obj) };
        JSObjectCallAsFunction(ctx, func, jsAssembler, 1, argv, NULL);
    }
    return nil;
}


- (JSObjectRef)jsAssembler {
    return jsAssembler;
}


- (void)setJsAssembler:(JSObjectRef)a fromContext:(JSContextRef)c {
    if (jsAssembler != a) {
        if (ctx && jsAssembler) {
            JSValueUnprotect(ctx, jsAssembler);
            JSGarbageCollect(ctx);
        }
        
        ctx = c;
        jsAssembler = a;
        if (ctx && jsAssembler) {
            JSValueProtect(ctx, jsAssembler);
        }
    }
}

@synthesize selectorString;
@end
