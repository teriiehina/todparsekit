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
    NSMutableArray *tokens;
}

/*!
 @brief      Convenience factory method for initializing an autoreleased assembly with the string of <tt>t</tt>.
 @param      t tokenizer whose string will be worked on
 @result     an initialized autoreleased assembly
 */
+ (id)assemblyWithTokenizer:(TDTokenizer *)t;

/*!
 @brief      Designated Initializer. Initializes an assembly with the string of <tt>t</tt>
 @details    Designated Initializer.
 @param      t tokenizer whose string will be worked on
 @result     an initialized assembly
 */
- (id)initWithTokenzier:(TDTokenizer *)t;

/*!
    @property   tokenizer
    @brief      The tokenizer that provides the stream of tokens for this assembly.
*/
@property (nonatomic, retain) TDTokenizer *tokenizer;
@end
