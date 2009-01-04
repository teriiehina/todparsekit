//
//  TDJSTokenizer.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/3/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSTokenizer.h"
#import "TDJSUtils.h"
#import <Foundation/Foundation.h>
#import <TDParseKit/TDTokenizer.h>

#pragma mark -
#pragma mark Methods

static JSValueRef TDTokenizer_toString(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    return TDNSStringToJSValue(ctx, @"[object TDTokenizer]", ex);
}

#pragma mark -
#pragma mark Properties

static JSValueRef TDTokenizer_getString(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDTokenizer *data = JSObjectGetPrivate(this);
    return TDNSStringToJSValue(ctx, data.string, ex);
}

static bool TDTokenizer_setString(JSContextRef ctx, JSObjectRef this, JSStringRef propertyName, JSValueRef value, JSValueRef *ex) {
    TDTokenizer *data = JSObjectGetPrivate(this);
    data.string = TDJSValueGetNSString(ctx, value, ex);
    return true;
}

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDTokenizer_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDTokenizer_finalize(JSObjectRef this) {
    TDTokenizer *data = (TDTokenizer *)JSObjectGetPrivate(this);
    [data release];
}

static JSStaticFunction TDTokenizer_staticFunctions[] = {
{ "toString", TDTokenizer_toString, kJSPropertyAttributeDontDelete },        
{ 0, 0, 0 }
};

static JSStaticValue TDTokenizer_staticValues[] = {        
{ "string", TDTokenizer_getString, TDTokenizer_setString, kJSPropertyAttributeDontDelete }, // String
//{ "string", TDTokenizer_getString, TDTokenizer_setString, kJSPropertyAttributeDontDelete|kJSPropertyAttributeReadOnly }, // String
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDTokenizer_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.staticFunctions = TDTokenizer_staticFunctions;
        def.staticValues = TDTokenizer_staticValues;
        def.initialize = TDTokenizer_initialize;
        def.finalize = TDTokenizer_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDTokenizer_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDTokenizer_class(ctx), data);
}

JSObjectRef TDTokenizer_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    if (argc < 1) {
        (*ex) = TDNSStringToJSValue(ctx, @"TDTokenizer constructor requires 1 argument: string", ex);
        return JSValueToObject(ctx, JSValueMakeUndefined(ctx), ex);
    }
    
    JSValueRef s = argv[0];
    NSString *string = TDJSValueGetNSString(ctx, s, ex);
    
    TDTokenizer *data = [[TDTokenizer alloc] initWithString:string];
    return TDTokenizer_new(ctx, data);
}
