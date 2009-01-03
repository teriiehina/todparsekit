//
//  TDJSTokenAssembly.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/3/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSTokenAssembly.h"
#import "TDJSToken.h"
#import "TDJSUtils.h"
#import <Foundation/Foundation.h>
#import <TDParseKit/TDTokenAssembly.h>
#import <TDParseKit/TDToken.h>

#pragma mark -
#pragma mark Methods

static JSValueRef TDTokenAssembly_toString(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDTokenAssembly *data = JSObjectGetPrivate(this);
    JSStringRef resStr = JSStringCreateWithCFString((CFStringRef)[data description]);
    JSValueRef res = JSValueMakeString(ctx, resStr);
    JSStringRelease(resStr);
    return res;
}

static JSValueRef TDTokenAssembly_pop(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDTokenAssembly *data = JSObjectGetPrivate(this);
    TDToken *tok = [data pop];
    return TDToken_new(ctx, tok);
}

static JSValueRef TDTokenAssembly_push(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    if (argc < 1) {
        JSStringRef str = JSStringCreateWithUTF8CString("TDTokenAssembly.push() requires 1 argument");
        (*ex) = JSValueMakeString(ctx, str);
        JSStringRelease(str);
        return JSValueMakeUndefined(ctx);
    }
    
    JSValueRef v = argv[0];

    TDTokenAssembly *data = JSObjectGetPrivate(this);
    id obj = [(id)TDJSValueCopyCFType(ctx, v) autorelease];
    [data push:obj];
    
    return JSValueMakeUndefined(ctx);
}

static JSValueRef TDTokenAssembly_objectsAbove(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    if (argc < 1) {
        JSStringRef str = JSStringCreateWithUTF8CString("TDTokenAssembly.objectsAbove() requires 1 argument");
        (*ex) = JSValueMakeString(ctx, str);
        JSStringRelease(str);
        return JSValueMakeUndefined(ctx);
    }
    
    JSValueRef v = argv[0];
    
    TDTokenAssembly *data = JSObjectGetPrivate(this);
    id obj = [(id)TDJSValueCopyCFType(ctx, v) autorelease];
    id array = [data objectsAbove:obj];
    
    return TDCFArrayToJSObject(ctx, (CFArrayRef)array);
}

#pragma mark -
#pragma mark Properties

static JSValueRef TDTokenAssembly_getLength(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDTokenAssembly *data = JSObjectGetPrivate(this);
    return JSValueMakeNumber(ctx, data.length);
}

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDTokenAssembly_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDTokenAssembly_finalize(JSObjectRef this) {
    TDTokenAssembly *data = (TDTokenAssembly *)JSObjectGetPrivate(this);
    [data release];
}

static JSStaticFunction TDTokenAssembly_staticFunctions[] = {
{ "toString", TDTokenAssembly_toString, kJSPropertyAttributeDontDelete },        
{ "pop", TDTokenAssembly_pop, kJSPropertyAttributeDontDelete },        
{ "push", TDTokenAssembly_push, kJSPropertyAttributeDontDelete },        
{ "objectsAbove", TDTokenAssembly_objectsAbove, kJSPropertyAttributeDontDelete },        
{ 0, 0, 0 }
};

static JSStaticValue TDTokenAssembly_staticValues[] = {        
{ "length", TDTokenAssembly_getLength, NULL, kJSPropertyAttributeDontDelete|kJSPropertyAttributeReadOnly }, // Number
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark ClassMethods

#pragma mark -
#pragma mark Public

JSClassRef TDTokenAssembly_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.staticFunctions = TDTokenAssembly_staticFunctions;
        def.staticValues = TDTokenAssembly_staticValues;
        def.initialize = TDTokenAssembly_initialize;
        def.finalize = TDTokenAssembly_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDTokenAssembly_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDTokenAssembly_class(ctx), data);
}

JSObjectRef TDTokenAssembly_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    if (argc < 3) {
        JSStringRef str = JSStringCreateWithUTF8CString("TDJSTokenAssembly constructor requires 3 arguments: tokenType, stringValue, numberValue");
        (*ex) = JSValueMakeString(ctx, str);
        JSStringRelease(str);
        return JSValueToObject(ctx, JSValueMakeUndefined(ctx), ex);
    }
    
    JSValueRef t = argv[0];
    JSValueRef s = argv[1];
    JSValueRef n = argv[2];
    
    JSStringRef stringValueStr = JSValueToStringCopy(ctx, s, NULL);
    NSString *stringValue = [(id)JSStringCopyCFString(kCFAllocatorDefault, stringValueStr) autorelease];
    JSStringRelease(stringValueStr);
    
    CGFloat tokenType = JSValueToNumber(ctx, t, NULL);
    CGFloat floatValue = JSValueToNumber(ctx, n, NULL);
    
    TDTokenAssembly *data = [[TDTokenAssembly alloc] initWithTokenType:tokenType stringValue:stringValue floatValue:floatValue];
    return TDTokenAssembly_new(ctx, data);
}
