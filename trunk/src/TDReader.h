//
//  TDReader.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/21/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDTypes.h>

/*!
    @class      TDReader 
    @brief      A character-stream reader that allows characters to be pushed back into the stream.
*/
@interface TDReader : NSObject {
    NSString *string;
    NSUInteger offset;
    NSUInteger length;
}

/*!
    @brief      Designated Initializer. Initializes a reader with a given string.
    @details    Designated Initializer.
    @param      s string from which to read
    @result     an initialized reader
*/
- (id)initWithString:(NSString *)s;

/*!
    @brief      Read a single UTF-16 unicode character
    @result     The character read, or TDEOF (-1) if the end of the stream has been reached
*/
- (TDUniChar)read;

/*!
    @brief      Push back a single character
    @details    moves the cursor back one position
*/
- (void)unread;

- (void)unread:(NSUInteger)count;

/*!
    @property   string
    @brief      This reader's string.
*/
@property (nonatomic, retain) NSString *string;

/*!
    @property   offset
    @brief      This reader's current offset in string
*/
@property (nonatomic, readonly) NSUInteger offset;
@end
