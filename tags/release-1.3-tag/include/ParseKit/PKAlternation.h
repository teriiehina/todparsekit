//
//  PKAlternation.h
//  ParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseKit/PKCollectionParser.h>

/*!
    @class      PKAlternation
    @brief      A <tt>PKAlternation</tt> object is a collection of parsers, any one of which can successfully match against an assembly.
*/
@interface PKAlternation : PKCollectionParser {

}

/*!
    @brief      Convenience factory method for initializing an autoreleased <tt>PKAlternation</tt> parser.
    @result     an initialized autoreleased <tt>PKAlternation</tt> parser.
*/
+ (id)alternation;
@end
