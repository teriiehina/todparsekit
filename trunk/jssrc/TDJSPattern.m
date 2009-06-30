//
//  PKJSPattern.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 6/1/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSPattern.h"
#import "PKJSUtils.h"
#import "TDJSTerminal.h"
#import <ParseKit/PKPattern.h>

#pragma mark -
#pragma mark Methods

static JSValueRef TDPattern_invertedPattern(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDPattern_class, "invertedPattern");
    
    PKPattern *data = JSObjectGetPrivate(this);
    return TDPattern_new(ctx, [data invertedPattern]);
}

#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDPattern_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDPattern_finalize(JSObjectRef this) {
    // released in TDParser_finalize
}

static JSStaticFunction TDPattern_staticFunctions[] = {
{ "invertedPattern", TDPattern_invertedPattern, kJSPropertyAttributeDontDelete },
{ 0, 0, 0 }
};

static JSStaticValue TDPattern_staticValues[] = {        
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDPattern_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = TDTerminal_class(ctx);
        def.staticFunctions = TDPattern_staticFunctions;
        def.staticValues = TDPattern_staticValues;
        def.initialize = TDPattern_initialize;
        def.finalize = TDPattern_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDPattern_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDPattern_class(ctx), data);
}

JSObjectRef TDPattern_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionConstructorArgc(1, "PKPattern");

    NSString *s = TDJSValueGetNSString(ctx, argv[0], ex);
    NSInteger opts = TDPatternOptionsNone;
    
    if (argc > 1) {
        opts = JSValueToNumber(ctx, argv[1], ex);
    }

    PKPattern *data = [[PKPattern alloc] initWithString:s options:opts];
    return TDPattern_new(ctx, data);
}
