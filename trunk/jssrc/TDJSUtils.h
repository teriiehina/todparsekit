//
//  TDJSUtils.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/2/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

//#define TDPreconditionInstaceOf(cls, methStr, clsStr)

#define TDPreconditionInstaceOf(cls, methStr, clsStr) \
    if (!JSValueIsObjectOfClass(ctx, this, (cls)(ctx))) { \
        NSString *s = [NSString stringWithFormat:@"calling method '%@' on an object that is not an instance of '%@'", (methStr), (clsStr)]; \
        (*ex) = TDNSStringToJSValue(ctx, s, ex); \
        return JSValueMakeUndefined(ctx); \
    }

#define TDPreconditionMethodArgc(n, meth) \
    if (argc != (n)) { \
        NSString *s = [NSString stringWithFormat:@"%@() requires %d arguments", (meth), (n)]; \
        (*ex) = TDNSStringToJSValue(ctx, s, ex); \
        return JSValueMakeUndefined(ctx); \
    }

#define TDPreconditionConstructorArgc(n, meth) \
    if (argc != (n)) { \
        NSString *s = [NSString stringWithFormat:@"%@ constructor requires %d arguments", (meth), (n)]; \
        (*ex) = TDNSStringToJSValue(ctx, s, ex); \
        return NULL; \
    }


JSValueRef TDCFTypeToJSValue(JSContextRef ctx, CFTypeRef value, JSValueRef *ex);
JSValueRef TDCFStringToJSValue(JSContextRef ctx, CFStringRef cfStr, JSValueRef *ex);
JSValueRef TDNSStringToJSValue(JSContextRef ctx, NSString *nsStr, JSValueRef *ex);
JSObjectRef TDCFArrayToJSObject(JSContextRef ctx, CFArrayRef cfArray, JSValueRef *ex);
JSObjectRef TDNSArrayToJSObject(JSContextRef ctx, NSArray *nsArray, JSValueRef *ex);
JSObjectRef TDCFDictionaryToJSObject(JSContextRef ctx, CFDictionaryRef cfDict, JSValueRef *ex);
JSObjectRef TDNSDictionaryToJSObject(JSContextRef ctx, NSDictionary *nsDict, JSValueRef *ex);

CFTypeRef TDJSValueCopyCFType(JSContextRef ctx, JSValueRef value, JSValueRef *ex);
id TDJSValueGetId(JSContextRef ctx, JSValueRef value, JSValueRef *ex);
CFStringRef TDJSValueCopyCFString(JSContextRef ctx, JSValueRef value, JSValueRef *ex);
NSString *TDJSValueGetNSString(JSContextRef ctx, JSValueRef value, JSValueRef *ex);
CFArrayRef TDJSObjectCopyCFArray(JSContextRef ctx, JSObjectRef obj, JSValueRef *ex);
CFDictionaryRef TDJSObjectCopyCFDictionary(JSContextRef ctx, JSObjectRef obj, JSValueRef *ex);

JSObjectRef TDNSErrorToJSObject(JSContextRef ctx, NSError *nsErr, JSValueRef *ex);
bool TDJSValueIsInstanceOfClass(JSContextRef ctx, JSValueRef value, char *className, JSValueRef* ex);