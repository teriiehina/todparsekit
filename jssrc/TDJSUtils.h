//
//  PKJSUtils.h
//  ParseKit
//
//  Created by Todd Ditchendorf on 1/2/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

#define TDPreconditionInstaceOf(cls, meth)
#define TDPreconditionMethodArgc(n, meth)
#define TDPreconditionConstructorArgc(n, meth)

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