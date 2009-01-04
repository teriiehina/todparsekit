//
//  TDJSAssembly.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/3/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSAssembly.h"
#import "TDJSToken.h"
#import "TDJSUtils.h"
#import <Foundation/Foundation.h>
#import <TDParseKit/TDAssembly.h>
#import <TDParseKit/TDToken.h>

#pragma mark -
#pragma mark Methods

static JSValueRef TDAssembly_toString(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDAssembly *data = JSObjectGetPrivate(this);
    return TDNSStringToJSValue(ctx, [data description], ex);
}

static JSValueRef TDAssembly_pop(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDAssembly *data = JSObjectGetPrivate(this);
    TDToken *tok = [data pop];
    return TDToken_new(ctx, tok);
}

static JSValueRef TDAssembly_push(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    if (argc < 1) {
        JSStringRef str = JSStringCreateWithUTF8CString("TDAssembly.push() requires 1 argument");
        (*ex) = JSValueMakeString(ctx, str);
        JSStringRelease(str);
        return JSValueMakeUndefined(ctx);
    }
    
    JSValueRef v = argv[0];
    
    TDAssembly *data = JSObjectGetPrivate(this);
    id obj = [(id)TDJSValueCopyCFType(ctx, v, ex) autorelease];
    [data push:obj];
    
    return JSValueMakeUndefined(ctx);
}

static JSValueRef TDAssembly_objectsAbove(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    if (argc < 1) {
        JSStringRef str = JSStringCreateWithUTF8CString("TDAssembly.objectsAbove() requires 1 argument");
        (*ex) = JSValueMakeString(ctx, str);
        JSStringRelease(str);
        return JSValueMakeUndefined(ctx);
    }
    
    JSValueRef v = argv[0];
    
    TDAssembly *data = JSObjectGetPrivate(this);
    id obj = [(id)TDJSValueCopyCFType(ctx, v, ex) autorelease];
    id array = [data objectsAbove:obj];
    
    return TDCFArrayToJSObject(ctx, (CFArrayRef)array, ex);
}

#pragma mark -
#pragma mark Properties

static JSValueRef TDAssembly_getDefaultDelimiter(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDAssembly *data = JSObjectGetPrivate(this);
    return TDNSStringToJSValue(ctx, data.defaultDelimiter, ex);
}

static JSValueRef TDAssembly_getStack(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDAssembly *data = JSObjectGetPrivate(this);
    return TDCFArrayToJSObject(ctx, (CFArrayRef)data.stack, ex);
}

static JSValueRef TDAssembly_getTarget(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDAssembly *data = JSObjectGetPrivate(this);
    return TDCFTypeToJSValue(ctx, (CFTypeRef)data.target, ex);
}

static bool TDAssembly_setTarget(JSContextRef ctx, JSObjectRef this, JSStringRef propertyName, JSValueRef value, JSValueRef *ex) {
    TDAssembly *data = JSObjectGetPrivate(this);
    id target = (id)TDJSValueCopyCFType(ctx, value, ex);
    data.target = target;
    [target release];
    return true;
}

static JSValueRef TDAssembly_getIsStackEmpty(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDAssembly *data = JSObjectGetPrivate(this);
    return JSValueMakeBoolean(ctx, data.isStackEmpty);
}

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDAssembly_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDAssembly_finalize(JSObjectRef this) {
    TDAssembly *data = (TDAssembly *)JSObjectGetPrivate(this);
    [data release];
}

static JSStaticFunction TDAssembly_staticFunctions[] = {
{ "toString", TDAssembly_toString, kJSPropertyAttributeDontDelete },        
{ "pop", TDAssembly_pop, kJSPropertyAttributeDontDelete },        
{ "push", TDAssembly_push, kJSPropertyAttributeDontDelete },        
{ "objectsAbove", TDAssembly_objectsAbove, kJSPropertyAttributeDontDelete },        
{ 0, 0, 0 }
};

static JSStaticValue TDAssembly_staticValues[] = {        
{ "defaulDelimiter", TDAssembly_getDefaultDelimiter, NULL, kJSPropertyAttributeDontDelete|kJSPropertyAttributeReadOnly }, // String
{ "stack", TDAssembly_getStack, NULL, kJSPropertyAttributeDontDelete|kJSPropertyAttributeReadOnly }, // Array
{ "target", TDAssembly_getTarget, TDAssembly_setTarget, kJSPropertyAttributeDontDelete }, // Object
{ "isStackEmpty", TDAssembly_getIsStackEmpty, NULL, kJSPropertyAttributeDontDelete|kJSPropertyAttributeReadOnly }, // Boolean
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark ClassMethods

#pragma mark -
#pragma mark Public

JSClassRef TDAssembly_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.staticFunctions = TDAssembly_staticFunctions;
        def.staticValues = TDAssembly_staticValues;
        def.initialize = TDAssembly_initialize;
        def.finalize = TDAssembly_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDAssembly_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDAssembly_class(ctx), data);
}

JSObjectRef TDAssembly_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    if (argc < 1) {
        JSStringRef str = JSStringCreateWithUTF8CString("TDAssembly constructor requires 1 argument: string");
        (*ex) = JSValueMakeString(ctx, str);
        JSStringRelease(str);
        return JSValueToObject(ctx, JSValueMakeUndefined(ctx), ex);
    }
    
    JSValueRef s = argv[0];
    
    NSString *string = TDJSValueGetNSString(ctx, s, ex);
    TDAssembly *data = [[TDAssembly alloc] initWithString:string];
    return TDAssembly_new(ctx, data);
}
