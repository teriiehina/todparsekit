//
//  PKJSParseKit.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 1/10/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <TDJSParseKit/TDJSParseKit.h>
#import <ParseKit/PKToken.h>
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
#import "TDJSUppercaseWord.h"
#import "TDJSLowercaseWord.h"

static void printValue(JSContextRef ctx, JSValueRef val) {
    NSString *s = TDJSValueGetNSString(ctx, val, NULL);
    NSLog(@"%@", s);
}

static JSValueRef print(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    printValue(ctx, argv[0]); // TODO check args
    return JSValueMakeUndefined(ctx);
}

static JSObjectRef setUpFunction(JSContextRef ctx, char *funcName, JSObjectCallAsFunctionCallback funcCallback, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef funcNameStr = JSStringCreateWithUTF8CString(funcName);
    JSObjectRef func = JSObjectMakeFunctionWithCallback(ctx, funcNameStr, funcCallback);
    JSObjectSetProperty(ctx, globalObj, funcNameStr, func, kJSPropertyAttributeNone, ex);
    JSStringRelease(funcNameStr);
    return func;
}

static JSObjectRef setUpConstructor(JSContextRef ctx, char *className, JSClassRef jsClass, JSObjectCallAsConstructorCallback constrCallback, JSValueRef *ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef classNameStr = JSStringCreateWithUTF8CString(className);
    JSObjectRef constr = JSObjectMakeConstructor(ctx, jsClass, constrCallback);
    JSObjectSetProperty(ctx, globalObj, classNameStr, constr, kJSPropertyAttributeNone, ex);
    JSStringRelease(classNameStr);
    return constr;
}

static void setUpClassProperty(JSContextRef ctx, char *propName, JSValueRef prop, JSObjectRef constr, JSValueRef *ex) {
    JSStringRef propNameStr = JSStringCreateWithUTF8CString(propName);
    JSObjectSetProperty(ctx, constr, propNameStr, prop, kJSPropertyAttributeDontDelete|kJSPropertyAttributeReadOnly, NULL);
    JSStringRelease(propNameStr);
}

void TDJSParseKitSetUpContext(JSContextRef ctx) {
    JSValueRef ex = NULL;

    setUpFunction(ctx, "print", print, &ex);
    
    // Assemblies
    setUpConstructor(ctx, "PKTokenAssembly", TDTokenAssembly_class(ctx), TDTokenAssembly_construct, &ex);
    setUpConstructor(ctx, "PKCharacterAssembly", TDCharacterAssembly_class(ctx), TDCharacterAssembly_construct, &ex);
    
    // Tokenization
    JSObjectRef constr = setUpConstructor(ctx, "PKToken", TDToken_class(ctx), TDToken_construct, &ex);
    setUpClassProperty(ctx, "EOFToken", TDToken_getEOFToken(ctx), constr, &ex); // Class property on Token constructor
    
    setUpConstructor(ctx, "PKTokenizer", TDTokenizer_class(ctx), TDTokenizer_construct, &ex);
    setUpConstructor(ctx, "PKWordState", TDWordState_class(ctx), TDWordState_construct, &ex);
    setUpConstructor(ctx, "PKQuoteState", TDQuoteState_class(ctx), TDQuoteState_construct, &ex);
    setUpConstructor(ctx, "PKNumberState", TDNumberState_class(ctx), TDNumberState_construct, &ex);
    setUpConstructor(ctx, "PKSymbolState", TDSymbolState_class(ctx), TDSymbolState_construct, &ex);
    setUpConstructor(ctx, "TDCommentState", TDCommentState_class(ctx), TDCommentState_construct, &ex);
    setUpConstructor(ctx, "PKWhitespaceState", TDWhitespaceState_class(ctx), TDWhitespaceState_construct, &ex);

    // Parsers
    setUpConstructor(ctx, "PKRepetition", TDRepetition_class(ctx), TDRepetition_construct, &ex);

    // Collection Parsers
    setUpConstructor(ctx, "PKAlternation", TDAlternation_class(ctx), TDAlternation_construct, &ex);
    setUpConstructor(ctx, "PKSequence", TDSequence_class(ctx), TDSequence_construct, &ex);
    
    // Terminal Parsers
    setUpConstructor(ctx, "PKEmpty", TDEmpty_class(ctx), TDEmpty_construct, &ex);
    setUpConstructor(ctx, "PKAny", TDAny_class(ctx), TDAny_construct, &ex);
    
    // Token Terminals
    setUpConstructor(ctx, "PKWord", TDWord_class(ctx), TDWord_construct, &ex);
    setUpConstructor(ctx, "PKNum", TDNum_class(ctx), TDNum_construct, &ex);
    setUpConstructor(ctx, "PKQuotedString", TDQuotedString_class(ctx), TDQuotedString_construct, &ex);
    setUpConstructor(ctx, "PKSymbol", TDSymbol_class(ctx), TDSymbol_construct, &ex);
    setUpConstructor(ctx, "PKComment", TDComment_class(ctx), TDComment_construct, &ex);
    setUpConstructor(ctx, "PKLiteral", TDLiteral_class(ctx), TDLiteral_construct, &ex);
    setUpConstructor(ctx, "PKCaseInsensitiveLiteral", TDCaseInsensitiveLiteral_class(ctx), TDCaseInsensitiveLiteral_construct, &ex);
    setUpConstructor(ctx, "PKUppercaseWord", TDUppercaseWord_class(ctx), TDUppercaseWord_construct, &ex);
    setUpConstructor(ctx, "PKLowercaseWord", TDLowercaseWord_class(ctx), TDLowercaseWord_construct, &ex);
}
