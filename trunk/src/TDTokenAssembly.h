//
//  TDTokenAssembly.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDAssembly.h>

@class TDTokenizer;

/*!
    @class      TDTokenAssembly 
    @brief      A <tt>TDTokenAssembly</tt> is a <tt>TDAssembly</tt> whose elements are <tt>TDToken</tt>s.
    @details    <tt>TDToken</tt>s are, roughly, the chunks of text that a <tt>TDTokenizer</tt> returns.
*/
@interface TDTokenAssembly : TDAssembly <NSCopying> {
    TDTokenizer *tokenizer;
    NSArray *tokens;
}

/*!
    @brief      Convenience factory method for initializing an autoreleased assembly with the tokenizer <tt>t</tt> and its string
    @param      t tokenizer whose string will be worked on
    @result     an initialized autoreleased assembly
 */
+ (id)assemblyWithTokenizer:(TDTokenizer *)t;

/*!
    @brief      Designated Initializer. Initializes an assembly with the tokenizer <tt>t</tt> and its string
    @details    Designated Initializer. Note that this is different from the <tt>TDTokenAssembly</tt> superclass in which <tt>-initWithString:</tt> is the designated initializer
    @param      t tokenizer whose string will be worked on
    @result     an initialized assembly
 */
- (id)initWithTokenzier:(TDTokenizer *)t;

+ (id)assemblyWithTokenArray:(NSArray *)a;
- (id)initWithTokenArray:(NSArray *)a;
@end
