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
#import "TDJSCharacterAssembly.h"
#import "TDJSWordState.h"
#import "TDJSNumberState.h"
#import "TDJSWhitespaceState.h"
#import "TDJSCommentState.h"
#import "TDJSQuoteState.h"
#import "TDJSSymbolState.h"
#import "TDJSRepetition.h"
#import "TDJSSequence.h"
#import "TDJSTrack.h"
#import "TDJSAlternation.h"
#import "TDJSEmpty.h"
#import "TDJSAny.h"
#import "TDJSWord.h"
#import "TDJSNum.h"
#import "TDJSQuotedString.h"
#import "TDJSSymbol.h"
#import "TDJSComment.h"
#import "TDJSLiteral.h"
#import "TDJSCaseInsensitiveLiteral.h"

static void printValue(JSContextRef ctx, JSValueRef val) {
    NSString *s = TDJSValueGetNSString(ctx, val, NULL);
    NSLog(@"%@", s);
}

static JSValueRef print(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef* ex) {
    printValue(ctx, argv[0]); // TODO check args
    return JSValueMakeUndefined(ctx);
}

static void setUpPrintFunction(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef printFuncName = JSStringCreateWithUTF8CString("print");
    JSObjectRef printFunc = JSObjectMakeFunctionWithCallback(ctx, printFuncName, print);
    JSObjectSetProperty(ctx, globalObj, printFuncName, printFunc, kJSPropertyAttributeNone, ex);
}

static void setUpTDTokenClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDToken");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDToken_class(ctx), TDToken_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);

    // JS Class method
//    JSStringRef propName = JSStringCreateWithUTF8CString("EOFToken");
//    JSValueRef classMethod = JSObjectMakeFunctionWithCallback(ctx, propName, TDToken_EOFToken);
//    JSObjectSetProperty(ctx, constr, propName, classMethod, kJSPropertyAttributeDontDelete|kJSPropertyAttributeReadOnly, NULL);
//    JSStringRelease(propName);

    // JS Class property
    JSStringRef propName = JSStringCreateWithUTF8CString("EOFToken");
    JSValueRef classProp = TDToken_getEOFToken(ctx);
    JSObjectSetProperty(ctx, constr, propName, classProp, kJSPropertyAttributeDontDelete|kJSPropertyAttributeReadOnly, NULL);
    JSStringRelease(propName);
    
}

static void setUpTDTokenAssemblyClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDTokenAssembly");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDTokenAssembly_class(ctx), TDTokenAssembly_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDCharacterAssemblyClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDCharacterAssembly");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDCharacterAssembly_class(ctx), TDCharacterAssembly_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDTokenizerClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDTokenizer");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDTokenizer_class(ctx), TDTokenizer_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDWordStateClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDWordState");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDWordState_class(ctx), TDWordState_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDNumberStateClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDNumberState");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDNumberState_class(ctx), TDNumberState_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDWhitespaceStateClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDWhitespaceState");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDWhitespaceState_class(ctx), TDWhitespaceState_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDCommentStateClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDCommentState");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDCommentState_class(ctx), TDCommentState_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDQuoteStateClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDQuoteState");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDQuoteState_class(ctx), TDQuoteState_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDSymbolStateClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDSymbolState");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDSymbolState_class(ctx), TDSymbolState_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDRepetitionClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDRepetition");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDRepetition_class(ctx), TDRepetition_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDAlternationClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDAlternation");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDAlternation_class(ctx), TDAlternation_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDSequenceClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDSequence");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDSequence_class(ctx), TDSequence_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDTrackClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDTrack");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDTrack_class(ctx), TDTrack_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDEmptyClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDEmpty");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDEmpty_class(ctx), TDEmpty_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDAnyClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDAny");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDAny_class(ctx), TDAny_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDWordClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDWord");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDWord_class(ctx), TDWord_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDNumClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDNum");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDNum_class(ctx), TDNum_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDQuotedStringClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDQuotedString");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDQuotedString_class(ctx), TDQuotedString_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDSymbolClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDSymbol");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDSymbol_class(ctx), TDSymbol_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDLiteralClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDLiteral");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDLiteral_class(ctx), TDLiteral_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDCaseInsensitiveLiteralClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("TDCaseInsensitiveLiteral");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDCaseInsensitiveLiteral_class(ctx), TDCaseInsensitiveLiteral_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

void TDJSParseKitSetUpContext(JSContextRef ctx) {
    setUpPrintFunction(ctx, NULL);
    
    // Assemblies
    setUpTDTokenAssemblyClass(ctx, NULL);
    setUpTDCharacterAssemblyClass(ctx, NULL);
    
    // Tokenization
    setUpTDTokenClass(ctx, NULL);
    setUpTDTokenizerClass(ctx, NULL);
    setUpTDWordStateClass(ctx, NULL);
    setUpTDNumberStateClass(ctx, NULL);
    setUpTDSymbolStateClass(ctx, NULL);
    setUpTDCommentStateClass(ctx, NULL);
    setUpTDQuoteStateClass(ctx, NULL);

    // Parsers
    setUpTDRepetitionClass(ctx, NULL);

    // Collection Parsers
    setUpTDAlternationClass(ctx, NULL);
    setUpTDSequenceClass(ctx, NULL);
    
    // Terminal Parsers
    setUpTDAnyClass(ctx, NULL);
    setUpTDEmptyClass(ctx, NULL);
    
    // Token Terminals
    setUpTDWordClass(ctx, NULL);
    setUpTDNumClass(ctx, NULL);
    setUpTDQuotedStringClass(ctx, NULL);
    setUpTDSymbolClass(ctx, NULL);
    setUpTDLiteralClass(ctx, NULL);
    setUpTDCaseInsensitiveLiteralClass(ctx, NULL);
}