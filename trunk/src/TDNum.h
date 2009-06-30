//
//  TDNum.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseKit/PKTerminal.h>

/*!
    @class      TDNum
    @brief      A <tt>TDNum</tt> matches a number from a token assembly.
*/
@interface TDNum : PKTerminal {

}

/*!
    @brief      Convenience factory method for initializing an autoreleased <tt>TDNum</tt> object.
    @result     an initialized autoreleased <tt>TDNum</tt> object
*/
+ (id)num;
@end
