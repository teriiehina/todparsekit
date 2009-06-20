//
//  TDWhitespace.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDTerminal.h>

/*!
    @class      TDWhitespace
    @brief      A <tt>TDWhitespace</tt> matches a number from a token assembly.
*/
@interface TDWhitespace : TDTerminal {

}

/*!
    @brief      Convenience factory method for initializing an autoreleased <tt>TDWhitespace</tt> object.
    @result     an initialized autoreleased <tt>TDWhitespace</tt> object
*/
+ (id)whitespace;
@end
