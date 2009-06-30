//
//  TDJSUppercaseWord.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/13/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSUppercaseWord.h"
#import "TDJSUtils.h"
#import "TDJSWord.h"
#import <ParseKit/TDUppercaseWord.h>

#pragma mark -
#pragma mark Methods

#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDUppercaseWord_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDUppercaseWord_finalize(JSObjectRef this) {
    // released in TDParser_finalize
}

static JSStaticFunction TDUppercaseWord_staticFunctions[] = {
{ 0, 0, 0 }
};

static JSStaticValue TDUppercaseWord_staticValues[] = {        
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDUppercaseWord_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = TDWord_class(ctx);
        def.staticFunctions = TDUppercaseWord_staticFunctions;
        def.staticValues = TDUppercaseWord_staticValues;
        def.initialize = TDUppercaseWord_initialize;
        def.finalize = TDUppercaseWord_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDUppercaseWord_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDUppercaseWord_class(ctx), data);
}

JSObjectRef TDUppercaseWord_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionConstructorArgc(1, "TDUppercaseWord");
    
    NSString *s = TDJSValueGetNSString(ctx, argv[0], ex);
    
    TDUppercaseWord *data = [[TDUppercaseWord alloc] initWithString:s];
    return TDUppercaseWord_new(ctx, data);
}
