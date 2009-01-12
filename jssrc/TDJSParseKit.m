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
    JSStringRef className = JSStringCreateWithUTF8CString("Token");
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
    JSStringRef className = JSStringCreateWithUTF8CString("TokenAssembly");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDTokenAssembly_class(ctx), TDTokenAssembly_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDCharacterAssemblyClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("CharacterAssembly");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDCharacterAssembly_class(ctx), TDCharacterAssembly_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDTokenizerClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("Tokenizer");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDTokenizer_class(ctx), TDTokenizer_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDWordStateClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("WordState");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDWordState_class(ctx), TDWordState_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDNumberStateClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("NumberState");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDNumberState_class(ctx), TDNumberState_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDWhitespaceStateClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("WhitespaceState");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDWhitespaceState_class(ctx), TDWhitespaceState_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDCommentStateClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("CommentState");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDCommentState_class(ctx), TDCommentState_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDQuoteStateClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("QuoteState");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDQuoteState_class(ctx), TDQuoteState_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDSymbolStateClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("SymbolState");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDSymbolState_class(ctx), TDSymbolState_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDRepetitionClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("Repetition");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDRepetition_class(ctx), TDRepetition_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDAlternationClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("Alternation");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDAlternation_class(ctx), TDAlternation_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDSequenceClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("Sequence");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDSequence_class(ctx), TDSequence_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDTrackClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("Track");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDTrack_class(ctx), TDTrack_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDEmptyClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("Empty");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDEmpty_class(ctx), TDEmpty_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDAnyClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("Any");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDAny_class(ctx), TDAny_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDWordClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("Word");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDWord_class(ctx), TDWord_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDNumClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("Num");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDNum_class(ctx), TDNum_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDQuotedStringClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("QuotedString");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDQuotedString_class(ctx), TDQuotedString_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDSymbolClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("Symbol");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDSymbol_class(ctx), TDSymbol_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDLiteralClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("Literal");
    JSObjectRef constr = JSObjectMakeConstructor(ctx, TDLiteral_class(ctx), TDLiteral_construct);
    JSObjectSetProperty(ctx, globalObj, className, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(className);
}

static void setUpTDCaseInsensitiveLiteralClass(JSContextRef ctx, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("CaseInsensitiveLiteral");
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