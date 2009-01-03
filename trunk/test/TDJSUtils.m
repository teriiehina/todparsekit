//
//  TDJSUtils.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/2/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSUtils.h"

JSValueRef TDCFTypeToJSValue(JSContextRef ctx, CFTypeRef value) {
    JSValueRef result = NULL;
    
    if (CFNumberGetTypeID() == CFGetTypeID(value)) {
        double d;
        CFNumberGetValue(value, kCFNumberDoubleType, &d);
        result = JSValueMakeNumber(ctx, d);
    } else if (CFBooleanGetTypeID() == CFGetTypeID(value)) {
        Boolean b = CFBooleanGetValue(value);
        result = JSValueMakeBoolean(ctx, b);
    } else if (CFStringGetTypeID() == CFGetTypeID(value)) {
        JSStringRef str = JSStringCreateWithCFString(value);
        result = JSValueMakeString(ctx, str);
        JSStringRelease(str);
    } else if (CFArrayGetTypeID() == CFGetTypeID(value)) {
        result = TDCFArrayToJSObject(ctx, value);
    } else if (CFDictionaryGetTypeID() == CFGetTypeID(value)) {
        result = TDCFDictionaryToJSObject(ctx, value);
    } else {
        result = JSValueMakeNull(ctx);
    }
    
    return result;
}

JSObjectRef TDCFArrayToJSObject(JSContextRef ctx, CFArrayRef cfArray) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("Array");
    JSObjectRef arrayConstr = (JSObjectRef)JSObjectGetProperty(ctx, globalObj, className, NULL);
    JSStringRelease(className);
    
    JSObjectRef obj = (JSObjectRef)JSObjectCallAsConstructor(ctx, arrayConstr, 0, NULL, NULL);

    CFIndex len = 0;
    if (NULL != cfArray) {
        len = CFArrayGetCount(cfArray);
    }
    
    CFIndex i = 0;
    for ( ; i < len; i++) {
        CFTypeRef value = CFArrayGetValueAtIndex(cfArray, i);
        JSValueRef propVal = TDCFTypeToJSValue(ctx, value);
        JSObjectSetPropertyAtIndex(ctx, obj, i, propVal, NULL);
    }
    
    return obj;
}

JSObjectRef TDCFDictionaryToJSObject(JSContextRef ctx, CFDictionaryRef cfDict) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("Object");
    JSObjectRef objConstr = (JSObjectRef)JSObjectGetProperty(ctx, globalObj, className, NULL);
    JSStringRelease(className);
    
    JSObjectRef obj = (JSObjectRef)JSObjectCallAsConstructor(ctx, objConstr, 0, NULL, NULL);
    
    if (NULL != cfDict) {
        CFIndex len = CFDictionaryGetCount(cfDict);
        CFStringRef keys[len];
        CFTypeRef values[len];
        CFDictionaryGetKeysAndValues(cfDict, (const void**)keys, (const void**)values);
        
        CFIndex i = 0;
        for ( ; i < len; i++) {
            CFStringRef key = keys[i];
            CFTypeRef value = values[i];
            
            JSStringRef propName = JSStringCreateWithCFString(key);
            JSValueRef propVal = TDCFTypeToJSValue(ctx, value);
            JSObjectSetProperty(ctx, obj, propName, propVal, kJSPropertyAttributeNone, NULL);
            JSStringRelease(propName);
        }
    }
    
    return obj;
}

CFTypeRef TDJSValueCopyCFType(JSContextRef ctx, JSValueRef value) {
    CFTypeRef result = NULL;
    
    if (JSValueIsBoolean(ctx, value)) {
        Boolean b = JSValueToBoolean(ctx, value);
        result = (b ? kCFBooleanTrue : kCFBooleanFalse);
    } else if (JSValueIsNull(ctx, value)) {
        result = NULL;
    } else if (JSValueIsNumber(ctx, value)) {
        CGFloat d = JSValueToNumber(ctx, value, NULL);
        result = CFNumberCreate(NULL, kCFNumberCGFloatType, &d);
    } else if (JSValueIsString(ctx, value)) {
        JSStringRef str = JSValueToStringCopy(ctx, value, NULL);
        result = JSStringCopyCFString(NULL, str);
        JSStringRelease(str);
    } else if (JSValueIsObject(ctx, value)) {
        if (TDJSValueIsInstanceOfClass(ctx, value, "Array", NULL)) {
            result = TDJSObjectCopyCFArray(ctx, (JSObjectRef)value);
        } else {
            result = TDJSObjectCopyCFDictionary(ctx, (JSObjectRef)value);
        }
    }
    
    return result;
}

