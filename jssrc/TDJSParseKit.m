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
    setUpConstructor(ctx, "TokenAssembly", TDTokenAssembly_class(ctx), TDTokenAssembly_construct, &ex);
    setUpConstructor(ctx, "CharacterAssembly", TDCharacterAssembly_class(ctx), TDCharacterAssembly_construct, &ex);
    
    // Tokenization
    JSObjectRef constr = setUpConstructor(ctx, "Token", TDToken_class(ctx), TDToken_construct, &ex);
    setUpClassProperty(ctx, "EOFToken", TDToken_getEOFToken(ctx), constr, &ex); // Class property on Token constructor
    
    setUpConstructor(ctx, "Tokenizer", TDTokenizer_class(ctx), TDTokenizer_construct, &ex);
    setUpConstructor(ctx, "WordState", TDWordState_class(ctx), TDWordState_construct, &ex);
    setUpConstructor(ctx, "QuoteState", TDQuoteState_class(ctx), TDQuoteState_construct, &ex);
    setUpConstructor(ctx, "NumberState", TDNumberState_class(ctx), TDNumberState_construct, &ex);
    setUpConstructor(ctx, "SymbolState", TDSymbolState_class(ctx), TDSymbolState_construct, &ex);
    setUpConstructor(ctx, "CommentState", TDCommentState_class(ctx), TDCommentState_construct, &ex);
    setUpConstructor(ctx, "WhitespaceState", TDWhitespaceState_class(ctx), TDWhitespaceState_construct, &ex);

    // Parsers
    setUpConstructor(ctx, "Repetition", TDRepetition_class(ctx), TDRepetition_construct, &ex);

    // Collection Parsers
    setUpConstructor(ctx, "Alternation", TDAlternation_class(ctx), TDAlternation_construct, &ex);
    setUpConstructor(ctx, "Sequence", TDSequence_class(ctx), TDSequence_construct, &ex);
    
    // Terminal Parsers
    setUpConstructor(ctx, "Empty", TDEmpty_class(ctx), TDEmpty_construct, &ex);
    setUpConstructor(ctx, "Any", TDAny_class(ctx), TDAny_construct, &ex);
    
    // Token Terminals
    setUpConstructor(ctx, "Word", TDWord_class(ctx), TDWord_construct, &ex);
    setUpConstructor(ctx, "Num", TDNum_class(ctx), TDNum_construct, &ex);
    setUpConstructor(ctx, "QuotedString", TDQuotedString_class(ctx), TDQuotedString_construct, &ex);
    setUpConstructor(ctx, "Symbol", TDSymbol_class(ctx), TDSymbol_construct, &ex);
    setUpConstructor(ctx, "Comment", TDComment_class(ctx), TDComment_construct, &ex);
    setUpConstructor(ctx, "Literal", TDLiteral_class(ctx), TDLiteral_construct, &ex);
    setUpConstructor(ctx, "CaseInsensitiveLiteral", TDCaseInsensitiveLiteral_class(ctx), TDCaseInsensitiveLiteral_construct, &ex);
    setUpConstructor(ctx, "UppercaseWord", TDUppercaseWord_class(ctx), TDUppercaseWord_construct, &ex);
    setUpConstructor(ctx, "LowercaseWord", TDLowercaseWord_class(ctx), TDLowercaseWord_construct, &ex);
}
