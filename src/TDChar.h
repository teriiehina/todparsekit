//
//  PKChar.h
//  ParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/PKTerminal.h>

/*!
    @class      TDChar 
    @brief      A <tt>TDChar</tt> matches a character from a character assembly.
    @details    <tt>-[TDChar qualifies:]</tt> returns true every time, since this class assumes it is working against a <tt>TDCharacterAssembly</tt>.
*/
@interface TDChar : PKTerminal {

}

/*!
    @brief      Convenience factory method for initializing an autoreleased <tt>TDChar</tt> parser.
    @result     an initialized autoreleased <tt>TDChar</tt> parser.
*/
+ (id)char;
@end
