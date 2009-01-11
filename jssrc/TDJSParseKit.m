//
//  TDJSParseKit.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/10/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <TDJSParseKit/TDJSParseKit.h>
#import <TDParseKit/TDToken.h>
#import "TDJSUtils.h"
#import "TDJSToken.h"
#import "TDJSTokenizer.h"
#import "TDJSTokenizerState.h"
#import "TDJSAssembly.h"
#import "TDJSTokenAssembly.h"
#import "TDJSWordState.h"
#import "TDJSNumberState.h"
#import "TDJSWhitespaceState.h"
#import "TDJSCommentState.h"
#import "TDJSQuoteState.h"
#import "TDJSSymbolState.h"

static void printValue(JSContextRef ctx, JSValueRef val) {
    NSString *s = TDJSValueGetNSString(ctx, val, NULL);
    NSLog(@"%@", s);
}

static JSValueRef print(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef* ex) {
    printValue(ctx, argv[0]); // TODO check args
    return JSValueMakeUndefined(ctx);
}

static void setupPrintFunction(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef printFuncName = JSStringCreateWithUTF8CString("print");
    JSObjectRef printFunc = JSObjectMakeFunctionWithCallback(ctx, printFuncName, print);
    JSObjectSetProperty(ctx, globalObj, printFuncName, printFunc, kJSPropertyAttributeNone, ex);
}

static void setupTDTokenClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDToken");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDToken_class(ctx), TDToken_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);

    JSStringRef propName = JSStringCreateWithUTF8CString("EOFToken");
    JSValueRef classProp = TDToken_new(ctx, [TDToken EOFToken]);
    JSObjectSetProperty(ctx, constr, propName, classProp, kJSPropertyAttributeDontDelete|kJSPropertyAttributeReadOnly, NULL);
    JSStringRelease(propName);
    
//    JSStringRef propName = JSStringCreateWithUTF8CString("EOFToken");
//    JSValueRef classMethod = JSObjectMakeFunctionWithCallback(ctx, propName, TDToken_EOFToken);
//    JSObjectSetProperty(ctx, constr, propName, classMethod, kJSPropertyAttributeDontDelete|kJSPropertyAttributeReadOnly, NULL);
//    JSStringRelease(propName);
}

static void setupTDAssemblyClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDAssembly");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDAssembly_class(ctx), TDAssembly_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setupTDTokenAssemblyClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDTokenAssembly");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDTokenAssembly_class(ctx), TDTokenAssembly_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setupTDTokenizerClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDTokenizer");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDTokenizer_class(ctx), TDTokenizer_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setupTDTokenizerStateClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDTokenizerState");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDTokenizerState_class(ctx), TDTokenizerState_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setupTDWordStateClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDWordState");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDWordState_class(ctx), TDWordState_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setupTDNumberStateClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDNumberState");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDNumberState_class(ctx), TDNumberState_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setupTDWhitespaceStateClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDWhitespaceState");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDWhitespaceState_class(ctx), TDWhitespaceState_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setupTDCommentStateClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDCommentState");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDCommentState_class(ctx), TDCommentState_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setupTDQuoteStateClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDQuoteState");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDQuoteState_class(ctx), TDQuoteState_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setupTDSymbolStateClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDSymbolState");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDSymbolState_class(ctx), TDSymbolState_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

void TDJSParseKitSetUpContext(JSContextRef ctx) {
    setupPrintFunction(ctx, NULL);
    setupTDTokenClass(ctx, NULL);
    setupTDAssemblyClass(ctx, NULL);
    setupTDTokenAssemblyClass(ctx, NULL);
    setupTDTokenizerClass(ctx, NULL);
    setupTDTokenizerStateClass(ctx, NULL);
    setupTDWordStateClass(ctx, NULL);
    setupTDNumberStateClass(ctx, NULL);
    setupTDSymbolStateClass(ctx, NULL);
    setupTDCommentStateClass(ctx, NULL);
    setupTDQuoteStateClass(ctx, NULL);
}