//
//  PKDigit.h
//  ParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/PKTerminal.h>

/*!
    @class      TDDigit 
    @brief      A <tt>TDDigit</tt> matches a digit from a character assembly.
    @details    <tt>-[TDDitgit qualifies:] returns true if an assembly's next element is a digit.
*/
@interface TDDigit : PKTerminal {

}

/*!
    @brief      Convenience factory method for initializing an autoreleased <tt>TDDigit</tt> parser.
    @result     an initialized autoreleased <tt>TDDigit</tt> parser.
*/
+ (id)digit;
@end
