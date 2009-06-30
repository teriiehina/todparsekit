//
//  TDLiteral.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseKit/PKTerminal.h>

@class PKToken;

/*!
    @class      TDLiteral 
    @brief      A <tt>TDLiteral</tt> matches a specific word from an assembly.
*/
@interface TDLiteral : PKTerminal {
    PKToken *literal;
}

/*!
    @brief      Convenience factory method for initializing an autoreleased <tt>TDLiteral</tt> object with a given string.
    @param      s the word represented by this literal
    @result     an initialized autoreleased <tt>TDLiteral</tt> object representing <tt>s</tt>
*/
+ (id)literalWithString:(NSString *)s;
@end