CFArrayRef TDJSObjectCopyCFArray(JSContextRef ctx, JSObjectRef obj) {
    JSStringRef propName = JSStringCreateWithUTF8CString("length");
    JSValueRef propVal = JSObjectGetProperty(ctx, obj, propName, NULL);
    JSStringRelease(propName);
    CFIndex len = (CFIndex)JSValueToNumber(ctx, propVal, NULL);
    
    CFMutableArrayRef cfArray = CFArrayCreateMutable(NULL, len, NULL);
    
    CFIndex i = 0;
    for ( ; i < len; i++) {
        JSValueRef val = JSObjectGetPropertyAtIndex(ctx, obj, i, NULL);
        CFTypeRef cfType = TDJSValueCopyCFType(ctx, val);
        CFArraySetValueAtIndex(cfArray, i, cfType);
        
        // TODO HUH????
        //CFRelease(cfType);
    }
    
    CFArrayRef result = CFArrayCreateCopy(NULL, cfArray);
    CFRelease(cfArray);
    
    return result;
}

CFDictionaryRef TDJSObjectCopyCFDictionary(JSContextRef ctx, JSObjectRef obj) {
    JSPropertyNameArrayRef propNames = JSObjectCopyPropertyNames(ctx, obj);
    CFIndex len = JSPropertyNameArrayGetCount(propNames);
    
    CFMutableDictionaryRef cfDict = CFDictionaryCreateMutable(NULL, len, NULL, NULL);
    
    CFIndex i = 0;
    for ( ; i < len; i++) {
        JSStringRef propName = JSPropertyNameArrayGetNameAtIndex(propNames, i);
        JSValueRef val = JSObjectGetProperty(ctx, obj, propName, NULL);
        CFTypeRef cfType = TDJSValueCopyCFType(ctx, val);
        
        CFStringRef key = JSStringCopyCFString(NULL, propName);
        CFDictionarySetValue(cfDict, (const void *)key, (const void *)cfType);

        // TODO huh????
        //CFRelease(key);
        //CFRelease(cfType);
    }
    
    JSPropertyNameArrayRelease(propNames);
    CFDictionaryRef result = CFDictionaryCreateCopy(NULL, cfDict);
    CFRelease(cfDict);
    
    return result;
}

JSObjectRef TDNSErrorToJSObject(JSContextRef ctx, NSError *nsErr) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef className = JSStringCreateWithUTF8CString("Error");
    JSObjectRef errConstr = (JSObjectRef)JSObjectGetProperty(ctx, globalObj, className, NULL);
    JSStringRelease(className);
    
    JSObjectRef obj = (JSObjectRef)JSObjectCallAsConstructor(ctx, errConstr, 0, NULL, NULL);
    
    if (nsErr) {
        JSStringRef nameStr = JSStringCreateWithUTF8CString("TDParseKitError");
        JSValueRef name = JSValueMakeString(ctx, nameStr);
        JSStringRelease(nameStr);
        
        JSStringRef msgStr = JSStringCreateWithCFString((CFStringRef)[nsErr localizedDescription]);
        JSValueRef msg = JSValueMakeString(ctx, msgStr);
        JSStringRelease(msgStr);
        
        JSValueRef code = JSValueMakeNumber(ctx, [nsErr code]);
        
        JSStringRef propName = JSStringCreateWithUTF8CString("name");
        JSObjectSetProperty(ctx, obj, propName, name, kJSPropertyAttributeReadOnly|kJSPropertyAttributeDontDelete, NULL);
        JSStringRelease(propName);
        
        propName = JSStringCreateWithUTF8CString("message");
        JSObjectSetProperty(ctx, obj, propName, msg, kJSPropertyAttributeReadOnly|kJSPropertyAttributeDontDelete, NULL);
        JSStringRelease(propName);
        
        propName = JSStringCreateWithUTF8CString("code");
        JSObjectSetProperty(ctx, obj, propName, code, kJSPropertyAttributeReadOnly|kJSPropertyAttributeDontDelete, NULL);
        JSStringRelease(propName);
    }
    
    return obj;
}

bool TDJSValueIsInstanceOfClass(JSContextRef ctx, JSValueRef value, char *className, JSValueRef* ex) {
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSStringRef classNameStr = JSStringCreateWithUTF8CString(className);
    JSObjectRef constr = (JSObjectRef)JSObjectGetProperty(ctx, globalObj, classNameStr, ex);
    JSStringRelease(classNameStr);
    
    return JSValueIsInstanceOfConstructor(ctx, value, constr, NULL);
}