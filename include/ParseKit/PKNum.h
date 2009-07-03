//
//  PKNum.h
//  ParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseKit/PKTerminal.h>

/*!
    @class      PKNum
    @brief      A <tt>PKNum</tt> matches a number from a token assembly.
*/
@interface PKNum : PKTerminal {

}

/*!
    @brief      Convenience factory method for initializing an autoreleased <tt>PKNum</tt> object.
    @result     an initialized autoreleased <tt>PKNum</tt> object
*/
+ (id)num;
@end
